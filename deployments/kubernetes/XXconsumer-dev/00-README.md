# Apache Spark Development Deplopyment

This set of kubernetes configuration files creates an Apache Spark
development instance. The instance is for developing Apache Spark
applications. The consumer-dev container shares the spark-env
ConfigMap defined in ../40spark/20-environment.yaml and shared
by both the Spark master and Spark workers. The consumer-dev's
configuration files are defined in the ConfigMap consumer-dev-config
which is defined in 10-consumer-dev-config.yaml in this directory.

The Spark master cluster URL is:

```
  spark://spark-master.default.svc.cluster.local:7077
```

and should be available in the shell environment with the
CLUSTER_MASTER variable.  The FQDN version of the name is
not strictly necessary, but disambiguates which spark-master
service to use if many are present in the cluster.

## Deployment Files

### 10-consumer-dev-config.yaml 

A kubernetes ConfigMap, ```consumer-dev-config```, for the consumer
that provides the contents of:

- $SPARK_HOME/conf/spark-env.sh
- $SPARK_HOME/conf/spark-defaults.conf

```
  # kubectl describe cm consumer-dev-config
```

### 20-consumer-dev-statefulset.yaml 

A kubernetes StatefulSet that launches one (1) Apache Spark consumer
development pod. The StatefulSet is used due to the more friendly pod
names and does not take advantage of any other StatefulSet features.

The consumer-dev pod uses the Docker image databench/apache-spark-dev
which is based on databench/apache-spark-basic and includes the following
[ClearLinux][1] bundles:

- sysadmin-basic
- network-basic
- editors

## Notes

### Deploying Apache Spark

Use the following kubectl command to create an Apache Spark consumer
development pod from the files in the current directory:

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
# kubectl delete pod consumer-dev-0
# kubectl delete pod consumer-dev-0
```

The appropriate controllers will spin up new master and worker
pods which will pick up the changes to the spark-env ConfigMap.

If you have more than one spark-worker, it might be easier to change
the number of replicas to zero to recycle all the worker pods, e.g.:

```
# kubectl edit statefulset consumer-dev
.. s/replicas: N/replicas: 0/
# kubectl edit statefulset consumer-dev
.. s/replicas: 0/replicas: N/
```

To make persistent changes to the Apache Spark environment, edit
20-environment.yaml and then recycle the Spark pods.

```
# vi 10-consumer-dev-config.yaml
# kubectl apply -f 10-consumer-dev-config.yaml
```

The pods can be recycled by deleting the StatefulSets for master
and worker pods:
```
# kubectl delete -f 20-consumer-dev-statefulset.yaml
# kubectl create -f 20-consumer-dev-statefulset.yaml
```

The same effect can be achieved using the edit method above to
move replicas from N to 0 back to N. It's a style-thing.


### Modifying "spark-defaults.conf" or "spark-env.sh"

You can change the contents of the Apache Spark configuration files
usually found in $SPARK_HOME/conf by editing the contents of the
consumer-dev-config ConfigMaps.






