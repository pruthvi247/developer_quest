
# Container Runtime Interface (CRI)
The CRI is a plugin interface which enables the kubelet to use a wide variety of container runtime

Container runtime interface (CRI) is **a plugin interface that lets the kubelet—an agent that runs on every node in a Kubernetes cluster—use more than one type of container runtime**


### [The Open Container Initiative (OCI)](https://www.padok.fr/en/blog/container-docker-oci)

Following Docker's release, a large community emerged around the idea of using containers as the standard unit of software delivery. As companies started using containers to package and deploy their software more and more, Docker's container runtime did not meet all the technical and business needs that engineering teams could have.

In response to this, the community started developing new runtimes with different implementations and capabilities. Simultaneously, **new tools for building container images aimed to improve Docker's speed or ease of use**. To make sure that all container runtimes could run images produced by any build tool, the community started the [Open Container Initiative](https://www.opencontainers.org/) — or **OCI** — to define industry standards around container image formats and runtimes.

Docker's original image format has become the [OCI Image Specification](https://github.com/opencontainers/image-spec), and various open-source build tools support it

When Google released Kubernetes in 2015, the individual nodes of the cluster used Docker's runtime to run containers and manage container images. In late 2016, developers introduced an abstraction between Kubernetes and the container runtime it uses: the [Container Runtime Interface](https://kubernetes.io/blog/2016/12/container-runtime-interface-cri-in-kubernetes/) — or CRI, for short.

To plug a new container runtime into Kubernetes, all that is needed is a small piece of code called a shim that translates requests made by Kubernetes into requests understandable by the runtime. In theory, each additional runtime would need a custom shim, but a generic one exists for all container runtimes that implement the OCI Specification.

![[Pasted image 20230814093652.png]]

### [**What is the job of kube-proxy?**](https://www.learnsteps.com/how-exactly-kube-proxy-works-basics-on-kubernetes/)

The main task of Kube-proxy is making `configurations so that packets can reach their destination when you call a service and not routing the packets`. This must be clear to you, in the very basic configuration, when you talk about kube-proxy it doesn’t route the packets, it makes configuration so that packet can reach the destination.
`Kube-proxy creates iptables rules for the services that are created.`


![[Pasted image 20230814104500.png]]

When you create any service in Kubernetes, the traffic can come on any of the nodes, and then its iptables will route the packet to the correct node and after that, it can reach the correct pod.

**Generate Deployment YAML file (-o yaml). Don't create it(--dry-run)**

`kubectl create deployment --image=nginx nginx --dry-run=client -o yaml`

**OR**

**In k8s version 1.19+, we can specify the --replicas option to create a deployment with 4 replicas.**

`kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml`

### Kubernetes-services

Kubernetes Services enable communication between various components within and outside of the application. Kubernetes Services helps us connect applications together with other applications or users. For example, our application has groups of PODs running various sections, such as a group for serving front-end load to users, another group running back-end processes, and a third group connecting to an external data source. It is Services that enable connectivity between these groups of PODs. Services enable the front-end application to be made available to users, it helps communication between back-end and front-end PODs, and helps in establishing connectivity to an external data source. Thus services enable loose coupling between microservices in our application.

#### Node Port-Service:
![[Pasted image 20230829130759.png]]
#### ClusterIP-service:
![[Pasted image 20230829131737.png]]
![[Pasted image 20230829131703.png]]
#### Load Balancer-Service

![[Pasted image 20230829132120.png]]

### Namespaces
Kubernetes namespaces are a method by which a single [cluster](https://www.armosec.io/glossary/kubernetes-cluster/) used by an organization can be divided and categorized into multiple sub-clusters and managed individually. Each of these clusters can function as individual modules where users across various modules can interact and share information as necessary.
![[Pasted image 20230829133835.png]]

>Note : Applications can access pods from different name spaces. Below example my sql can connect to local DB and also dev name space DB

When you create a [Service](https://kubernetes.io/docs/concepts/services-networking/service/), it creates a corresponding [DNS entry](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/). This entry is of the form `<service-name>.<namespace-name>.svc.cluster.local`, which means that if a container only uses `<service-name>`, it will resolve to the service which is local to a namespace. This is useful for using the same configuration across multiple namespaces such as Development, Staging and Production. If you want to reach across namespaces, you need to use the fully qualified domain name

![[Pasted image 20230829134110.png]]


#### Initial namespaces[](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/#initial-namespaces)

Kubernetes starts with four initial namespaces:

`default`

Kubernetes includes this namespace so that you can start using your new cluster without first creating a namespace.

`kube-node-lease`

This namespace holds [Lease](https://kubernetes.io/docs/concepts/architecture/leases/) objects associated with each node. Node leases allow the kubelet to send [heartbeats](https://kubernetes.io/docs/concepts/architecture/nodes/#heartbeats) so that the control plane can detect node failure.

`kube-public`

This namespace is readable by _all_ clients (including those not authenticated). This namespace is mostly reserved for cluster usage, in case that some resources should be visible and readable publicly throughout the whole cluster. The public aspect of this namespace is only a convention, not a requirement.

`kube-system`

The namespace for objects created by the Kubernetes system.

Command to create namespace :

```bash
kubectl create ns  my-namespace
```

There are three possible ways to create deployment in particular name space.

1. Specify namespace in the `kubectl` `apply` or `create` command:

```yaml
kubectl apply -f https://k8s.io/examples/controllers/nginx-deployment.yaml -n my-namespace
```
2. Specify namespace in your `yaml` files:

```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: my-deployment
    namespace: my-namespace
```
3. Change default namespace in `~/.kube/config`:

```yaml
apiVersion: v1
kind: Config
clusters:
- name: "k8s-dev-cluster-01"
  cluster:
    server: "https://example.com/k8s/clusters/abc"
    namespace: "my-namespace"
```

### Setting the namespace preference[](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/#setting-the-namespace-preference)

You can permanently save the namespace for all subsequent kubectl commands in that context.

```shell
kubectl config set-context --current --namespace=<my-namespace>
# Above command changes namespace for kubectl for session
```
### Imperative Declarative 
![[Pasted image 20230829164522.png]]
**K8s has three resource management methods**

- **Command Based Object Management**: directly use commands to operate kubernetes resources. eg:
    
    `kubectl run nginx-pod --image=nginx:1.17.1 --port=80`
    
- **Command Type Object Configuration**: operate Kubernetes resources through command configuration and configuration files. eg:
    
    `kubectl create/patch -f nginx-pod.yaml`
    
- **Declarative Object Configuration**: operate kubernetes resources through the apply command and configuration file. eg:
    
    `kubectl apply -f nginx-pod.yaml`
![[Pasted image 20230829153858.png]]

Refer file imperative/declarative examples [[2-kubernetes-Core-concepts-2.pdf#page=60]]

#CommonCommands
```sh
### Common commands
kubectl get pods --selectors app=App1
kubectl get pods --selectors app=App1 --no-headers
kubectl get all --selectors app=App1
kubectl get pods --selectors app=App1,env=prod,bu=finance --no-headers
kubectl replace --force -f schedule-pod.yaml
kubectl describe node <nodename> | grep Taint

kubectl taint --help
kubectl describe pod <pod-name>
kubectl run <podname> --image=<imagename> --dry-run=client -o yaml
kubectl get pods -o wide

```

#TIP
`--dry-run`: By default as soon as the command is run, the resource will be created. If you simply want to test your command , use the `--dry-run=client` option. This will not create the resource, instead, tell you whether the resource can be created and if your command is right.

`-o yaml`: This will output the resource definition in YAML format on screen.

Use the above two in combination to generate a resource definition file quickly, that you can then modify and create resources as required, instead of creating the files from scratch.

#### POD

**Create an NGINX Pod**
`kubectl run nginx --image=nginx`
**Generate POD Manifest YAML file (-o yaml). Don't create it(--dry-run)**
`kubectl run nginx --image=nginx --dry-run=client -o yaml`


#### Deployment
**Create a deployment**
`kubectl create deployment --image=nginx nginx`

**Generate Deployment YAML file (-o yaml). Don't create it(--dry-run)**
`kubectl create deployment --image=nginx nginx --dry-run=client -o yaml`

**Generate Deployment with 4 Replicas**
`kubectl create deployment nginx --image=nginx --replicas=4`

You can also scale a deployment using the `kubectl scale` command.
`kubectl scale deployment nginx --replicas=4`

**Another way to do this is to save the YAML definition to a file and modify**
`kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > nginx-deployment.yaml`

#### Service
**Create a Service named redis-service of type ClusterIP to expose pod redis on port 6379**
`kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml`
(This will automatically use the pod's labels as selectors)

Or

`kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml` (This will not use the pods labels as selectors, instead it will assume selectors as **app=redis.** [You cannot pass in selectors as an option.](https://github.com/kubernetes/kubernetes/issues/46191) So it does not work very well if your pod has a different label set. So generate the file and modify the selectors before creating the service)

**Create a Service named nginx of type NodePort to expose pod nginx's port 80 on port 30080 on the nodes:**
`kubectl expose pod nginx --type=NodePort --port=80 --name=nginx-service --dry-run=client -o yaml`
(This will automatically use the pod's labels as selectors, [but you cannot specify the node port](https://github.com/kubernetes/kubernetes/issues/25478). You have to generate a definition file and then add the node port in manually before creating the service with the pod.)

Or

`kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml`
(This will not use the pods labels as selectors)

Both the above commands have their own challenges. While one of it cannot accept a selector the other cannot accept a node port. I would recommend going with the `kubectl expose` command. If you need to specify a node port, generate a definition file using the same command and manually input the nodeport before creating the service.


