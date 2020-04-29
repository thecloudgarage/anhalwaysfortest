#!/bin/bash
cd nginx-reverse-proxy 
cf push &
echo "done"
cd ../../microservice-kafka/microservice-kafka-order
echo "directory changed"
cf push &
echo "done"
cd ../microservice-kafka-shipping
echo "directory changed"
cf push &
echo "done"
cd ../microservice-kafka-invoicing 
cf push &
echo "done"
sleep 2m
cf apps
