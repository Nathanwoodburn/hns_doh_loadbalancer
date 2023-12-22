#!/bin/bash

# Verify that script is being run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root to allow installation of dependencies."
  exit
fi

chmod +x cert.sh
sudo apt-get install -y dnsdist
# Install certbot
sudo apt install snapd
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

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