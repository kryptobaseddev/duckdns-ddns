#!/bin/bash

# Load environment variables
# source $(dirname "$0")/config.env

# Perform the DuckDNS update
echo "Updating DuckDNS for domain"
echo url="https://www.duckdns.org/update?domains=<REPLACE WITH YOUR DOMAIN>&token=<REPLACE WITH YOUR TOKEN>&ip=" | curl -k -o ~/duckdns-ddns/duckdns.log -K -

# Log the result
echo "DuckDNS update complete. Log available at ~/duckdns-ddns/duckdns.log"
