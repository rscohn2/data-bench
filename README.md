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
![Data Bench Logo](https://github.com/data-bench/data-bench/raw/master/images/Data_Bench_320x248.png)

## Overview

Data Bench is a new Open Source licensed data-centric workload that
Intel wants to grow into an industry accepted benchmark tool. And we
want your help! Kick the tires, tell us what we got right. More
importantly, tell us (_gently_) what we got wrong so we can fix it
together.

Technology-wise, Data Bench is a set of Docker images deployed to your
favorite cluster orchestration layer (as long as it's Kubernetes!)
that moves transactions through various Open Source components to
induce CPU and I/O loads on cluster nodes.

Today, Data Bench is an early proof of concept and we are actively
requesting your feedback and comments. Further enhancements will be
released as quick as we get them done, driving towards a full-featured
benchmark that models modern workloads.

<!--
Our [white paper][25] has more nitty-gritty information on the
workload and the future directions we see for Data Bench.
-->

### Software Architecture

In brief, transaction generators publish messages to a message
broker where subscribed transaction consumers see the messages,
service the transaction, and publish a response. 

Data Bench leverages a variety of Open Source technologies:

1. [Docker][5] - Software Container Platform
1. [Kubernetes][1] - Containerized Application Orchestration
1. [Apache Kafka][6] - Message Broker
1. [Apache Spark][7] - Large-scale Data Processing Engine
1. [Apache Cassandra][8] - Database Store

To that powerful set of Open Source goodness, we add:

* [data-bench][19]

	This repo :) It contains the orchestration configuration to deploy
	Data Bench to a Kubernetes cluster. It also houses some
	handy [ansible][15] playbooks to make configuring your cluster a
	little easier.

* [data-bench-containers][9]

	All the build infrastructure for the Docker images used in Data
	Bench. This where the transaction consumers and generators live.

* [data-bench-data][10]

	The initial data set. We've baked it into the containers (except
	for the database, which you will need to load). If you want to see the data, it's [here][26].

* [data-bench-python][11]

	Finally, we've written a python3 module focused on enabling the
	development of python Data Bench transaction generators and
	consumers.

## Installation

### Cluster Resource Planning

#### Hardware

In the test environment six machines were used:
- cassandra specific node
- kafka/zookeeper specific node
- spark-master specific node
- spark-worker specific node
- generator specific node
- consumers co-located on the spark-master node
- kubernetes master node

Bulding block machine consisted of:
- 2 socket - Intel(R) Xeon(R) CPU E5-2699 v4 @ 2.20GHz
- 256GB RAM
- 2x 800GB nvme drives
- 10G ethernet cluster network

This configuration could be replicated on fewer nodes, kafka/spark-worker are currently the most resource intensive nodes.



#### Software

Data Bench requires some initial software, known working configuration is listed below.running Data Bench

- Base operating system: we used Centos 7
- Docker - we used Centos docker distribution
- ansible playbooks for setting up the centos yum repos and proxy info
- Kubernetes - version 1.7 installed via kubeadm
- Nice to Have:
  - time synchronized hosts via ntp, ansible playbook
  
  
#### Storage

The storage requirements for the current version of Data Bench are quite minimal, due to the limited functionality of the inital release.

- Cassandra local persistent (fast) storage, on the order of 10GB for the demo database.
- Kafka/Zookeeper local persistent storage, on the order of 10GB.
- Spark Master: none
- Spark Worker: local storage, on the order of 100GB.
- generators: none
- consumers: none


### Software Prequisites

> "Build a benchmark" they said.<br>
> "It will be fun" they said.

We did a lot of the hard work for you, but you still need to bring a
computer cluster to the Data Bench party. We chose Kubernetes for our
first cluster deployment target and plan to add support for other
cluster orchestration frameworks in time. 

We know spinning up your first Kubernetes cluster can be daunting, but
we are here to help!

### First Steps

0. Install python and pip.

   **Note**: Python3 was used for development and Python2 was not tested.

0. Next, install [Ansible][15] and set up password-less ssh:

   We found ansible be to extraordinarily helpful coordinating the
   configuration and installation of cluster hardware. You can skip
   it if you like logging into all your cluster hosts and typing the
   same command a lot.

	```
	$ pip install ansible
	$ ssh-copy-id hostA
	$ ssh-copy-id hostB
	...
	$ ansible -i [inventory] all -m ping

	```
    XXX need to talk about the ansible inventory here too
	
0. Finally, install Kubernetes using [kubeadm][2]. 

   We used these instructions to bring up our cluster, just make sure
   to pay attention to the bits about installing the cluster network
   fabric. We recommend using flannel, so you'll need to pass an extra
   argument to **kubeadm** when you create the master.  We messed it
   up the first time, just trying to pass on some of our hard earned
   knowledge.

### Data Bench Deployment

You are back! The hard part is done, it's time to deploy Data Bench!

0. **Clone This Repository**

	```
	$ git clone https://github.com/Data-Bench/data-bench
	$ cd data-bench/
	$ ls -lR 
	<omg so many files>
	```
0. **Finish Configuring Cluster Nodes**

	**XXX needs to be more better**
	This is the part where we talk about labeling the nodes in the
	cluster with kubernetes labels so each of the contains knows which
	node to run on. 
	- cassandra -> use=cassandra
	- spark-master -> use=spark-master
	- spark-worker -> use=spark-worker
	- kafka -> use-kafka
	- generators -> forgot
	- consumers -> forgot, maybe use-spark-master?
	
	This builds upon work done up front in cluster resource planning.

	```
	$ ansible-playbook -i [inventory] TBD
	```

0. **Deploy Infrastructure Containers**

	```
	$ kubectl create -f data-bench/deployments/kubernetes/20kafka
	$ kubectl create -f data-bench/deployments/kubernetes/30cassandra
	$ kubectl create -f data-bench/deployments/kubernetes/40spark

	```
	
0. **Load Cassandra Database**

	Follow these [instructions][20] to get the Cassandra database
	loaded with data for the transactions to work against.

0. **Deploy Data Bench Workload Containers**

	```
	$ kubectl create -f data-bench/deployments/kubernetes/50databench
	```

0. **Verify Containers**

	```
	$ kubectl get pods --all-namespaces
	```
<!--
## Using Data Bench

### Running Data Bench

### Monitoring Data Bench

### Stopping Data Bench
-->

### What's Next?

## Notes

### Development Cluster Software
 
* [Centos 7][2] minimal install on all cluster nodes
* [kubernetes 1.7][1] installed with [kubeadm][3]
* [flannel][18] container network fabric
* [Big Data Europe 2020:Apache Spark Master 2.2.0][21]
* [Big Data Europe 2020:Apache Spark Worker 2.2.0][22]
* [Apache Kafka 0.11.0][6]
* [Apache Cassandra 3.11.0][8]
* [Spark Kafka Connector 0-10-assembly_2.11/2.1.0][23]
* [Spark Cassandra Connector 2.0.5-s_2.11][24]


## Contact

Team email contact: jeff.garelick@intel.com

Open issues and we would love to engage in discussions with you on how
to make Data Bench better. @core will get the whole team's attention.

<!--
@core will get the whole team's attention.
Send mail to Data-Bench@Intel.COM, we will write back!
Not strictly true yet.
-->

## FAQ

**Q1**: Why didn't you use my favorite cluster orchestration framework?<br>
**A1**: We had to pick one to start with. We picked kubernetes.
<br>

<!-- Q/A entry
**Q2**: <br>
**A2**:
<br>
 -->
 
[0]: http://intel.com
[1]: http://kubernetes.io
[2]: http://centos.org
[3]: https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
[4]: https://kubernetes.io/docs/getting-started-guides/minikube/
[5]: https://docker.com
[6]: https://kafka.apache.org
[7]: https://spark.apache.org
[8]: https://cassandra.apache.org
[9]: http://github.com/Data-Bench/data-bench-containers
[10]: http://github.com/Data-Bench/data-bench-data
[11]: http://github.com/Data-Bench/data-bench-python
[12]: https://docs.docker.com/docker-cloud/cloud-swarm/
[13]: http://docs.ansible.com/ansible/latest/playbooks.html
[14]: http://docs.ansible.com/ansible/latest/inventory.html
[15]: http://docs.ansible.com/ansible/latest/intro_installation.html
[16]: https://www.tecmint.com/ssh-passwordless-login-using-ssh-keygen-in-5-easy-steps/
[17]: https://kafka.apache.org/documentation/
[18]: https://coreos.com/flannel/docs/latest/
[19]: https://github.com/Data-Bench/data-bench
[20]: https://github.com/Data-Bench/data-bench-data/blob/master/docs/howto-cassandra-load.md
[21]: https://hub.docker.com/r/bde2020/spark-master/
[22]: https://hub.docker.com/r/bde2020/spark-worker/
[23]: http://central.maven.org/maven2/org/apache/spark/spark-streaming-kafka-0-10-assembly_2.11/2.1.0/
[24]: http://dl.bintray.com/spark-packages/maven/datastax/spark-cassandra-connector/2.0.5-s_2.11/
[25]: https://where-ever-white-paper-lands
[26]: http://github.com/Data-Bench/data-bench-data/source/
