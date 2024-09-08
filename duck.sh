#!/bin/bash

# Load environment variables
source $(dirname "$0")/config.env

# Perform the DuckDNS update
echo "Updating DuckDNS for domain $DOMAIN"
echo url="https://www.duckdns.org/update?domains=$DOMAIN&token=$TOKEN&ip=" | curl -k -o ~/duckdns/duckdns.log -K -

# Log the result
echo "DuckDNS update complete. Log available at ~/duckdns/duckdns.log"
