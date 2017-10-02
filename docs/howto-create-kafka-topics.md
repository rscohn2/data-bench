<!--

   Copyright 2017 Intel Corporation

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

-->

# Create Kafka Topics

0. ** Log into the kafka container**
 
```
# kubectl exec -it kafka-0 --namespace kafka -- /bin/bash
```

0. ** Create the topics**
 
The following commands will create the topics, in this case with replication factor 1 and 1 partition, should be adjusted (and scripted) once we get further along
ZOOKEEPER_SERVICE_HOST / ZOOKEEPER_SERVICE_PORT are both set by default in this environment

 ```
$ /opt/kafka/bin/kafka-topics.sh --zookeeper $ZOOKEEPER_SERVICE_HOST:$ZOOKEEPER_SERVICE_PORT --create --topic MARKET-STREAM --replication-factor 1 --partitions 1 
$ /opt/kafka/bin/kafka-topics.sh --zookeeper $ZOOKEEPER_SERVICE_HOST:$ZOOKEEPER_SERVICE_PORT --create --topic CUSTOMER-VALUATION-REQUEST --replication-factor 1 --partitions 1 
$ /opt/kafka/bin/kafka-topics.sh --zookeeper $ZOOKEEPER_SERVICE_HOST:$ZOOKEEPER_SERVICE_PORT --create --topic CUSTOMER-VALUATION-RESPONSE --replication-factor 1 --partitions 1 
 ```
Please note that the output of these commands will be mixed in with STDERR/STDOUT from the zookeeper process, in this current container, so there is some searching needed to find the “output”

To check that the topics were created properly:
```
$ /opt/kafka/bin/kafka-topics.sh --zookeeper $ZOOKEEPER_SERVICE_HOST:$ZOOKEEPER_SERVICE_PORT --list 
```
Expected Output:
- CUSTOMER-VALUATION-REQUEST
- CUSTOMER-VALUATION-RESPONSE
- MARKET-STREAM

0. **Test the topics**

Using console-consumer:

```
$ /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server kafka-0.broker.kafka.svc.cluster.local:9092 --topic MARKET-STREAM --from-beginning
```

If there is no output (perhaps the generators are not running), then use the console-producer to put data onto the topic

```
$ /opt/kafka/bin/kafka-console-producer.sh --broker-list  kafka-0.broker.kafka.svc.cluster.local:9092 --topic MARKET-STREAM
```

