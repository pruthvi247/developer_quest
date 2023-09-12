Logging is one of the [three pillars of observability](https://www.oreilly.com/library/view/distributed-systems-observability/9781492033431/ch04.html) in distributed systems. As such, we have seen an explosion of popular open-source (e.g. ELK stack) and mature commerical products (e.g. Splunk) to deal with logging at scale. However, in a complex system like Kubernetes, logging remains a hard problem, compounded by the continued growth of data driven by increased adoption of containerized system.

In this post, we will look into the different types of Kubernetes logs needed for better observability, as well as approaches to collect, aggregate, and analyze those logs in Kubernetes. We will then introduce an open-source solution using fluentd and fluentbit to make logging easier.

## Types of Kubernetes Logs

### Application Logs

First and foremost, we're interested in our application logs to debug problems or simply monitor application activity. All container engines (e.g. Docker, containerd, cri-o) support some kind of logging mechanism such as stdout/stderr or writing to a file.

We can group logs from Kubernetes tools like ingress controllers, cluster autoscalers, or cert-manager under this category as well.

### Kubernetes Component Logs

Besides the application it orchestrates, Kubernetes also emits logs from its componenets such as etcd, kube-apiserver, kube-scheduler, kube-proxy, and kubelet. If the node supports systemd, kubelet and container runtimes write to journald. Otherwise, system components write `.log` files under `/var/log` directory of the node.

### Kubernetes Events

Every Kubernetes event (e.g. scheduling a pod, deleting a pod) is a Kubernetes API object recorded by the API server. These logs include important information about changes to Kubernetes resource state.

### Kubernetes Audit Logs

Kubernetes also provides audit logs for each request to the API server when enabled. Each request is associated with a predefined stage: `RequestReceived`, `ResponseStarted`, `ResponseComplete`, and `Panic` and generates an audit event. That event is then processed accordingly to the audit policy, which details the audit levels including `None`, `Metadata`, `Request`, and `RequestResponse`

## Kubernetes Logging Approaches

Generally, there are two major ways to handle logs in Kubernetes:

1. Logging to stdout/stderr and using a logging agent to aggregate/forward to an external system
2. Using a sidecar to send logs to an external system

With the first case, kubelet is responsible for writing the container logs to `/var/log/containers` on the underlying node. Note that Kubernetes does not provide a built-in mechanism for rotating logs, but logs files are evicted from the node when the container is evicted from it. A logging agent is then responsible for collecting these logs and sending it to an aggregator like Splunk, Sumo Logic, and ELK.
![[Pasted image 20230908133037.png]]
Alternatively, a sidecar container can be deployed alongside the application to pick up logs from the application. This sidecar can read from a stream, a file, a socket, or journald and send to a log aggregating tool for further analysis and storage.
![[Pasted image 20230908133108.png]]

Finally, application code can be reconfigured to push logs directly to some logging backend, but this pattern is not common as it alters code behavior.

```
kubectl logs <pod-name> -c <container-name>
```
We can also check the pod's logs and their containers, being sent to `stdout` or `stderr`, which are stored at **`**_/var/log/pods_**`** and `**_/var/log/containers_**`, respectively, on nodes.

If the container restarts, kubelet is responsible for keeping track of logs at the node level. Also, when a pod is evicted from the node, its container and respective logs are evicted.

- To list the log files of each pod on the node
```
ls -l /var/log/pods
```
- To check any pod’s and it’s respective container logs
```
cat <namespace_pod_name>/<container_name>/<file-name>.log
```
The files present in `_/var/log/containers_` are soft links to their respective `_/var/log/pods/<namespace_podname>_` folder.

### Cluster-Level Logging

The cluster-level logs are the logs from,

1. The applications running inside the Pods
2. Nodes of the cluster
3. Control-plane components

The first two we discussed above. As the Kubernetes cluster components are running as pods, the `logs collector agent` would collect the logs of the API Server and the other control-plane components; whereas `kubelet logs` are collected via `systemd.` 

Apart from above we can use following to get additional details,

- Kubernetes Events
- Audit Logs

#### Kubernetes Events

Kubernetes events store information about the object `state changes` and `errors`. Events are stored in the `API server` on the control-plane node. 

- To get event logs
```
kubectl get events -n <namespace>
```
We can also get events from a particular pod.

- To describe a pod

```
kubectl describe pod <pod-name>
```

Check the events at the end of the output. 

To avoid using all disk space on the control-plane node, Kubernetes removes events after one hour.

#### Kubernetes Audit Logs

The audit log is `detailed information` about all the `actions` that happened in the cluster. It tracks all the activities in a sequence. It is used for security purposes to know who did what, when, and how? The audit policy has to be enabled to the master node only. Please refer to the  [Auditing lab](https://cloudyuga.guru/hands_on_lab/auditing) to understand audit logs in detail.

