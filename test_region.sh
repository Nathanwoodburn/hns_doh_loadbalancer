#!/bin/bash

REGION_IDS=("au" "eu" "na" "as" "ap")

if [ -z "$1" ]; then
    for REGION_ID in "${REGION_IDS[@]}"
    do
        echo "--------------------------------------------"
        echo "Running test for $REGION_ID"
        echo "--------------------------------------------"
        ./test_region.sh $REGION_ID
        echo "Completed test for $REGION_ID"
        echo "--------------------------------------------"
    done
    exit 0
else
  REGION_ID=$1
fi
# Check if IP is specified
if [ -z "$2" ]; then
    RESOLVED_IPS=$(dig +short $REGION_ID.hnsdoh.com)
    NODE_IPS=($RESOLVED_IPS)
    if [ ${#NODE_IPS[@]} -eq 0 ]; then
        echo "No IP addresses resolved for $REGION_ID.hnsdoh.com. Exiting."
        exit 1
    fi
else
    NODE_IPS=("$2")
fi





# Define the domain and host for kdig commands
TLS_HOST="$REGION_ID.hnsdoh.com"
DOH_URL="https://$REGION_ID.hnsdoh.com/dns-query"

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
