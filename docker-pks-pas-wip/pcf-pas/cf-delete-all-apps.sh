#!/bin/bash
cf delete microservices-kafka-order -f -r
sleep 5
cf delete microservices-kafka-shipping -f -r
sleep 5
cf delete microservices-kafka-invoicing -f -r
sleep 5
cf delete microservices-nginx-reverse-proxy -f -r
echo "done"
