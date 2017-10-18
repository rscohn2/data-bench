# Apache Cassandra Deplopyment

This set of kubernetes configuration files creates
an [Apache Cassandra][1] instance.

## Deployment Files

### 10-cassandra-service.yaml 

The cassandra service creates a headless service that looks for pods
labeled with role=cassandra and handles the port 9042.

The service FQDN will resolve to:

```
cassandra.default.svc.cluster.local
```
	
The service should be created before any other parts of the Apache
Cassandra deployment are created.


### 20-cassandra-env.yaml 

A kubernetes ConfigMap, ```cassandra-env```, that provides shell
environment variables used when commands are executed in the
deployment's pods and provides values for:

- CASSANDRA_HOME
- CASSANDRA_CONF

```
# kubectl describe cm cassandra-env
```


### 30-cassandra-config.yaml 

A kubernetes ConfigMap, ```cassandra-config``` for Cassandr that
provides the contents of:

- $CASSANDRA_HOME/conf/cassandra.yaml

```
# kubectl describe cm cassandra-config
```

### 40-cassandra-statefulset.yaml 

A kubernetes StatefulSet that launches one (1) Apache Cassandra master.
The StatefulSet is used due to the more friendly pod names and does
not take advantage of any other StatefulSet features.

## Notes

### Deploying Apache Cassandra

Use the following kubectl command to create an Apache Cassandra master and
worker pod from the files in the current directory:

```
# kubectl create -f ./
```

This will find all the yamls in the current directory and attempt to
create kubernetes entities with them. The collation order of the
filenames corresponds to the instantiation order of each entity.

Be careful renaming the files.


### Modifying the Shell Environment for master/slave

To make temporary changes to the cassandra-env ConfigMap, 
edit the ConfigMap with kubectl and restart the Cassandra pod.

```
# kubectl edit cm cassandra-env
# kubectl delete pod cassandra-0
```

The appropriate controllers will spin up new master and worker
pods which will pick up the changes to the cassandra-env ConfigMap.

If you have more than one cassandra-worker, it might be easier to change
the number of replicas to zero to recycle all the worker pods, e.g.:

```
# kubectl edit statefulset cassandra
.. s/replicas: N/replicas: 0/
# kubectl edit statefulset cassandra
.. s/replicas: 0/replicas: N/
```

To make persistent changes to the Apache Cassandra environment, edit
20-cassandra-env.yaml and then recycle the Cassandra pods.

```
# vi 20-cassandra-env.yaml
# kubectl apply -f 20-cassandra-env.yaml
```

The pods can be recycled by deleting the StatefulSets for master
and worker pods:
```
# kubectl delete -f 40-cassandra-statefulset.yaml
# kubectl create -f 40-cassandra-statefulset.yaml
```

The same effect can be achieved using the edit method above to
move replicas from N to 0 back to N. It's a style-thing.

### Modifying "cassandra.yaml" 

You can change the contents of the Apache Cassandra configuration file
found in $CASSANDRA_HOME/conf by editing the contents of the
cassandra-config ConfigMaps. As with changes to 20-cassandra-env.yaml,
you must recycle the pods to pick up the new contents of those files
after reloading the appropriate ConfigMap file.

[1]: https://cassandra.apache.org
