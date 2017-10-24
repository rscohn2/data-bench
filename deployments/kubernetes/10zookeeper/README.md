# Apache Zookeeper Deplopyment

This set of kubernetes configuration files creates an [Apache Zookeeper][1]
instance using the Zookeeper that is distributed with [Apache Kafka][2].

## Deployment Files

### 10-zookeeper-service.yaml 

The zookeeper service creates a headless service that looks for pods
labeled with role=zookeeper and handles the ports 2888 and 3888.
The service FQDN will resolve to:

```
zookeeper.default.svc.cluster.local
```
	
The service should be created before any other parts of the Apache
Zookeeper deployment are created.

You can check to see which pods the service has connected to using:

```
$ kubectl get endpoints
```


### 20-zookeeper-config.yaml 

A kubernetes ConfigMap, ```zookeeper-config```, provides the contents
of the file:

```
/usr/share/apahce-kafka/conf/zookeeper.properties
```

### 30-zookeeper-statefulset.yaml 

A kubernetes StatefulSet that launches one (1) Apache Zookeeper
instance.  The StatefulSet is used due to the more friendly pod names
and does not take advantage of any other StatefulSet features.


## Notes

### Deploying Apache Zookeeper

Use the following kubectl command to create an Apache Zookeeper
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
