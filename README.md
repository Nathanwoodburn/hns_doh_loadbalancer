# HNS DoH load balancer

## How to help
Contact Nathan.Woodburn/ via
- Email: contact@hnsdoh.com
- Discord: https://l.woodburn.au/discord

You will need a static IP address that you can host the container on.
Nathan will then add your IP to the domain which will let you create a certificate for the domain.


## Install script
```sh
git clone https://git.woodburn.au/nathanwoodburn/hns_doh_loadbalancer.git
cd hns_doh_loadbalancer
sudo ./install.sh
```




## Nodes
Load balancing to the following DNS-over-HTTPS providers:
| Provider         | URL                                      | DoH JSON | DoH Wire | DoT | DNS | HIP05 |
| ---------------- | ---------------------------------------- | -------- | -------- | --- | --- | ----- |
| Nathan.Woodburn/ | https://doh.hnshosting.au/dns-query      | Yes      | Yes      | Yes | Yes | Yes   |
| HNS DNS          | https://doh.hnsdns.com/dns-query         | Yes      | Yes      | No  | Yes | Yes   |
| HNS NS           | https://hnsns.net/dns-query              | Yes      | Yes      | No  | No  | Yes   |
| Impervious       | https://hs.dnssec.dev/dns-query          | No       | Yes      | Yes | No  | Yes   |


## Maybe future nodes
| Provider         | Reason to not be added     | URL                                      | DoH JSON | DoH Wire | DoT | DNS | HIP05 |
| ---------------- | -------------------------- | ---------------------------------------- | -------- | -------- | --- | --- | ----- |
| EasyHandshake    | Doesn't have HIP5 support  | https://easyhandshake.com:8053/dns-query | Yes      | Yes      | No  | No  | No    |
| HDNS             | Only supports NB domains   | https://hdns.io                          | No       | Yes      | No  | Yes | No    |


- https://doh.hnshosting.au/dns-query
- https://easyhandshake.com:8053/dns-query
- https://doh.hnsdns.com/dns-query
- https://hs.dnssec.dev/dns-query (Currently not enabled)
- https://hnsns.net/dns-query