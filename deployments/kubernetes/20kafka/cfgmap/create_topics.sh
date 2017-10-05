#!/bin/bash
#
#   Copyright 2017 Intel Corporation
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#    

TOPICS=( CUSTOMER-VALUATION-REQUEST CUSTOMER-VALUATION-RESPONSE MARKET-STREAM )

kafka_topics=/opt/kafka/bin/kafka-topics.sh 

zookeeper="$ZOOKEEPER_SERVICE_HOST:$ZOOKEEPER_SERVICE_PORT"
replication_factor=1
partitions=1
kafka_create_flags=" --if-not-exists"


for topic in ${TOPICS[@]}; do
    echo -n "Creating TOPIC: ${topic} "
    $kafka_topics --zookeeper ${zookeeper} \
                  --create --topic ${topic} \
                  --replication-factor ${replication_factor} \
                  --partitions ${partitions} \
                  ${kafka_create_flags} >& /dev/null

    exists=`${kafka_topics} --zookeeper ${zookeeper} --list | grep -e "^${topic}$" | wc -l`
    if [ "$exists" -eq "1" ]; then
        echo "success"
    else
        echo "fail"
    fi
done
