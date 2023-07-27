We're going to use an analogy of ships to understand the architecture of Kubernetes. The purpose of Kubernetes is to host your applications in the form of containers in an automated fashion so that you can easily deploy as many instances of your application as required and easily enable communication between different services within your application. So, there are many things involved that work together to make this possible. So, let's take a 10,000 feet look at the Kubernetes architecture. We have two kinds of ships in this example. Cargo ships, that does the actual work of carrying containers across the sea and control ships, that are responsible for monitoring and managing the cargo ships. The Kubernetes cluster consists of a set of nodes, which may be physical or virtual, on premise or on cloud, that host applications in the form of containers. This relate to the cargo ships in this analogy. The worker nodes in the cluster are ships that can load containers. But somebody needs to load the containers on the ships and not just load, plan how to load, identify the right ships, store information about the ships, monitor and track the location of containers on the ships, manage the whole loading process, et cetera. This is done by the control ships that host different offices and departments, monitoring equipments, communication equipments, cranes for moving containers between ships, et cetera. The control ships relate to the master node in the Kubernetes cluster.

## Master node
The master node is responsible for managing the Kubernetes cluster, storing information regarding the different nodes, planning which containers goes where, monitoring the nodes and containers on them, et cetera. The master node does all of these using a set of components together known as the control playing components

## ETCD
There are many containers being loaded and unloaded from the ships on a daily basis and so you need to maintain information about the different ships, what container is on which ship and what time it was loaded, et cetera. All of these are stored in a highly available key value store, known as etcd. Etcd is a database that stores information in a key value format.

## Scheduler
 When ships arrive, you load containers on them using cranes. The cranes identify the containers that need to be placed on ships. It identifies the right ship based on its size, its capacity, the number of containers already on the ship and any other conditions such as the destination of the ship, the type of containers it is allowed to carry, et cetera. So, those are schedulers in a Kubernetes cluster. **A scheduler identifies the right node to place a container on based on the containers resource requirements, the worker nodes capacity or any other policies or constraints, such as taints and tolerations or node affinity rules that are on them**


 There are different offices in the dock that are assigned to special tasks or departments. For example, the operations team takes care of ship handling, traffic control, et cetera. They deal with issues related to damages, the route the different ships take, et cetera.The cargo team takes care of containers. When containers are damaged or destroyed, they make sure new Containers are made available.We have these services office that takes care of the IT and communications between different ships.

Similarly, in Kubernetes, we have controllers available that take care of different areas.


## Controllers

### Node Controller 
The node controller takes care of nodes. They're responsible for onboarding new nodes to the cluster, handling situations where nodes become unavailable or get destroyed.

### Replication Controller
The replication controller ensures that the desired number of containers are running at all times in a replication group. So, you have seen different components like the different offices, the different ships, the data store, the cranes.

But how do these communicate with each other? How does one office reach the other office and who manages them all at a high level? 
>The **Kube API server** is the primary management component of Kubernetes. 

## Kube api server
The Kube API server is responsible for orchestrating all operations within the cluster. It exposes the Kubernetes API, which is used by external users to perform management operations on the cluster, as well as the various controllers to monitor the state of the cluster and make necessary changes as required and by the worker nodes to communicate with the server. 

***Note*** PDF of above architecture is attached

Every ship has a captain. The captain is responsible for managing all activities on these ships.The captain is responsible for liaising with the master ships, starting with letting the mastership know that they're interested in joining the group, receiving information about the containers to be loaded on the ship and loading the appropriate containers as required, sending reports back to the master about the status of this ship and the status of the containers on the ship, et cetera. Now, the captain of the ship is the kubelet in Kubernetes. 

## Kubelet

A kubelet is an agent that runs on each node in a cluster. It listens for instructions from the Kube API server and deploys or destroys containers on the nodes as required.
The Kube API server periodically fetches status reports from the kubelet to monitor the status of nodes and containers on them. The kubelet was more of a captain on the ship that manages containers on the ship but the applications running on the worker nodes need to be able to communicate with each other. For example, you might have a web server running in one container on one of the nodes and a database server running on another container on another node.
How would the web server reach the database server on the other node? Communication between worker nodes are enabled by another component that runs on the worker node known as the Kube Proxy Service.

## Kube Proxy
The Kube Proxy Service ensures that the necessary rules are in place on the worker nodes to allow the containers running on them to reach each other.

So to summarize, we have master and worker nodes. On the master, we have the etcd cluster, which stores information about the cluster. We have the kube scheduler that is responsible for scheduling applications or containers on nodes. We have different controllers that take care of different functions like the node controller, replication controller, et cetera. We have the Kube API server that is responsible for orchestrating all operations within the cluster. On the worker node, we have the kubelet that listens for instructions from the Kube API server and manages containers and the Kube Proxy that helps in enabling communication between services within the cluster.
