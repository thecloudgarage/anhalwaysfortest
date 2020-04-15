kubectl create -f kafka-microservices-namespace.yaml
sleep 10
kubectl create -f standard-storage-class.yaml
sleep 10
kubectl create -f postgresql-pvc.yaml
sleep 2m
kubectl create -f postgresql-service.yaml
sleep 20
kubectl create -f postgresql-cluster.yaml
sleep 2m
kubectl create -f zookeeper-service.yaml
sleep 20
kubectl create -f zookeeper-cluster.yaml
sleep 2m
kubectl create -f kafka-service.yaml
sleep 20
kubectl create -f kafka-cluster.yaml
sleep 2m
kubectl create -f microservices-kafka-order-service.yaml
sleep 20
kubectl create -f microservices-kafka-order.yaml
sleep 20
kubectl create -f microservices-kafka-shipping-service.yaml
sleep 20
kubectl create -f microservices-kafka-shipping.yaml
sleep 20
kubectl create -f microservices-kafka-invoicing-service.yaml
sleep 20
kubectl create -f microservices-kafka-invoicing.yaml
sleep 1m
kubectl create -f apache-web-proxy-service.yaml
sleep 2m
kubectl create -f apache-web-proxy.yaml
echo "done"
