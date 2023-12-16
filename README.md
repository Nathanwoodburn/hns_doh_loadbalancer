# HNS DoH load balancer

## How to help
Contact Nathan.Woodburn/ via
- Email: contact@hnsdoh.com
- Discord: https://l.woodburn.au/discord

You will need a static IP address that you can host the container on.
Nathan will then add your IP to the domain which will let you create a certificate for the domain.


## Run with docker
```bash
docker run -d --name hns_doh git.woodburn.au/nathanwoodburn/hns_doh:latest
```

Then setup your favourite reverse proxy to the container on port 80

## Nodes
Load balancing to the following DNS-over-HTTPS providers:
- https://doh.hnshosting.au/dns-query
- https://easyhandshake.com:8053/dns-query
- https://doh.hnsdns.com/dns-query
- https://hs.dnssec.dev/dns-query (Temporarily down)
- https://hnsns.net/dns-query