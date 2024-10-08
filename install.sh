#!/bin/bash

# Verify that script is being run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root to allow installation of dependencies."
  exit
fi

# Make sure working directory is /root
if [ "$PWD" != "/root" ]
  then echo "Please run this script from /root directory."
  exit
fi


chmod +x /root/hns_doh_loadbalancer/cert.py
chmod +x /root/hns_doh_loadbalancer/cert.sh
sudo apt-get install -y dnsdist
# Install certbot
sudo apt install snapd -y
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo cp /root/hns_doh_loadbalancer/resolved.conf /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved

# Move the conf file to the correct location
sudo cp /root/hns_doh_loadbalancer/dnsdist.conf /etc/dnsdist/dnsdist.conf
sudo cp /root/hns_doh_loadbalancer/dnsdist.service /lib/systemd/system/dnsdist.service
sudo systemctl daemon-reload

# Restart dnsdist
sudo systemctl restart dnsdist

# Install caddy
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy -y

# Move the Caddyfile to the correct location
sudo cp /root/hns_doh_loadbalancer/Caddyfile /etc/caddy/Caddyfile

# Restart caddy
sudo systemctl restart caddy

sudo certbot certonly --manual --manual-auth-hook /root/hns_doh_loadbalancer/cert.py --preferred-challenges dns -d hnsdoh.com -d *.hnsdoh.com --deploy-hook /root/hns_doh_loadbalancer/cert.sh

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install unbound
sudo apt install libunbound-dev -y

# Install Node.js
sudo apt install build-essential -y
nvm install 20.14.0
npm install -g node-gyp

# Install HSD
git clone --depth 1 --branch latest https://github.com/handshake-org/hsd.git
cd hsd
npm install --omit=dev

sudo cp /root/hns_doh_loadbalancer/hsd.service /lib/systemd/system/hsd.service
sudo systemctl daemon-reload
sudo systemctl enable hsd
sudo systemctl start hsd
