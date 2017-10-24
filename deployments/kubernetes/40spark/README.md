# Apache Spark Deplopyment

This set of kubernetes configuration files creates an [Apache Spark][1]
master instance and any number of Apache Spark worker instances.

## Deployment Files

### 10-master-service.yaml 

The master service creates a headless service that looks for pods
labeled with role=spark-master and handles the ports 8080 and 7077.
The service FQDN will resolve to:

```
spark-master.default.svc.cluster.local
```
	
The service should be created before any other parts of the Apache
Spark deployment are created.


### 20-shared-env.yaml 

A kubernetes ConfigMap, ```spark-shared-env```, that is shared by both the
Apache Spark master and workers. Items defined in the ```data:```
stanza will be included in the shell environment of both the master
and worker instances.

```
# kubectl describe cm spark-env
```


### 30-master-config.yaml 

A kubernetes ConfigMap, ```spark-master-config``` for the master that
provides the contents of:

- $SPARK_HOME/conf/spark-env.sh
- $SPARK_HOME/conf/spark-defaults.conf

```
# kubectl describe cm spark-master-config
```

### 40-master-statefulset.yaml 

A kubernetes StatefulSet that launches one (1) Apache Spark master.
The StatefulSet is used due to the more friendly pod names and does
not take advantage of any other StatefulSet features.

### 50-worker-config.yaml 

A kubernetes ConfigMap for workers that provides the contents of:
- $SPARK_HOME/conf/spark-env.sh
- $SPARK_HOME/conf/spark-defaults.conf

### 60-worker-statefulset.yaml 

A kubernetes StatefulSet that launches one or more Apache Spark
workers (default=1). The StatefulSet is used for the more user
friendly pod names. Workers are configured to rendezvous with the
server via the service address using the environment variable
CLUSTER_MASTER defined in the spark-env configmap.

```
CLUSTER_MASTER=spark://spark-master.default.svc.cluster.local:7077
```

## Notes

### Deploying Apache Spark

Use the following kubectl command to create an Apache Spark master and
worker pod from the files in the current directory:

```
# kubectl create -f ./
```

This will find all the yamls in the current directory and attempt to
create kubernetes entities with them. The collation order of the
filenames corresponds to the instantiation order of each entity.

Be careful renaming the files.


### Modifying the Shell Environment for master/slave

To make temporary changes to the spark-env ConfigMap, 
edit the ConfigMap with kubectl and restart the master
and worker pods.

```
# kubectl edit cm spark-env
# kubectl delete pod spark-master-0
# kubectl delete pod spark-worker-0
```

The appropriate controllers will spin up new master and worker
pods which will pick up the changes to the spark-env ConfigMap.

If you have more than one spark-worker, it might be easier to change
the number of replicas to zero to recycle all the worker pods, e.g.:

```
# kubectl edit statefulset spark-worker
.. s/replicas: N/replicas: 0/
# kubectl edit statefulset spark-worker
.. s/replicas: 0/replicas: N/
```

To make persistent changes to the Apache Spark environment, edit
20-shared-env.yaml and then recycle the Spark pods.

```
# vi 20-shared-env.yaml
# kubectl apply -f 20-shared-env.yaml
```

The pods can be recycled by deleting the StatefulSets for master
and worker pods:
```
# kubectl delete -f 60-worker-statefulset.yaml
# kubectl delete -f 40-master-statefulset.yaml
# kubectl create -f 40-master-statefulset.yaml
# kubectl create -f 60-worker-statefulset.yaml
```

The same effect can be achieved using the edit method above to
move replicas from N to 0 back to N. It's a style-thing.


### Modifying "spark-defaults.conf" or "spark-env.sh"

You can change the contents of the Apache Spark configuration files
found in $SPARK_HOME/conf by editing the contents of the
spark-master-config or spark-worker-config ConfigMaps. As with changes
to 20-shared-env.yaml, you must recycle the pods to pick up the new
contents of those files after reloading the appropriate ConfigMap
file.


### Necessary Contents of 20-shared-env.yaml

The variable ```SPARK_NO_DAEMONIZE=1``` in 20-shared-env.yaml is
required. It's presense causes the start-master.sh and start-slave.sh
shell scripts to run in the foreground. The default behavior is to run
the master and slave processes in the background, however kubernetes
interprets this behavior as the container dying and restarts it ad
infinitum.

[1]: https://spark.apache.org

