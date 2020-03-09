#!/bin/bash
export dockerregistry=thecloudgarage
sudo docker pull wurstmeister/kafka
sudo docker pull digitalwonderland/zookeeper
sudo docker tag mskafka_apache $dockerregistry/k8s-springboot-kafka-order-management:mskafka_apache
sudo docker tag mskafka_invoicing $dockerregistry/k8s-springboot-kafka-order-management:mskafka_invoicing
sudo docker tag mskafka_shipping $dockerregistry/k8s-springboot-kafka-order-management:mskafka_shipping
sudo docker tag mskafka_order $dockerregistry/k8s-springboot-kafka-order-management:mskafka_order
sudo docker tag wurstmeister/kafka $dockerregistry/k8s-springboot-kafka-order-management:kafka
sudo docker tag digitalwonderland/zookeeper $dockerregistry/k8s-springboot-kafka-order-management:zookeeper
sudo docker tag mskafka_postgres:latest $dockerregistry/k8s-springboot-kafka-order-management:postgresql
sudo docker push $dockerregistry/k8s-springboot-kafka-order-management:mskafka_apache
sudo docker push $dockerregistry/k8s-springboot-kafka-order-management:mskafka_invoicing
sudo docker push $dockerregistry/k8s-springboot-kafka-order-management:mskafka_shipping
sudo docker push $dockerregistry/k8s-springboot-kafka-order-management:mskafka_order
sudo docker push $dockerregistry/k8s-springboot-kafka-order-management:kafka
sudo docker push $dockerregistry/k8s-springboot-kafka-order-management:postgresql
sudo docker push $dockerregistry/k8s-springboot-kafka-order-management:zookeeper
