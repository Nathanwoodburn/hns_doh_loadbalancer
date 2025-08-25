#!/bin/bash

# Check if script has ip address as argument
if [ -z "$1" ]; then
  # Get Node IPs
  RESOLVED_IPS=$(dig +short hnsdoh.com AAAA)
  NODE_IPS=($RESOLVED_IPS)
  if [ ${#NODE_IPS[@]} -eq 0 ]; then
    echo "No IP addresses resolved for hnsdoh.com. Exiting."
    exit 1
  fi
fi

# If script has ip address as argument, use that
if [ -n "$1" ]; then
  # Add all arguments to NODE_IPS array
  NODE_IPS=("$@")
fi



# Define the domain and host for kdig commands
TLS_HOST="hnsdoh.com"
DOH_URL="https://hnsdoh.com/dns-query"

# Loop over each IP and run the kdig commands
for NODE_IP in "${NODE_IPS[@]}"
do
    echo "Running kdig commands for NODE_IP=$NODE_IP"

    # Run the kdig commands
    kdig +tls +tls-host=$TLS_HOST @$NODE_IP dot.wdbrn TXT +short
    kdig +tls-ca +https=@$DOH_URL @$NODE_IP doh.wdbrn TXT +short
    kdig @$NODE_IP plain.wdbrn TXT +short

    echo "Completed kdig commands for NODE_IP=$NODE_IP"
    echo "--------------------------------------------"
done
