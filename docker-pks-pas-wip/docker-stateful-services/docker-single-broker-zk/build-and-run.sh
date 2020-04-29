#!/bin/bash

#FIRST WE WILL SET OUT ROUTE53 DNS RECORDS FOR EXTERNAL APPS TO REACH THE KAFKA BOOTSTRAP SERVER ON THIS MACHINE"

if [ -z "$1" ]; then
    echo "IP not given...trying EC2 metadata...";
    IP=$( curl http://169.254.169.254/latest/meta-data/public-ipv4 )
else
    IP="$1"
fi
echo "IP to update: $IP"

HOSTED_ZONE_ID=$( aws route53 list-hosted-zones-by-name | jq --arg name "thecloudgarage.com." -r '.HostedZones | .[] | select(.Name=="\($name)") | .Id' | sed -r 's/.{12}//' )

echo "Hosted zone being modified: $HOSTED_ZONE_ID"

INPUT_JSON=$( cat ../../route53/route53-kafka.json | sed "s/127\.0\.0\.1/$IP/" )

INPUT_JSON="{ \"ChangeBatch\": $INPUT_JSON }"

aws route53 change-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" --cli-input-json "$INPUT_JSON"

#NEXT WE BUILD OUR APPLICATIONS
cd ../../microservice-kafka/
sudo ./mvnw clean package -Dmaven.test.skip=true
cd ../docker-stateful-services/docker-single-broker-zk/

#NEXT WE BUILD AN RUN OUR CONTAINERS
docker-compose build
docker-compose up -d

#NEXT WE CREATE A KAFKA ELASTICSEARCH CONNECTOR
sleep 2m
docker exec mskafka_kafka_1 kafka-topics --create --topic order --replication-factor 1 --partitions 3  --zookeeper zookeeper:2181
curl -H "Content-Type: application/json" -X POST -d '{  "name": "order-connector",  "config": {    "connector.class":"io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",    "tasks.max": "1",    "topics": "order",    "key.ignore":"true",    "schema.ignore": "true",    "connection.url": "http://elasticsearch:9200",    "type.name": "order-type",    "name":"elasticsearch-sink"  }}' http://localhost:8083/connectors
echo "done"
