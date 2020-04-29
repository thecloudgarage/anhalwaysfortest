#!/bin/bash
cd ../microservice-kafka/
sudo ./mvnw clean package -Dmaven.test.skip=true

cd ../docker-all-in-one
docker-compose build
docker-compose up -d

docker exec mskafka_kafka_1 kafka-topics --describe --zookeeper zookeeper:2181 --topic order
docker exec mskafka_kafka_1 kafka-consumer-groups  --list --bootstrap-server kafka:9092
docker exec mskafka_kafka_1 kafka-consumer-groups --describe --group shipping --bootstrap-server kafka:9092
docker exec mskafka_kafka_1 kafka-consumer-groups --describe --group invoicing --bootstrap-server kafka:9092
docker exec mskafka_kafka_1 kafka-topics --alter --zookeeper zookeeper:2181 --topic order --partitions 2
docker exec mskafka_kafka_1 kafka-topics --describe --zookeeper zookeeper:2181 --topic order
docker exec mskafka_kafka_1 kafka-consumer-groups  --list --bootstrap-server kafka:9092
docker exec mskafka_kafka_1 kafka-consumer-groups --describe --group shipping --bootstrap-server kafka:9092
docker exec mskafka_kafka_1 kafka-consumer-groups --describe --group invoicing --bootstrap-server kafka:9092

sleep 2m

curl -H "Content-Type: application/json" -X POST -d '{  "name": "order-connector",  "config": {    "connector.class":"io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",    "tasks.max": "1",    "topics": "order",    "key.ignore":"true",    "schema.ignore": "true",    "connection.url": "http://elasticsearch:9200",    "type.name": "order-type",    "name":"elasticsearch-sink"  }}' http://localhost:8083/connectors

echo "done"
