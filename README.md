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
# Data Bench

![Logo]([logo])

## Overview

Data Bench is a brand new data-centric workload that Intel wants to
grow into an industry accepted benchmark tool. And we want your
help! Kick the tires, tell us what we got right. More importantly,
tell us (gently) what we got wrong so we can fix it together.

Technology-wise, Data Bench is a set of Docker images deployed to your
favorite cluster orchestration layer (as long as it's Kubernetes!)
that moves transactions through various Open Source components to
induce CPU and I/O loads on cluster nodes.

Data Bench is an early proof of concept and we are actively requesting
your feedback and comments. Further enhancements will be released as
quick as we get them done, driving towards a full-featured benchmark
that models modern workloads.

More information on Data Bench and it's likely direction can be
found [here][fowler0]. 

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

To that powerful mix, we add:

* [data-bench][19]

	This repo :) It contains the orchestration configuration to
	deploy Data Bench to a Kubernetes cluster (for now) as well
	as some handy [ansible][15] playbooks to make configuring
	your cluster a little easier.

* [data-bench-containers][9]

	All the build infrastructure for the Docker images used in Data
	Bench.

* [data-bench-data][10]

	The initial data set. We've baked it into the containers (except
	for the database). If you want to see the data, it's here.

* [data-bench-python][11]

	Finally, we've written a python3 module focused on enabling the
	development of python Data Bench transaction generators and
	consumers. I know, it's a Java-centric benchmark driven by Python.
	Welcome to the future.
	

## Installation

### Cluster Planning
#### Hardware
<!--
What sort of minimum hardware requirements: node counts, CPUs, etc
-->
#### Software
<!--
What sort of software is required before we start talking about
running Data Bench
-->
#### Storage
<!--
Talk about data storage requirements here.
-->

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

0. First, install [Ansible][15] and set up password-less ssh:

	```
	$ pip install ansible
	$ ssh-copy-id hostA
	$ ssh-copy-id hostB
	...
	$ ansible -i [inventory] all -m ping
	```

0. Now, install Kubernetes using [kubeadm][2].

### Data Bench Deployment

Great! The hard part is done, it's time to deploy Data Bench!

0. **Clone this repository**

	```
	$ git clone https://github.com/Data-Bench/data-bench
	```

0. **Finish Configuring Cluster Nodes**

	```
	$ ansible-playbook -i [inventory] TBD
	```

0. **Deploy Infrastructure Containers**

	```
	$ kubectl create -f data-bench/deployment/kubernetes/AAkafka
	$ kubectl create -f data-bench/deployment/kubernetes/BBcassandra
	$ kubectl create -f data-bench/deployment/kubernetes/CCspark

	```

0. **Deploy Data Bench Workload Containers**

	```
	$ kubectl create -f data-bench/deployment/kubernetes/ZZworkload
	```

0. **Verify Containers**

	```
	$ kubectl get pods --all-namespaces
	```

## Using Data Bench

### Loading Cassandra Database

### Running Data Bench

### Monitoring Data Bench

### Stopping Data Bench

## Notes

### Development Cluster Software

<!-- need links for all these things -->
* [Centos 7][2] minimal install on all cluster nodes
* kubernetes 1.7 installed with kubeadm 
* flannel container network fabric
* Big Data Europe 2020:Apache Spark 2.2.0
* Apache Kafka 0.11.0
* Apache Cassandra X.Y.Z
* Spark Kafka Connector X.Y.Z
* Spark Cassandra Connector X.Y.Z

### Proxy HOWTO


## Contact

## FAQ

**Q1**: Why didn't you use my favorite cluster orchestration framework?<br>
**A1**: We had to pick one to start with. We picked kubernetes.
<br>

**Q2**: <br>
**A2**:
<br>

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
[fowler0]: https://where-ever-fowlers-document-lands
[logo]: https://github.com/data-bench/data-bench/raw/master/images/Data-Bench-Logo.png

