#!/bin/bash

echo "LETS BUILD OUR SPRINGBOOT APPS USING MAVEN"

cd ../microservice-kafka/
sudo ./mvnw clean package -Dmaven.test.skip=true

echo "NOW LETS BUILD AND RUN OUR DOCKER CONTAINERS"

cd ../docker-all-in-one
docker-compose build
docker-compose up -d

echo "NOW WE ARE PAUSING THE SCRIPT FOR 2 MINUTES  TO LET OUR CLUSTER SETTLE.."
echo "AND THEN WE WILL BUILD A KAFKA TO ELASTICSEARCH CONNECT"

sleep 2m

curl -H "Content-Type: application/json" -X POST -d '{  "name": "order-connector",  "config": {    "connector.class":"io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",    "tasks.max": "1",    "topics": "order",    "key.ignore":"true",    "schema.ignore": "true",    "connection.url": "http://elasticsearch:9200",    "type.name": "order-type",    "name":"elasticsearch-sink"  }}' http://localhost:8083/connectors

echo "done"
