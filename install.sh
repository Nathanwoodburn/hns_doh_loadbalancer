#!/bin/bash

# Verify that script is being run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root to allow installation of dependencies."
  exit
fi

chmod +x cert.sh
sudo apt-get install -y dnsdist
# Install apt-add-repository
sudo apt-get install -y software-properties-common
# Install certbot
sudo apt-add-repository ppa:certbot/certbot -y
sudo apt install certbot -y
sudo certbot certonly --manual --manual-auth-hook ./cert.py --preferred-challenges dns -d hnsdoh.com --deploy-hook ./cert.sh

sudo cp ./resolved.conf /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved

# Move the conf file to the correct location
sudo cp ./dnsdist.conf /etc/dnsdist/dnsdist.conf
# Replace the user and group in the dnsdist.service file to root
# Like this
# User=root
# Group=root
sudo cp ./dnsdist.service /lib/systemd/system/dnsdist.service
sudo systemctl daemon-reload

# Restart dnsdist
sudo systemctl restart dnsdist