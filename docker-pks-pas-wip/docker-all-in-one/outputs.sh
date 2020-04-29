#!/bin/bash
docker exec mskafka_kafka_1 kafka-topics --describe --zookeeper zookeeper:2181 --topic order

docker exec mskafka_kafka_1 kafka-consumer-groups  --list --bootstrap-server kafka:9092

docker exec mskafka_kafka_1 kafka-consumer-groups --describe --group shipping --bootstrap-server kafka:9092

docker exec mskafka_kafka_1 kafka-consumer-groups --describe --group invoicing --bootstrap-server kafka:9092

docker exec mskafka_kafka_1 kafka-topics --alter --zookeeper zookeeper:2181 --topic order --partitions 2

docker exec mskafka_kafka_1 kafka-topics --describe --zookeeper zookeeper:2181 --topic order

docker exec mskafka_kafka_1 kafka-consumer-groups  --list --bootstrap-server kafka:9092

docker exec mskafka_kafka_1 kafka-consumer-groups --describe --group shipping --bootstrap-server kafka:9092

docker exec mskafka_kafka_1 kafka-consumer-groups --describe --group invoicing --bootstrap-server kafka:9092
