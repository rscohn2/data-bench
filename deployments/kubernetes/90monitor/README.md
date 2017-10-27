**Dashboard Setup**

**_Note all YAML changes disccused below have been applied to YAMLs in this repo_**

**Kubernetes Dashboard:**

Download YAML from: <https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml>

Add Admin Role to deployment YAML to allow admin access without authentication.

```
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard
  labels:
    k8s-app: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard
  namespace: kube-system
```
Add correct heapster service:

```
 - --heapster-host=http://heapster.kube-system.svc.cluster.local
```

Deploy:

`$ kubectl create -f kubernetes-dashboard-all-access.yaml `

Port Forward:

```
$ kubectl get pods --namespace=kube-system -l k8s-app=kubernetes-dashboard \
  -o template --template="{{range.items}}{{.metadata.name}}{{end}}" \
  | xargs -I{} kubectl port-forward --namespace=kube-system {} 8443:8443
```

This will port forward the kubernetes dashboard access port to the cluster master on port 8443.

You can then either use this port directly or use an SSH tunnel to export beyond firewalls / gateways.

ex: `$ ssh -nfT -L 8443:localhost:8443 cluster_master sleep 120d`

will make <https://localhost:8443> forward to the kubernetes dashboard on the cluster master. Note your browser might need security exceptions.

Note:

kubectl proxy fails with SSL authentication errors, need to look at certificate generation.

**Grafana Dashboard:**

This will also deploy heapster / influxDB

It maybe necessary to change the service type from:

YAMLs were cloned from: <https://github.com/kubernetes/heapster.git>

`type: LoadBalancer `

to

`type: NodePort`

Deploy:


`$ kubectl create -f grafana.yaml heapster.yaml influxdb.yaml`

to deploy Heapster / Grafana / Influxdb

Port Forward:

```
$ kubectl get pods --namespace=kube-system -l k8s-app=grafana \
  -o template --template="{{range.items}}{{.metadata.name}}{{end}}" \
  | xargs -I{} kubectl port-forward --namespace=kube-system {} 3000:3000
```

Grafana is available on http://Cluster_Master:3000

ssh forward similarly to kubernetes dashboard if needed.


**Spark UI Proxy**

Download spark-ui-*.yaml from: <https://github.com/kubernetes/examples/tree/master/staging/spark>


Change Service type.

`type: LoadBalancer `   

to

`type: NodePort`


Deploy:

`$ kubectl create -f spark-ui*`

Port Forward:

```
$ kubectl get pods -l component=spark-ui-proxy \
  -o template --template="{{range.items}}{{.metadata.name}}{{end}}" \
  | xargs -I{} kubectl port-forward {} 8080:80
```

Spark Master / Worker dashboards are availble on the http://Cluster_Master:8080

ssh forward similarly to kubernetes dashboard if needed.


