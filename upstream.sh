#!/bin/bash

# This script is used to test an upstream server.


# Also can test with
# So test using https://dohjs.org/
# Get name of server from command line
SERVER=$1

# Test Domains
TXTDOMAIN="test.apihns"
HTTPDOMAIN="nathan.woodburn"

# Test DNS over HTTPS via GET request
GetStandard=$(curl --silent -H 'accept: application/dns-json' 'https://'$SERVER'/dns-query?name='$TXTDOMAIN'&type=TXT')
# Verify that the response is not empty and has an answer of TXT with content "Test"
test=$(jq -e '.Answer[] | select(.type == 16)' <<< $GetStandard)
if [ $test ]; then
    echo "DNS over HTTPS GET plain request test passed with content:"
    echo $test | jq .
else
    echo "DNS over HTTPS GET plain request test failed"
fi


# Test using curl
curltest=$(curl --silent --doh-url https://$SERVER/dns-query http://$HTTPDOMAIN)
# Verify that the response is not empty and has text "Nathan.Woodburn/"
if [[ $curltest == *"Nathan.Woodburn/"* ]]; then
    echo "DNS over HTTPS curl test passed"
else
    echo "DNS over HTTPS curl test failed"
fi

# Test DoT
# Get the IP address of the server
IP=$(dig +short $SERVER)
# Test using kdig
kdigtest=$(kdig +tls-ca +tls-host=$SERVER $TXTDOMAIN @$IP TXT)
# Verify that the response is not empty and has text "Test"
if [[ $kdigtest == *"Test"* ]]; then
    echo "DNS over TLS kdig test passed"
else
    echo "DNS over TLS kdig test failed"
fi

# Plain DNS
# Test using dig
digtest=$(dig $TXTDOMAIN @$SERVER TXT)
# Verify that the response is not empty and has text "Test"
if [[ $digtest == *"Test"* ]]; then
    echo "Plain DNS dig test passed"
else
    echo "Plain DNS dig test failed"
fi