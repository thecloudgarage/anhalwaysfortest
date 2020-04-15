* Files named with suffix do-not-use SHOULD NOT BE USED

* Environmental variables to be set are noted below

### KAFKA BROKER VARIABLES (kafka-cluster.yaml)

* Change the value of the advertised listeners to the public ec2 IP address. In case you want to run all services within the same k8s cluster, then you can name this variable to "kafka-service.kafka-cluster:9092"

```
        env:
        - name: KAFKA_BROKER_ID
          value: "1"
        - name: KAFKA_ADVERTISED_LISTENERS
          value: "PLAINTEXT://3.88.5.201:31002"
        - name: KAFKA_LISTENERS
          value: "PLAINTEXT://0.0.0.0:9092"
        - name: ALLOW_PLAINTEXT_LISTENER
          value: "yes"
        - name: KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR
          value: "1"
        - name: KAFKA_ZOOKEEPER_CONNECT
          value: zoo1:2181,zoo2:2181,zoo3:2181
        - name: KAFKA_CREATE_TOPICS
          value: mytopic:5:1
```

* All other environmental variables in the k8s templates are well-defined and need not be changed

* Order, Shipping & Invoicing microservices running in the k8s cluster will connect to the KAFKA BOOTSTRAP SERVICE using k8s service names on the clusterIP. In addition, they will also connect to the postgresql database using its k8s service name on clusterIP

