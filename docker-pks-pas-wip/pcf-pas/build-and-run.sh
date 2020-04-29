#!/bin/bash
cd nginx-reverse-proxy 
cf push &
cd ../../microservice-kafka/microservice-kafka-order
cf push &
cd ../microservice-kafka-shipping
cf push &
cd ../microservice-kafka-invoicing 
cf push &
sleep 2m
cf apps
