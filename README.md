# HNS DoH load balancer

## Run a node to hellp the project
Contact Nathan.Woodburn/ via
- Email: contact@hnsdoh.com
- Discord: https://l.woodburn.au/discord

You will need a static IP address that you can host the server on.
This server needs access to these ports
- 443 (TCP) Required for DoH
- 853 (TCP/UDP) Required for DoT
- 53 (TCP/UDP) Required for Plain DNS


## Install script
Contact Nathan.Woodburn/ to get an Auth token.
Replace the token file with the token provided (this is case sensitive and must be exact).
This token is used to get a certificate for the domain.

```sh
cd /root
git clone https://git.woodburn.au/nathanwoodburn/hns_doh_loadbalancer.git
echo "TOKEN FROM NATHAN" > /root/hns_doh_loadbalancer/token
sudo hns_doh_loadbalancer/install.sh
```

## How HNS DoH load balancer works
The load balancer is using DNS load balancing to distribute the load across multiple community ran DoH servers.  
Each DoH server runs a recursive DNS server that is capable of resolving HNS names. It will respond to DNS queries over regular DNS in addition to DNS over HTTPS (DoH) and DNS over TLS (DoT).