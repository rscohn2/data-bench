#!/bin/bash

# XXX these configuration options are hidden
total_executor_cores=2
executor_cores=1
executor_memory=15g
jars=/spark/jars/spark-cassandra-connector-2.0.5-s_2.11.jar
jars=$jars,/spark/jars/spark-streaming-kafka-assembly_2.11-1.6.3.jar

job=customervaluation.py

/spark/bin/spark-submit \
    --master spark://spark-master.spark.svc.cluster.local:7077 \
    --total-executor-cores $total_executor_cores \
    --executor-cores $executor_cores \
    --executor-memory $executor_memory \
    --jars $jars $job
