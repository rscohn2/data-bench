## Prerequisites

You will need:

1. Install [ansible][1]:
   ```shell
   $ pip install ansible
   ```
   
1. A [kubernetes][4] cluster with [databench][0] deployed.

1. An ansible [inventory][3] file:
   ```
   [master]
   masterhost
   [minions]
   minion0
   minion1
   minionN
   ```

## workload.yaml 

The **workload.yaml** [ansible playbook][2] is used to start Data Bench runs.

### Usage

```shell
$ ansible-playbook -i inventory workload.yaml --list-tasks
playbook: workload.yaml

  play #1 (master): master	TAGS: []
    tasks:
      stop workload pods and observer	TAGS: [stop]
      prompt user for archive path   	TAGS: [archive]
      archive databench database     	TAGS: [archive]
      flush influx databench database	TAGS: [flush]
      flush kafka topics              	TAGS: [flush]
      generate a new run identifier   	TAGS: [init]
      start consumers/observers       	TAGS: [warmup]
      start telemetry                  	TAGS: [start]
      start generators                	TAGS: [start]
```

1. Start a Data Bench run:
   ```shell
   $ ansible-playbook -i inventory workload.yaml
   ```
   
1. Stop Data Bench:
   ```shell
   $ ansible-playbook -i inventory workload.yaml --tags=stop
   ```
   
1. Stop and flush without archiving:
   ```shell
   $ ansible-playbook -i inventory workload.yaml --tags=stop,flush
   ```



## port-forward.yaml

The port-forward.yaml playbook is used to forward ports out of the kubernetes
cluster. Ports on pods within the kubernetes cluster are forwarded to
ports on the kubernetes master host. This can be useful for debugging.

```shell
$ ansible-playbook -i ../inventory.template port-forward.yaml --list-tasks

playbook: port-forward.yaml

  play #1 (master): master	TAGS: []
    tasks:
       stop kubernetes port-forwarding	TAGS: [stop]
      start kubernetes port-forwarding	TAGS: [start]	
```

## tunnel.yaml

The tunnel playbook destroys and creates ssh tunnels on the localhost
which are forwarded to the ports forwarded to kubernetes nodes on the
kubernetes master host.

```shell
$ ansible-playbook -i ../inventory.template tunnel.yaml --list-tasks

playbook: tunnel.yaml

  play #1 (localhost): localhost	TAGS: []
    tasks:
      destroy ssh tunnels on localhost	TAGS: [stop]
       create ssh tunnels on localhost	TAGS: [start]
```

[0]: https://github.com/Data-Bench/data-bench
[1]: http://docs.ansible.com/ansible/latest/
[2]: http://docs.ansible.com/ansible/latest/playbooks.html
[3]: http://docs.ansible.com/ansible/latest/inventory.html
[4]: http://kubernetes.io
