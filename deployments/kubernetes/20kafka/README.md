# Apache Kafka Deplopyment

This set of kubernetes configuration files creates an [Apache Kafka][2]
instance. Kafka requires that an [Apache Zookeeper][1] instance be
available to function correctly.

## Deployment Files

### 10-kafka-service.yaml 

The kafka service creates a headless service that looks for pods
labeled with role=kafka and handles the ports 2888 and 3888.
The service FQDN will resolve to:

```
kafka.default.svc.cluster.local
```
	
The service should be created before any other parts of the Apache
Kafka deployment are created.

You can check to see which pods the service has connected to using:

```
$ kubectl get endpoints
```


### 20-kafka-config.yaml 

A kubernetes ConfigMap, ```kafka-env```, provides shell environment
variables used by the command executed in the pod.


### 30-kafka-config.yaml 

A kubernetes ConfigMap, ```kafka-config```, provides the contents
of the file:

```
/usr/share/apahce-kafka/conf/server.properties
```

Edits to the kafka-config ConfigMap (or any ConfigMap) are available
transparently to the consuming pod, however whether the changes are
used automatically is dependent on the consuming service. Generally
a pod will require a restart to successfully acquire the new values
in the ConfigMap.

### 40-kafka-statefulset.yaml 

A kubernetes StatefulSet that launches one (1) Apache Kafka
instance.  The StatefulSet is used due to the more friendly pod names
and does not take advantage of any other StatefulSet features.


## Notes

### Deploying Apache Kafka

Use the following kubectl command to create an Apache Kafka
instance from the files in the current directory:

```
# kubectl create -f ./
```

This will find all the yamls in the current directory and attempt to
create kubernetes entities with them. The collation order of the
filenames corresponds to the instantiation order of each entity.

Be careful renaming the files.

[1]: https://zookeeper.apache.org
[2]: https://kafka.apache.org
