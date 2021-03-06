#!/bin/bash

#FIRST WE WILL SET OUT ROUTE53 DNS RECORDS FOR EXTERNAL APPS TO REACH THE KAFKA BOOTSTRAP SERVER ON THIS MACHINE"

#FIND THE IP OF THE EC2 INSTANCE
if [ -z "$1" ]; then
    echo "IP not given...trying EC2 metadata...";
    IP=$( curl http://169.254.169.254/latest/meta-data/public-ipv4 )
else
    IP="$1"
fi
echo "IP to update: $IP"

#FIND THE HOSTED ZONE ID IN ROUTE53

HOSTED_ZONE_ID=$( aws route53 list-hosted-zones-by-name | jq --arg name "thecloudgarage.com." -r '.HostedZones | .[] | select(.Name=="\($name)") | .Id' | sed -r 's/.{12}//' )

echo "Hosted zone being modified: $HOSTED_ZONE_ID"

#MODIFY THE RECORDS FILE THAT WILL SUPPLIED TO UPDATE DNS RECORDS WITH EC2 IP

INPUT_JSON=$( cat route53-kafka-postgresql.json | sed "s/127\.0\.0\.1/$IP/g" )

INPUT_JSON="{ \"ChangeBatch\": $INPUT_JSON }"

#MODEIFY THE ROUTE 53 RECORDS WITH THE RECORDS FILE
aws route53 change-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" --cli-input-json "$INPUT_JSON"

#CHANGE BACK THE RECORDS FILE TO 127.0.0.1 FOR NEXT RUN

