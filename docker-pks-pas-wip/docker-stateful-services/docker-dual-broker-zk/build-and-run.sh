#!/bin/bash
cd ../../route53
chmod +x route53-kafka-postgresql.sh
./route53-kafka-postgresql.sh
cd ../microservice-kafka/
sudo ./mvnw clean package -Dmaven.test.skip=true
cd ../docker-stateful-services/docker-dual-broker-zk/
docker-compose build
docker-compose up -d
sleep 2m
docker exec mskafka_kafka_1 kafka-topics --create --topic order --replication-factor 1 --partitions 3  --zookeeper zookeeper:2181
curl -H "Content-Type: application/json" -X POST -d '{  "name": "order-connector",  "config": {    "connector.class":"io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",    "tasks.max": "1",    "topics": "order",    "key.ignore":"true",    "schema.ignore": "true",    "connection.url": "http://elasticsearch:9200",    "type.name": "order-type",    "name":"elasticsearch-sink"  }}' http://localhost:8083/connectors
echo "done"
