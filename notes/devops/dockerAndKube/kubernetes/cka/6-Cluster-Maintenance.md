# Adding and Draining Kubernetes Nodes for Maintenance
Occasionally, you may need to add new nodes to accommodate increasing workloads. You also may need to drain existing nodes for updates, repairs, or decommissioning.

### Strategies for Adding and Draining Nodes

Several strategies can help you add and drain nodes efficiently and minimize the impact on your cluster’s performance.

- **Rolling updates**—Gradually add and drain nodes one at a time, allowing Kubernetes to reschedule workloads to other nodes and maintain high availability.
- **Blue/green deployment**—Create a separate set of nodes with the desired updates or configurations, and gradually shift workloads from the existing nodes to the new ones.
- **Canary deployment**—Test updates or configurations on a small subset of nodes before applying them to the entire cluster, minimizing the risk of widespread issues.

## Safely Drain a Node
## Before you begin[](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/#before-you-begin)

This task assumes that you have met the following prerequisites:

1. You do not require your applications to be highly available during the node drain, or
2. You have read about the [PodDisruptionBudget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/) concept, and have [configured PodDisruptionBudgets](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) for applications that need them.

## (Optional) Configure a disruption budget[](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/#configure-poddisruptionbudget)

To ensure that your workloads remain available during maintenance, you can configure a [PodDisruptionBudget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/).

If availability is important for any applications that run or could run on the node(s) that you are draining, [configure a PodDisruptionBudgets](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) first and then continue following this guide.

It is recommended to set `AlwaysAllow` [Unhealthy Pod Eviction Policy](https://kubernetes.io/docs/tasks/run-application/configure-pdb/#unhealthy-pod-eviction-policy) to your PodDisruptionBudgets to support eviction of misbehaving applications during a node drain. The default behavior is to wait for the application pods to become [healthy](https://kubernetes.io/docs/tasks/run-application/configure-pdb/#healthiness-of-a-pod) before the drain can proceed

### Use `kubectl drain` to remove a node from service[](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/#use-kubectl-drain-to-remove-a-node-from-service)

You can use `kubectl drain` to safely evict all of your pods from a node before you perform maintenance on the node (e.g. kernel upgrade, hardware maintenance, etc.). Safe evictions allow the pod's containers to [gracefully terminate](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-termination) and will respect the PodDisruptionBudgets you have specified.

**Note:** By default `kubectl drain` ignores certain system pods on the node that cannot be killed; see the [kubectl drain](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands/#drain) documentation for more details.

When `kubectl drain` returns successfully, that indicates that all of the pods (except the ones excluded as described in the previous paragraph) have been safely evicted (respecting the desired graceful termination period, and respecting the PodDisruptionBudget you have defined). It is then safe to bring down the node by powering down its physical machine or, if running on a cloud platform, deleting its virtual machine.

!!!**Note:**

If any new Pods tolerate the `node.kubernetes.io/unschedulable` taint, then those Pods might be scheduled to the node you have drained. Avoid tolerating that taint other than for DaemonSets.

If you or another API user directly set the [`nodeName`](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodename) field for a Pod (bypassing the scheduler), then the Pod is bound to the specified node and will run there, even though you have drained that node and marked it unschedulable.

First, identify the name of the node you wish to drain. You can list all of the nodes in your cluster with

```shell
kubectl get nodes
```

Next, tell Kubernetes to drain the node:

```shell
kubectl drain --ignore-daemonsets <node name>
```
If there are pods managed by a DaemonSet, you will need to specify `--ignore-daemonsets` with `kubectl` to successfully drain the node. The `kubectl drain` subcommand on its own does not actually drain a node of its DaemonSet pods: the DaemonSet controller (part of the control plane) immediately replaces missing Pods with new equivalent Pods. The DaemonSet controller also creates Pods that ignore unschedulable taints, which allows the new Pods to launch onto a node that you are draining.

Once it returns (without giving an error), you can power down the node (or equivalently, if on a cloud platform, delete the virtual machine backing the node). If you leave the node in the cluster during the maintenance operation, you need to run

```shell
kubectl uncordon <node name>
```

afterwards to tell Kubernetes that it can resume scheduling new pods onto the node.
!!!Note: The `kubectl drain` command should only be issued to a single node at a time

```bash
kubectl cordon <node-name>
### Above command marks node as `SchedulingDisabled` so that existing pods continue to run, but new pods are not scheduled
```

----------------SOB---------------------------------
[source](https://www.knowledgehut.com/blog/devops/kubernetes-cluster)
### Control Plane Components

The Kubernetes master node, also known as the control plane, is in charge of controlling the cluster's state. Important cluster decisions are made by the control plane, and it also reacts to cluster events such as by establishing a new [Kubernetes pod](https://www.knowledgehut.com/blog/devops/kubernetes-pods) as needed. 

The API server, the scheduler, the controller manager, etcd, and an optional cloud controller manager are the main components that make up the control plane. 

- apiserver: It exposes the Kubernetes API and serves as the control plane's front end. All requests, both internal and external, are processed after being validated by the control plane. You communicate with the kube-apiserver using REST calls when using the kubectl command-line interface. kube-apiserver scales horizontally by deploying more instances. 
- etcd: The only reliable source of information about the cluster's state is the etcd, a reliable distributed key-value data store. It stores the configuration data and details about the cluster's status and is fault-tolerant. 
- Scheduler: The kube-scheduler is in charge of scheduling the pods on the various nodes while taking resource availability and usage into account. It ensures that none of the cluster's nodes are overloaded. The scheduler places the pods on the node that is most appropriate considering its information of the overall resources available. 
- controller-manager: The controller-manager is a collection of all the controller processes that are continuously operating in the background to manage and regulate the cluster's status. To ensure that the cluster's present state and desired state are the same, adjustments are made by the controller-manager. 
- cloud-controller-manager: The cloud-controller-manager in a cloud environment helps in connecting your cluster with the cloud providers' API. There is no cloud-controller-manager in a local configuration where minikube is installed. 

### Node Components

The worker nodes comprise three important components - the kubelet, the kube-proxy and the [Kubernetes container](https://www.knowledgehut.com/blog/devops/kubernetes-container) runtime such as Docker. 

- kubelet: Every node has a kubelet that runs to monitor the health and proper operation of the containers. To make sure that pods are operating in accordance with the PodSpecs, the kubelet is provided with a set of PodSpecs using a variety of techniques. 
- kube-proxy: A service named kube-proxy that administers individual host subnetting and makes services available to the outside world is installed on each worker node. It handles request forwarding to the proper pods/containers across the many isolated networks in a cluster.  
- container-runtime: The software used to run containers is known as a container runtime. Open Container Initiative-compliant runtimes, including Docker, CRI-O, and containers are supported by Kubernetes.

The image below shows the different components of a Kubernetes cluster.
![[Pasted image 20230914212919.png]]


-------------EOB-----------------------------------

#CommonCommands 
```
kubectl describe node | grep Taints
kubectl upgrade plan 
kubectl drain --ignore-daemonsets <node name>
kubectl uncordon <node name>
```

# Backup Candidates

```bash
kubectl get all --all-namespace -o yaml > all-deploy-services.yaml
```

![[Pasted image 20230914231634.png]]
![[Pasted image 20230914231732.png]]
![[Pasted image 20230914231756.png]]

### Working with ETCDCTL

`etcdctl` is a command line client for [**etcd**](https://github.com/coreos/etcd).

In all our Kubernetes Hands-on labs, the ETCD key-value database is deployed as a static pod on the master. The version used is v3.

To make use of etcdctl for tasks such as back up and restore, make sure that you set the ETCDCTL_API to 3.

You can do this by exporting the variable ETCDCTL_API prior to using the etcdctl client. This can be done as follows:

`export ETCDCTL_API=3`

On the **Master Node**:
![](https://process.fs.teachablecdn.com/ADNupMnWyR7kCWRvm76Laz/resize=width:1000/https://www.filepicker.io/api/file/T7Y4a6aUTyOy9W2ZpfeV)

To see all the options for a specific sub-command, make use of the **-h or --help** flag.

For example, if you want to take a snapshot of etcd, use:

`etcdctl snapshot save -h` and keep a note of the mandatory global options.
Since our ETCD database is TLS-Enabled, the following options are mandatory:

`--cacert`                                                verify certificates of TLS-enabled secure servers using this CA bundle

`--cert`                                                    identify secure client using this TLS certificate file

`--endpoints=[127.0.0.1:2379]`          This is the default as ETCD is running on master node and exposed on localhost 2379.

`--key`                                                      identify secure client using this TLS key file

Similarly use the help option for **snapshot restore** to see all available options for restoring the backup.

`etcdctl snapshot restore -h`

For a detailed explanation on how to make use of the etcdctl command line tool and work with the -h flags, check out the solution video for the Backup and Restore Lab.

## Steps to restore and back up etcd

### [installing and Placing Etcd Binaries](https://k21academy.com/docker-kubernetes/etcd-backup-restore-in-k8s-step-by-step/)

### BACKUP

Users mostly interact with etcd by putting or getting the value of a key. We do that by using **etcdctl**, a command line tool for interacting with etcd server. In this section, we are downloading the etcd binaries so that we have the **etcdctl** tool with us to interact.

**1)**  Create a temporary directory for the ETCD binaries.

$ mkdir -p /tmp/etcd && cd /tmp/etcd

![Create a temporary directory for the ETCD binaries](https://k21academy.com/wp-content/uploads/2022/02/e1.webp)

$ curl -s https://api.github.com/repos/etcd-io/etcd/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | wget -qi -

**3)** Unzip the compressed binaries:

$ tar xvf *.tar.gz

```bash
$ cd etcd-*/
$ mv etcd* /usr/local/bin/
$ cd ~
$ rm -rf /tmp/etcd
```

### Find K8s Manifest Location

In Cluster we can check manifest default location with the help of the kubelet config file.

# cat /var/lib/kubelet/config.yaml

With this Manifest location, you can check the Kubernetes static pods location and find Api-server and ETCD pod location then under these pods you can check certificate file and data-dir location.

## How to backup the Etcd & Restore it

The etcd server is the only stateful component of the Kubernetes cluster. Kuberenetes stores all API objects and settings on the etcd server.  
Backing up this storage is enough to restore the Kubernetes cluster’s state completely.

**Taking Snapshot and Verifying it:**

**1)** Check backup Command flag which you need to include in the command

$ ETCDCTL_API=3 etcdctl snapshot backup -h

![output](https://k21academy.com/wp-content/uploads/2022/02/e3.webp)

**2)** Take a snapshot of the etcd datastore using etcdctl:

$ sudo ETCDCTL_API=3 etcdctl snapshot save snapshot.db --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key

![Output](https://k21academy.com/wp-content/uploads/2022/02/e4-1024x64.webp)

**3)** View that the snapshot was successful:

$ sudo ETCDCTL_API=3 etcdctl snapshot status snapshot.db

![Output](https://k21academy.com/wp-content/uploads/2022/02/e5-1024x156.webp)

**Note:** Important Note: If you are backing up and restoring the cluster do not run the status command after the backup this might temper the backup due to this restore process might fail.

**Backing-up The Certificates And Key Files:**

Zip up the contents of the etcd directory to save the certificates too

$ sudo tar -zcvf etcd.tar.gz /etc/kubernetes/pki/etcd

### RESTORE
**Restoring Etcd From Snapshot & Verify:**

**1)** Check the present state of the cluster which is stored in present snapshot taken in above task:

$ kubectl get all

![output](https://k21academy.com/wp-content/uploads/2022/02/e6-1024x238.webp)

**2)** To verify now we will create a pod and as the new pod is not present in the snapshot will not be present when we restore the content back using restore command:

$ kubectl run testing-restore --image=nginx
$ kubectl get pods

**Note:** In the new Kubernetes version the generator flag is deprecated so use the above updated command to create a pod.

![Output](https://k21academy.com/wp-content/uploads/2022/02/e7-1024x207.webp)

**3)** Check restore Command flag which you need to include in command

$ ETCDCTL_API=3 etcdctl snapshot restore -h

![output](https://k21academy.com/wp-content/uploads/2022/03/e8-1024x480.webp)

**4)** To restore we will have to first delete the present ETCD content. So lets look into and grab all the details we need for the restore command to execute

$ cat /etc/kubernetes/manifests/etcd.yaml

![Output](https://k21academy.com/wp-content/uploads/2022/03/e9-1024x377.webp)

**5)** Will delete the present content of ETCD and execute the restore command

$ rm -rf /var/lib/etcd
$ ETCDCTL_API=3 etcdctl snapshot restore snapshot.db --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key --name=kubeadm-master --data-dir=/var/lib/etcd --initial-cluster=kubeadmmaster=https://10.0.0.4:2380 --initial-cluster-token=etcd-cluster-1 --initial-advertise-peerurls=https://10.0.0.4:2380

![output](https://k21academy.com/wp-content/uploads/2022/03/e10-1024x105.webp)

**6)** Verify that the cluster is back to status of which we had taken the snapshot

$ kubectl get pods
$ kubectl get all

![output](https://k21academy.com/wp-content/uploads/2022/03/e11-1024x419.webp)

Congratulations! We are now successfully done with the backup & restoration process of our ETCD cluster in k8


```bash
> kubectl get pods -n kube-system
> vi /etc/kubernetes/manifests/etcd.yaml ## to get cert file path
> etcdl snapshot save --endpoints=127.0.0.1:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
/opt/snapshot-pre-book.db

> etcdl snapshot restore --data-dir /var/lib/etcd-from-backup /opt/snapshot-pre-book.db
> vi /etc/kubernetes/manifests/etcd.yaml ## change host path to `/var/lib/etcd-from-backup`

> ls /etc/kubernetes/manifests/ ### to get static pod configs
```

#CommonCommands 
```bash
kubctl config view ## we can get cluster info
kubectl config use-context <Cluster-name> ## Switch to new cluster specified
kubectl desribe pod kube-api-server-<cluster-name>-controlplane -n kube-system

etcdl --endpoints=127.0.0.1:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \ 
member list
```


