# HNS DoH load balancer

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