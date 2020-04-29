#!/bin/bash

echo "LETS BUILD OUR SPRINGBOOT APPS USING MAVEN"

cd ../microservice-kafka/
sudo ./mvnw clean package -Dmaven.test.skip=true

echo "NOW LETS BUILD AND RUN OUR DOCKER CONTAINERS"

cd ../docker-all-in-one
docker-compose build
docker-compose up -d

echo -e "\e[45mNOW IT'S TIME TO OBSERVE KAFKA"
echo -e "\e[45mLET'S START BY LOOKING INTO THE ORDER TOPIC"
docker exec mskafka_kafka_1 kafka-topics --describe --zookeeper zookeeper:2181 --topic order

echo -e "\e[44mLET'S MOVE TO VIEW THE LIST OF SUBSCRIBED CONSUMERS. THESE ARE APPLICATIONS THAT ARE LISTENING TO THE TOPIC"
docker exec mskafka_kafka_1 kafka-consumer-groups  --list --bootstrap-server kafka:9092

echo -e "\e[40mNOW IF WE OBSERVE THE INDIVIDUAL CONSUMER GROUPS, SHIPPING...YOU WILL SEE THE NUMBER OF PARTITIONS, etc."
docker exec mskafka_kafka_1 kafka-consumer-groups --describe --group shipping --bootstrap-server kafka:9092

echo -e "\e[104mSIMILARLY, LET'S SEE THE SAME FOR INVOICING"
docker exec mskafka_kafka_1 kafka-consumer-groups --describe --group invoicing --bootstrap-server kafka:9092

echo -e "\e[45mNOW IN CASE WE INCREASE OUR PARTITIONS, IT WILL HELP HORIZONTAL SCALING OF INDIVIDUAL CONSUMER GROUP INSTANCES"
echo -e "\e[44mLET'S ALTER AND INCREASE THE PARTITION COUNT"
docker exec mskafka_kafka_1 kafka-topics --alter --zookeeper zookeeper:2181 --topic order --partitions 2
echo -e "\e[45m"
docker exec mskafka_kafka_1 kafka-topics --describe --zookeeper zookeeper:2181 --topic order
echo -e "\e[44m"
docker exec mskafka_kafka_1 kafka-consumer-groups  --list --bootstrap-server kafka:9092
echo -e "\e[45m"
docker exec mskafka_kafka_1 kafka-consumer-groups --describe --group shipping --bootstrap-server kafka:9092
echo -e "\e[44m"
docker exec mskafka_kafka_1 kafka-consumer-groups --describe --group invoicing --bootstrap-server kafka:9092

echo -e "\e[45mNOW WE ARE PAUSING THE SCRIPT TO LET OUR CLUSTER SETTLE.. AND THEN WE WILL BUILD A KAFKA TO ELASTICSEARCH CONNECT"
sleep 2m

curl -H "Content-Type: application/json" -X POST -d '{  "name": "order-connector",  "config": {    "connector.class":"io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",    "tasks.max": "1",    "topics": "order",    "key.ignore":"true",    "schema.ignore": "true",    "connection.url": "http://elasticsearch:9200",    "type.name": "order-type",    "name":"elasticsearch-sink"  }}' http://localhost:8083/connectors

echo "\E[49mdone"
