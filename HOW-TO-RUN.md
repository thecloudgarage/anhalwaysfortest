# How to Run

This is a step-by-step guide how to run the example:

## Preparing a linux host

* Avail of a linux host running ubuntu 18.04. This will be used to run all scripts, deployments, etc...

* Clone this repo and navigate to sub-directory prep-work

* Here you will find a bash script helper.sh. This script installs various tools/utilities

```
sudo su
chmod +x helper.sh
./helper.sh
```
### Tools/Utilies that will automatically get installed via helper.sh
    * Docker
    * Docker Compose
    * AWS CLI 
    * PKS CLI
    * CF CLI
    * KOPS
    * Kubectl
    * OpenJDK 1.8 

* Create the AWS IAM user with admin privileges and obtain the required keys (NOT REQUIRED IF PLANNING TO RUN VIA DOCKER COMPOSE ONLY)
* Common commands that will be generally used during the activity are stored in the same sub-directory (filename: commands.txt)
* Configure AWS CLI (aws configure) using the obtained keys (NOT REQUIRED IF PLANNING TO RUN VIA DOCKER COMPOSE ONLY)


## Running Locally via Docker-Compose

* Before starting, login into the respective docker registry and alter the registry value in dockerpush.sh

```
cd docker
chmod +x build-and-run.sh
./build-and-run.sh
```

* Kafka & Postgresql entries are made via environmental variables
* Kafka host is auto-injected via "SPRING_KAFKA_BOOTSTRAP_SERVERS' env variable
* Postgresql host is set via "postgresql" env variable (leveraged in application.properties)


## Deploying on k8s (Any cluster is OK, in this case we have used PKS)

* Using PKS CLI create your k8s cluster (optionally, if are using KOPS, then use the KOPS method to create the cluster)

```
pks login -a api.pks.thecloudgarage.com -u <username> -p <password> -k
pks create-cluster <cluster-name> --external-hostname <cluster-name>.pks.<domain-name>.com --plan medium --num-nodes 3
pks cluster <cluster-name>
```

* Once cluster is ready, either edit the /etc/hosts or create DNS records for your cluster's Master via the --external-hostname value
* Next start working with kubectl to deploy your applications
* The deploy-everthing.sh script will create all resources in the appropriate sequence
* Note the use of varying sleep timers to resolve any unment resource dependency in the sequence

>>>EDIT THE ENVIRONMENTAL VARIABLES

* Navigate to k8s subdirectory and edit the kafka-cluster.yaml file.
* Change the value of the advertised listeners to the public ec2 IP address. 
* OPTIONAL: In case you want to run all services within the same k8s cluster and not perform parallel deployments on PAS for microservices, then you can name this variable to "kafka-service.kafka-cluster:9092"


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

* Once environmental variables are set in the kafka-cluster.yaml. Continue with the below commands

```
sudo su
pks get-credentials <cluster-name>
kubectl config use-context <cluster-name>
cd k8s
chmod +x deploy-everything.sh
./deploy-everything.sh
```

* Verify the resource creations. If any errors., have fun troubleshooting!

```
kubectl get pods -n kafka-cluster
kubectl get services -n kafka-cluster
kubectl get pvc
kubectl get pods 
kubectl get services
```

* Browse to any of the cluster's worker node's public-ec2-ip:31001 (nodePort value is set for apache web-proxy. You can change it)
* Verify the application workflows

### Observing kafka events

```
kubectl get pods -n kafka-cluster
kubectl exec -it <kafka-pod-value> /bin/bash -n kafka-cluster
kafka-console-consumer --bootstrap-server <afka-service.kafka-cluster:9092 --topic order --from-beginning
```

* Typical output: Example event structure
```
{"id":7,"customer":{"customerId":1,"name":"Wolff","firstname":"Eberhard","email":"eberhard.wolff@gmail.com"},"updated":1583563036580,"shippingAddress":{"street":"d1406, brigade gardenia, jardine block,","zip":"560078","city":"bangalore"},"billingAddress":{"street":"d1406, brigade gardenia, jardine block,","zip":"560078","city":"bangalore"},"orderLine":[{"count":10,"item":{"itemId":3,"name":"iPod","price":42.0}},{"count":20,"item":{"itemId":3,"name":"iPod","price":42.0}}],"numberOfLines":2}
```


### Deploying on Cloud Foundry

* Ensure that you are logged into your cloud-foundry platform, e.g. cf login -a api.system.<domain-name>.com --skip-ssl-validation
* The sub-directory pcf-pas has a manifest file that deploys all the microservices and a nginx web-proxy
   
>>>Change ENV VARIABLES manifest.yml. ONLY the IP addresses have to change. These have to be the public ec2 IP of any of the WORKER nodes. Port values are set to nodePort values hardcoded in the kafka service template and postgresql service template. So no need to change those in manifest.yml

* Appropriately change the settings in nginx.conf to match your cloud-foundry environment
   
```
cd pcf-pas
cf push
```

## UN-WIND

```
cd pcf-pas
chmod +x delete-all-apps.sh
cd ..
cd docker
chmod +x destroy-everything.sh
pks delete-cluster <cluster-name>
```
