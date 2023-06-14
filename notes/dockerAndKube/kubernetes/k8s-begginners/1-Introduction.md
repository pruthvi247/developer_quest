[source-udemy](https://rakuten.udemy.com/course/learn-kubernetes/learn/lecture/9703196#overview)


## Components of k8 

- Api server
- etcd
- Kubelet
- Container runtime
- Controller
- Scheduler
- 
### Apiserver
The API server acts as the front-end for kubernetes. The users, management devices, Command line interfaces all talk to the API server to interact with the kubernetes cluster.
### etcd
ETCD is a distributed reliable key-value store used by kubernetes to store all data used to manage the cluster. Think of it this way, when you have multiple nodes and multiple masters in your cluster, etcd stores all that information on all the nodes in the cluster in a distributed manner. ETCD is responsible for implementing locks within the cluster to ensure there are no conflicts between the Masters.
### Schedulers
The scheduler is responsible for distributing work or containers across multiple nodes. It looks for newly created containers and assigns them to Nodes.
### Controllers
The controllers are the brain behind orchestration. They are responsible for noticing and responding when nodes, containers or endpoints goes down. The controllers makes decisions to bring up new containers in such cases.
### Container Runtime
The container runtime is the underlying software that is used to run containers. In our case it happens to be Docker.
### Kubelet
kubelet is the agent that runs on each node in the cluster. The agent is responsible for making sure that the containers are running on the nodes as expected.

> Master node will have `api server`,`controller`,`etcd`,`scheduler`
> 

**kube** command line tool or kubectl or kube control as it is also called. The kube control tool is used to deploy and manage applications on a kubernetes cluster, to get cluster information, get the status of nodes in the cluster and many other things.


