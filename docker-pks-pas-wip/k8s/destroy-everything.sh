#!/bin/bash
kubectl delete deployment apache
sleep 5
kubectl delete deployment order
sleep 5
kubectl delete deployment shipping
sleep 5
kubectl delete deployment invoicing
sleep 5
kubectl delete deployment postgresql
sleep 5
kubectl delete deployment kafka-deployment -n kafka-cluster
sleep 5
kubectl delete deployment zookeeper-deployment-1 -n kafka-cluster
sleep 5
kubectl delete deployment zookeeper-deployment-1 -n kafka-cluster
sleep 5
kubectl delete deployment zookeeper-deployment-1 -n kafka-cluster
sleep 5
kubectl delete service apache
sleep 5
kubectl delete service order
sleep 5
kubectl delete service shipping
sleep 5
kubectl delete service invoicing
sleep 5
kubectl delete service postgresql
sleep 5
kubectl delete service zoo1 -n kafka-cluster
sleep 5
kubectl delete service zoo2 -n kafka-cluster
sleep 5
kubectl delete service zoo3 -n kafka-cluster
sleep 5
kubectl delete pvc postgres
sleep 5
kubectl delete storageclass standard
echo "done"
