
![[Pasted image 20230917155237.png]]

In this article we will see how to configure a host as a DNS server.

We are given a server dedicated as the DNS server, and a set of Ips to configure as entries in the server. There are many DNS server solutions out there, in this lecture we will focus on a particular one – CoreDNS.

So how do you get core dns? CoreDNS binaries can be downloaded from their Github releases page or as a docker image. Let’s go the traditional route. Download the binary using curl or wget. And extract it. You get the coredns executable.

![[Pasted image 20230918094130.png]]

Run the executable to start a DNS server. It by default listens on port 53, which is the default port for a DNS server.

Now we haven’t specified the IP to hostname mappings. For that you need to provide some configurations. There are multiple ways to do that. We will look at one. First we put all of the entries into the DNS servers /etc/hosts file.
And then we configure CoreDNS to use that file. CoreDNS loads it’s configuration from a file named Corefile. Here is a simple configuration that instructs CoreDNS to fetch the IP to hostname mappings from the file /etc/hosts. When the DNS server is run, it now picks the Ips and names from the /etc/hosts file on the server.
![[Pasted image 20230918094216.png]]
CoreDNS also supports other ways of configuring DNS entries through plugins. We will look at the plugin that it uses for Kubernetes in a later section.

# Network Name space

Linux network namespaces are a Linux kernel feature allowing us to isolate network environments through virtualization. For example, using network namespaces, you can create separate network interfaces and routing tables that are isolated from the rest of the system and operate independently.

![[Pasted image 20230918094630.png]]
To understand namespaces easily, it is worth saying Linux namespaces are the basis of container technologies like **Docker** or **Kubernetes**.

For now, Linux includes 6 types of namespaces: pid, net, uts, mnt, ipc, and user.

## Adding a Linux network namespace:

Managing network namespaces is done using the ip netns command followed by the proper options.
``` bash
ip netns add linuxhint
```
Network namespaces have their own interfaces, routing tables, loopback interface, iptables rules, etc. You need to create these resources for your namespace.

Each pod gets its own network namespace. Containers in the same pod are in the same network namespace. This is why you can talk between containers via localhost and why you need to watch out for port conflicts when you’ve got multiple containers in the same pod.
![[same-pod.gif]]

## Communication between pods on the same node

Each pod on a node has its own network namespace. Each pod has its own IP address.

And each pod thinks it has a totally normal ethernet device called `eth0` to make network requests through. But Kubernetes is faking it – it’s just a virtual ethernet connection.

Each pod’s `eth0` device is actually connected to a virtual ethernet device in the node.

A virtual ethernet device is a tunnel that connects the pod’s network with the node. This connection has two sides – on the pod’s side, it’s named `eth0`, and on the node’s side, it’s named `vethX`.

Why the `X`? There’s a `vethX` connection for every pod on the node. (So they’d be `veth1`, `veth2`, `veth3`, etc.)

When a pod makes a request to the IP address of another node, it makes that request through its own `eth0` interface. This tunnels to the node’s respective virtual `vethX` interface.

But then how does the request get to the other pod?

The node uses a network bridge.

### What is a Network Bridge?

A network bridge connects two networks together. When a request hits the bridge, the bridge asks all the connected devices (i.e. pods) if they have the right IP address to handle the original request.

(Remember that each pod has its own IP address and it knows its own IP address.)

If one of the devices does, the bridge will store this information and also forward data to the original back so that its network request is completed.

In Kubernetes, this bridge is called `cbr0`. Every pod on a node is part of the bridge, and the bridge connects all pods on the same node together.

![[pods-on-node.gif]]
![[Pasted image 20230918101027.png]]

## Communication between pods on different nodes

But what if pods are on different nodes?

Well, when the network bridge asks all the connected devices (i.e. pods) if they have the right IP address, none of them will say yes.

(Note that this part can vary based on the cloud provider and networking plugins.)

After that, the bridge falls back to the default gateway. This goes up to the cluster level and looks for the IP address.

At the cluster level, there’s a table that maps IP address ranges to various nodes. Pods on those nodes will have been assigned IP addresses from those ranges.

For example, Kubernetes might give pods on node 1 addresses like `100.96.1.1`, `100.96.1.2`, etc. And Kubernetes gives pods on node 2 addresses like `100.96.2.1`, `100.96.2.2`, and so on.

Then this table will store the fact that IP addresses that look like `100.96.1.xxx` should go to node 1, and addresses like `100.96.2.xxx` need to go to node 2.

After we’ve figured out which node to send the request to, the process proceeds the roughly same as if the pods had been on the same node all along.

![[node-to-node.gif]]
![[Pasted image 20230918101606.png]]
## Communication between pods and services

One last communication pattern is important in Kubernetes.

In Kubernetes, a service lets you map a single IP address to a set of pods. You make requests to one endpoint (domain name/IP address) and the service proxies requests to a pod in that service.

This happens via `kube-proxy` a small process that Kubernetes runs inside every node.

This process maps virtual IP addresses to a group of actual pod IP addresses.

Once `kube-proxy` has mapped the service virtual IP to an actual pod IP, the request proceeds as in the above sections.

## How does DNS work? How do we discover IP addresses?

DNS is the system for converting domain names to IP addresses.

Kubernetes clusters have a service responsible for DNS resolution.

Every service in a cluster is assigned a domain name like `my-service.my-namespace.svc.cluster.local`.

Pods are automatically given a DNS name, and can also specify their own using the `hostname` and `subdomain` properties in their YAML config.

So when a request is made to a service via its domain name, the DNS service resolves it to the IP address of the service.

Then `kube-proxy` converts that service's IP address into a pod IP address. After that, based on whether the pods are on the same node or on different nodes, the request follows one of the paths explained above.

While testing the Network Namespaces, if you come across issues where you can't ping one namespace from the other, make sure you set the NETMASK while setting IP Address. ie: 192.168.1.10/24

```bash
ip -n red addr add 192.168.1.10/24 dev veth-red
```
Another thing to check is FirewallD/IP Table rules. Either add rules to IP Tables to allow traffic from one namespace to another. Or disable IP Tables all together (Only in a learning environment).

```bash
# Create network namespaces 
ip netns add red 
ip netns add blue 
# Create veth pairs 
ip link add veth-red type veth peer name veth-blue 
# Create Add veth to respective namespaces 
ip link set veth-red netns red 
ip link set veth-blue netns blue 
# Set IP Addresses 
ip -n red addr add 192.168.1.1 dev veth-red 
ip -n blue addr add 192.168.1.2 dev veth-blue 
# Check IP Addresses 
ip -n red addr 
ip -n blue addr 
# Bring up interfaces 
ip -n red link set veth-red up 
ip -n blue link set veth-blue up 
# Bring Loopback devices up 
ip -n red link set lo up 
ip -n blue link set lo up 
# Add default gateway 
ip netns exec red 
ip route add default via 192.168.1.1 dev veth-red 
ip netns exec blue 
ip route add default via 192.168.1.2 dev
```

# Docker Networking
Docker networking differs from virtual machine (VM) or physical machine networking in a few ways:

1. Virtual machines are more flexible in some ways as they can support configurations like [NAT and host networking](https://superuser.com/questions/227505/what-is-the-difference-between-nat-bridged-host-only-networking). Docker typically uses a bridge network, and while it can support host networking, that option is [only available on Linux](https://docs.docker.com/network/host/).
2. When using Docker containers, network isolation is achieved using a network namespace, not an entirely separate networking stack.
3. You can run hundreds of containers on a single-node Docker host, so it’s required that the host can support networking at this scale. VMs usually don’t run into these network limits as they typically run fewer processes per VM.
## What Are Docker Network Drivers?[](https://earthly.dev/blog/docker-networking/#what-are-docker-network-drivers)

Docker handles communication between containers by creating a default bridge network, so you often don’t have to deal with networking and can instead focus on creating and running containers. This default bridge network works in most cases, but it’s not the only option you have.

Docker allows you to create three different types of network drivers out-of-the-box: bridge, host, and none. However, they may not fit every use case, so we’ll also explore user-defined networks such as `overlay` and `macvlan`

### The Bridge Driver[](https://earthly.dev/blog/docker-networking/#the-bridge-driver)

This is the default. Whenever you start Docker, a bridge network gets created and all newly started containers will connect automatically to the default bridge network.

You can use this whenever you want your containers running in isolation to connect and communicate with each other. Since containers run in isolation, the bridge network solves the port conflict problem. Containers running in the same bridge network can communicate with each other, and Docker [uses iptables](https://docs.docker.com/network/iptables/) on the host machine to prevent access outside of the bridge.

Let’s look at some examples of how a bridge network driver works.

1. Check the available network by running the `docker network ls` command
2. Start two [busybox](https://hub.docker.com/_/busybox) containers named `busybox1` and `busybox2` in detached mode by passing the `-dit` flag
	1. ``` bash
$ docker network ls           
NETWORK ID     NAME      DRIVER    SCOPE
5077a7b25ae6   bridge    bridge    local
7e25f334b07f   host      host      local
475e50be0fe0   none      null      local
```bash
docker run -dit --name busybox1 busybox /bin/sh
docker run -dit --name busybox2 busybox /bin/sh
```

3. Verify that the containers are attached to the bridge network.
```
$ docker network inspect bridge                                                       
[
    {
        "Name": "bridge",
        "Id": "5077a7b25ae67abd46cff0fde160303476c8a9e2e1d52ad01ba2b4bf04acc0e0",
        "Created": "2021-03-05T03:25:58.232446444Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "7fea140327487b57c3cf31d7502cfaf701e4ea4314621f0c726309e396105885": {
                "Name": "busybox1",
                "EndpointID": "05f216032784786c3315e30b3d54d50a25c1efc7d2030dc664716dda38056326",
                "MacAddress": "02:42:ac:11:00:02",
                "IPv4Address": "172.17.0.2/16",
                "IPv6Address": ""
            },
            "9e6464e82c4ca647b9fb60a85ca25e71370330982ea497d51c1238d073148f63": {
                "Name": "busybox2",
                "EndpointID": "3dcc24e927246c44a2063b5be30b5f5e1787dcd4d53864c6ff2bb3c561519115",
                "MacAddress": "02:42:ac:11:00:03",
                "IPv4Address": "172.17.0.3/16",
                "IPv6Address": ""
            }
        },
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        },
        "Labels": {}
    }
]
```
4.  Under the container’s key, you can observe that two containers (`busybox1` and `busybox2`) are listed with information about IP addresses. Since containers are running in the background, attach to the `busybox1` container and try to ping to `busybox2` with its IP address.
```$ docker attach busybox1
		/ # whoami
		root
		/ # hostname -i
		172.17.0.2
		/ # ping 172.17.0.3
		PING 172.17.0.3 (172.17.0.3): 56 data bytes
		64 bytes from 172.17.0.3: seq=0 ttl=64 time=2.083 ms
		64 bytes from 172.17.0.3: seq=1 ttl=64 time=0.144 ms
		/ # ping busybox2
		ping: bad address 'busybox2'
```
5. Observe that the ping works by passing the IP address of `busybox2` but fails when the container name is passed instead.

The downside with the bridge driver is that it’s not recommended for production; the containers communicate via IP address instead of automatic service discovery to resolve an IP address to the container name. Every time you run a container, a different IP address gets assigned to it. It may work well for local development or CI/CD, but it’s definitely not a sustainable approach for applications running in production.

Another reason not to use it in production is that it will allow unrelated containers to communicate with each other, which could be a security risk. I’ll cover how you can create custom bridge networks later.

### The Host Driver[](https://earthly.dev/blog/docker-networking/#the-host-driver)

As the name suggests, host drivers use the networking provided by the host machine. And it removes network isolation between the container and the host machine where Docker is running. For example, If you run a container that binds to port 80 and uses host networking, the container’s application is available on port 80 on the host’s IP address. You can use the host network if you don’t want to rely on Docker’s networking but instead rely on the host machine networking.

One limitation with the host driver is that it doesn’t work on Docker desktop: you need a Linux host to use it. This article focuses on Docker desktop, but I’ll show you the commands required to work with the Linux host.

The following command will start an Nginx image and listen to port 80 on the host machine:
```
docker run --rm -d --network host --name my_nginx nginx
```
You can access Nginx by hitting the `http://localhost:80/ url`.

The downside with the host network is that you can’t run multiple containers on the same host having the same port. Ports are shared by all containers on the host machine network.
### The None Driver[](https://earthly.dev/blog/docker-networking/#the-none-driver)

The none network driver does not attach containers to any network. Containers do not access the external network or communicate with other containers. You can use it when you want to disable the networking on a container.

### The Overlay Driver[](https://earthly.dev/blog/docker-networking/#the-overlay-driver)

The Overlay driver is for multi-host network communication, as with [Docker Swarm](https://docs.docker.com/engine/swarm/) or [Kubernetes](https://kubernetes.io/). It allows containers across the host to communicate with each other without worrying about the setup. Think of an overlay network as a distributed virtualized network that’s built on top of an existing computer network.

To create an overlay network for Docker Swarm services, use the following command:
```
docker network create -d overlay my-overlay-network
```
To create an overlay network so that standalone containers can communicate with each other, use this command:
```
docker network create -d overlay --attachable my-attachable-overlay
```
### Creating a Network[](https://earthly.dev/blog/docker-networking/#creating-a-network)

- You can use `docker network create mynetwork` to create a Docker network. Here, we’ve created a network named `mynetwork`. Let’s run `docker network ls` to verify that the network is created successfully.
- Run the `docker network connect 0f8d7a833f42` command to connect the container named `wizardly_greider` with `mynetwork`. To verify that this container is connected to `mynetwork`, use the `docker inspect` command.
- This command disconnects a Docker container from the custom `mynetwork`:
```
docker network disconnect mynetwork 0f8d7a833f42
```
- List available networks `docker network ls`
- Remove a network `docker network rm mynetwork`
## Public Networking

To make the ports accessible for external use or with other containers not on the same network, you will have to use the `-P` (publish all available ports) or `-p` (publish specific ports) flag.
For example, here we’ve mapped the TCP port 80 of the container to port 8080 on the Docker host
```
docker run -it --rm nginx -p 8080:80
```

![[Pasted image 20230918121440.png]]
![[Pasted image 20230918121539.png]]

# Cluster Networking
![[Pasted image 20230918121756.png]]
![[Pasted image 20230918121834.png]]

!!!NOTE : Refer [resource-pdf](obsidian://open?vault=developer_quest&file=notes%2FdockerAndKube%2Fkubernetes%2Fcka%2Fcka-kodekloud-resources%2F9-CKA-Networking-v1.2.pdf) for weaveworks network add on ppt

CNI  details for kubernetes can be found in `kubelet.service`
```
ExecStart=/usr/local/bin/kubelet \\ --config=/var/lib/kubelet/kubelet-config.yaml \\ --container-runtime=remote \\ --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock \\ --image-pull-progress-deadline=2m \\ --kubeconfig=/var/lib/kubelet/kubeconfig \\ --network-plugin=cni \\
--cni-bin-dir=/opt/cni/bin \\
--cni-conf-dir=/etc/cni/net.d \\ 
--register-node=true \\
--v=2

```
![[Pasted image 20230918124107.png]]
![[Pasted image 20230918124217.png]]

# IPAM
Ip address management

**DNS name resolution**
![[Pasted image 20230918133839.png]]
![[Pasted image 20230918134028.png]]


# Ingress
In Kubernetes, an Ingress is an object that allows access to your Kubernetes services from outside the Kubernetes cluster. You configure access by creating a collection of rules that define which inbound connections reach which services.

This lets you consolidate your routing rules into a single resource. For example, you might want to send requests to `example.com/api/v1/` to an `api-v1` service, and requests to `example.com/api/v2/` to the `api-v2` service. With an Ingress, you can easily set this up without creating a bunch of LoadBalancers or exposing each service on the Node.
Before the Kubernetes Ingress was stable, a custom Nginx or an HAproxy kubernetes deployment would be exposed as a Loadbalancer service for routing external traffic to the internal cluster services.

The routing rules are added as a configmap in the Nginx/HAProxy pods. Whenever there is a change in dns or a new route entry to be added, it gets updated in the configmap, and pod configs are reloaded, or it gets re-deployed.

Kubernetes ingress also follows a similar pattern by having the routing rules maintained as native Kubernetes ingress objects instead of a configmap.
Also, there were implementations using consul and other [service discovery tools](https://devopscube.com/open-source-service-discovery/) to update DNS changes to Nginx or HAproxy without downtime, which brings the exact implementation as ingress.
## Kubernetes Ingress vs LoadBalancer vs NodePort

These options all do the same thing. They let you expose a service to external network requests. They let you send a request from outside the Kubernetes cluster to a service inside the cluster.

### Node Port
![[Pasted image 20230919095128.png]]

`NodePort` is a configuration setting you declare in a service’s YAML. Set the service spec’s `type` to `NodePort`. Then, Kubernetes will allocate a specific port on each Node to that service, and any request to your cluster on that port gets forwarded to the service.

This is cool and easy, it’s just not super robust. You don’t know what port your service is going to be allocated, and the port might get re-allocated at some point.
### LoadBalancer
![[Pasted image 20230919095216.png]]
You can set a service to be of type `LoadBalancer` the same way you’d set `NodePort`— specify the `type` property in the service’s YAML. There needs to be some external load balancer functionality in the cluster, typically implemented by a cloud provider.

This is typically heavily dependent on the cloud provider—GKE creates a Network Load Balancer with an IP address that you can use to access your service.

Every time you want to expose a service to the outside world, you have to create a new LoadBalancer and get an IP address.
### Ingress
![[Pasted image 20230919095316.png]]
`NodePort` and `LoadBalancer` let you expose a service by specifying that value in the service’s `type`. Ingress, on the other hand, is a completely independent resource to your service. You declare, create and destroy it separately to your services.

This makes it decoupled and isolated from the services you want to expose. It also helps you to consolidate routing rules into one place.

The one downside is that you need to configure an Ingress Controller for your cluster. But that’s pretty easy—in this example, we’ll use the Nginx Ingress Controller.

## Kubernetes Ingress Controller
Ingress controller is **not a native Kubernetes implementation**. This means It doesn’t come default in the cluster.

We need to set up an ingress controller for the ingress rules to work. There are several open-source and enterprise ingress controllers available.

An ingress controller is typically a reverse web proxy server implementation in the cluster. In kubernetes terms, it is a reverse proxy server deployed as [kubernetes deployment](https://devopscube.com/kubernetes-deployment-tutorial/) exposed to a service type Loadbalancer.

You can have multiple ingress controllers in a cluster mapped to multiple load balancers. Each ingress controller should have a unique identifier named **ingress-class** added to the annotation.

**Nginx** is one of the widely used ingress controllers.

![[Pasted image 20230919101747.png]]
![[Pasted image 20230919103803.png]]

![[Pasted image 20230919113002.png]]

----------------- SOB -----------------------
[source-devopscube.com](https://devopscube.com/setup-ingress-kubernetes-nginx-controller/)

We need to deploy the following objects to have a **working Nginx controller**.

1. `ingress-nginx` namespace
2. Service account/Roles/ClusterRoles for **Nginx admission controller**
3. Validating webhook Configuration
4. Jobs to create/update Webhook CA bundles
5. Service account/Roles/ClusterRoles of **Nginx controller deployment**
6. Nginx controller configmap
7. Services for nginx controller & admission controller
8. Ingress controller deployment
!!!**Note**: You can create all the manifests yourself or use the Github repo. However, I highly suggest you go through every manifest and understand what you are deploying.

### Need for Admission Controller & Validating Webhook

Kubernetes Admission Controller is a small piece of code to validate or update Kubernetes objects before creating them. In this case, it’s an **admission controller to validate the ingress objects**. In this case, the Admission Controller code is part of the Nginx controller which listens on port `8443`.

We can deploy ingress objects with the wrong configuration without an admission controller. However, it breaks all the ingress rules associated with the ingress controller.

With the admission controller in place, we can ensure that the ingress object we create has configurations and doesn’t break routing rules.

Here is how admission controllers work for Nginx.

![[Pasted image 20230919104032.png]]
1. When you deploy an ingress YAML, the Validation admission intercepts the request.
2. Kubernetes API then sends the ingress object to the validation admission controller service endpoint based on admission webhook endpoints.
3. Service sends the request to the Nginx deployment on port 8443 for validating the ingress object.
4. The admission controller then sends a response to the k8s API.
5. If it is a valid response, the API will create the ingress object.
### Create a Namespace

We will deploy all the Nginx controller objects in the `ingress-nginx` namespace.

Let’s create the namespace.

```
kubectl create ns ingress-nginx
```

### Create Admission Controller Roles & Service Account

We need a Role and ClusterRole with required permissions and bind to `ingress-nginx-admission` service account.

Create a file named `admission-service-account.yaml` and copy the following contents.

```
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: admission-webhook
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx-admission
  namespace: ingress-nginx

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  annotations:
    app.kubernetes.io/component: admission-webhook
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx-admission
  namespace: ingress-nginx
rules:
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
  - create

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app.kubernetes.io/component: admission-webhook
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx-admission
  namespace: ingress-nginx
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: ingress-nginx-admission
subjects:
- kind: ServiceAccount
  name: ingress-nginx-admission
  namespace: ingress-nginx


---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: admission-webhook
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx-admission
rules:
- apiGroups:
  - admissionregistration.k8s.io
  resources:
  - validatingwebhookconfigurations
  verbs:
  - get
  - update

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/component: admission-webhook
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx-admission
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ingress-nginx-admission
subjects:
- kind: ServiceAccount
  name: ingress-nginx-admission
  namespace: ingress-nginx
```

Deploy the manifest.

```
kubectl apply -f admission-service-account.yaml 
```
### Create Validating Webhook Configuration

Create a file named `validating-webhook.yaml` and copy the following contents.

```
---
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  labels:
    app.kubernetes.io/component: admission-webhook
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx-admission
webhooks:
- admissionReviewVersions:
  - v1
  clientConfig:
    service:
      name: ingress-nginx-controller-admission
      namespace: ingress-nginx
      path: /networking/v1/ingresses
  failurePolicy: Fail
  matchPolicy: Equivalent
  name: validate.nginx.ingress.kubernetes.io
  rules:
  - apiGroups:
    - networking.k8s.io
    apiVersions:
    - v1
    operations:
    - CREATE
    - UPDATE
    resources:
    - ingresses
  sideEffects: None
```

Create the `ValidatingWebhookConfiguration`

```
kubectl apply -f validating-webhook.yaml
```

### Deploy Jobs To Update Webhook Certificates

The `ValidatingWebhookConfiguration` works only over HTTPS. So it needs a CA bundle.

We use [kube-webhook-certgen](https://github.com/jet/kube-webhook-certgen) to generate a CA cert bundle with the first job. The generated CA certs are stored in a secret named `ingress-nginx-admission`

The second job patches the `ValidatingWebhookConfiguration` object with the CA bundle.

Create a file named `jobs.yaml` and copy the following contents.

```

---
apiVersion: batch/v1
kind: Job
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx-admission-create
  namespace: ingress-nginx
spec:
  template:
    metadata:
      labels:
        app.kubernetes.io/component: controller
        app.kubernetes.io/instance: ingress-nginx
        app.kubernetes.io/name: ingress-nginx
      name: ingress-nginx-admission-create
    spec:
      containers:
      - args:
        - create
        - --host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.$(POD_NAMESPACE).svc
        - --namespace=$(POD_NAMESPACE)
        - --secret-name=ingress-nginx-admission
        env:
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        image: k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
        imagePullPolicy: IfNotPresent
        name: create
        securityContext:
          allowPrivilegeEscalation: false
      nodeSelector:
        kubernetes.io/os: linux
      restartPolicy: OnFailure
      securityContext:
        runAsNonRoot: true
        runAsUser: 2000
      serviceAccountName: ingress-nginx-admission
---
apiVersion: batch/v1
kind: Job
metadata:
  labels:
    app.kubernetes.io/component: admission-webhook
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx-admission-patch
  namespace: ingress-nginx
spec:
  template:
    metadata:
      labels:
        app.kubernetes.io/component: admission-webhook
        app.kubernetes.io/instance: ingress-nginx
        app.kubernetes.io/name: ingress-nginx
      name: ingress-nginx-admission-patch
    spec:
      containers:
      - args:
        - patch
        - --webhook-name=ingress-nginx-admission
        - --namespace=$(POD_NAMESPACE)
        - --patch-mutating=false
        - --secret-name=ingress-nginx-admission
        - --patch-failure-policy=Fail
        env:
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        image: k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
        imagePullPolicy: IfNotPresent
        name: patch
        securityContext:
          allowPrivilegeEscalation: false
      nodeSelector:
        kubernetes.io/os: linux
      restartPolicy: OnFailure
      securityContext:
        runAsNonRoot: true
        runAsUser: 2000
      serviceAccountName: ingress-nginx-admission
```

Once the jobs are executed, you can describe the `ValidatingWebhookConfigurationand`, you will see the patched bundle.

```
kubectl describe ValidatingWebhookConfiguration ingress-nginx-admission
```

### Create Ingress Controller Roles & Service Account

Create a file named `ingress-service-account.yaml` and copy the following contents.

```
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: admission-webhook
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx
  namespace: ingress-nginx

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx
  namespace: ingress-nginx
rules:
- apiGroups:
  - ""
  resources:
  - namespaces
  verbs:
  - get
- apiGroups:
  - ""
  resources:
  - configmaps
  - pods
  - secrets
  - endpoints
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - services
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - networking.k8s.io
  resources:
  - ingresses
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - networking.k8s.io
  resources:
  - ingresses/status
  verbs:
  - update
- apiGroups:
  - networking.k8s.io
  resources:
  - ingressclasses
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resourceNames:
  - ingress-controller-leader
  resources:
  - configmaps
  verbs:
  - get
  - update
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - create
- apiGroups:
  - ""
  resources:
  - events
  verbs:
  - create
  - patch

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx
  namespace: ingress-nginx
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: ingress-nginx
subjects:
- kind: ServiceAccount
  name: ingress-nginx
  namespace: ingress-nginx

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx
rules:
- apiGroups:
  - ""
  resources:
  - configmaps
  - endpoints
  - nodes
  - pods
  - secrets
  - namespaces
  verbs:
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - nodes
  verbs:
  - get
- apiGroups:
  - ""
  resources:
  - services
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - networking.k8s.io
  resources:
  - ingresses
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - events
  verbs:
  - create
  - patch
- apiGroups:
  - networking.k8s.io
  resources:
  - ingresses/status
  verbs:
  - update
- apiGroups:
  - networking.k8s.io
  resources:
  - ingressclasses
  verbs:
  - get
  - list
  - watch

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ingress-nginx
subjects:
- kind: ServiceAccount
  name: ingress-nginx
  namespace: ingress-nginx
```

Deploy the manifest.

```
 kubectl apply -f ingress-service-account.yaml
```
### Create Configmap

With this configmap, you can **customize the Nginx settings**. For example, you can set custom headers and most of the Nginx settings. Please refer to the [official community documentation](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/) for all the supported configurations.

Create a file named `configmap.yaml` and copy the following contents.

```
---
apiVersion: v1
data:
  allow-snippet-annotations: "true"
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx-controller
  namespace: ingress-nginx
```

Create the configmap.

```
kubectl apply -f configmap.yaml
```

### Create Ingress Controller & Admission Controller Services

Create a file named `services.yaml` and copy the following contents.

```
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx-controller
  namespace: ingress-nginx
spec:
  externalTrafficPolicy: Local
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - appProtocol: http
    name: http
    port: 80
    protocol: TCP
    targetPort: http
  - appProtocol: https
    name: https
    port: 443
    protocol: TCP
    targetPort: https
  selector:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  type: LoadBalancer
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx-controller-admission
  namespace: ingress-nginx
spec:
  ports:
  - appProtocol: https
    name: https-webhook
    port: 443
    targetPort: webhook
  selector:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  type: ClusterIP
```

Create the services.

```
kubectl apply -f services.yaml
```

`ingress-nginx-controller` creates a Loadbalancer in the respective cloud platform you are deploying.

You can get the load balancer IP/DNS using the following command.

```
kubectl --namespace ingress-nginx get services -o wide -w ingress-nginx-controller
```

> **Note**: For each cloud provider there are specific annotations you can use to map static IP address and other configs to the Loadbalancer.

### Create Ingress Controller Deployment

Create a file named `deployment.yaml` and copy the following contents.

```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  name: ingress-nginx-controller
  namespace: ingress-nginx
spec:
  minReadySeconds: 0
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app.kubernetes.io/component: controller
      app.kubernetes.io/instance: ingress-nginx
      app.kubernetes.io/name: ingress-nginx
  template:
    metadata:
      labels:
        app.kubernetes.io/component: controller
        app.kubernetes.io/instance: ingress-nginx
        app.kubernetes.io/name: ingress-nginx
    spec:
      containers:
      - args:
        - /nginx-ingress-controller
        - --publish-service=$(POD_NAMESPACE)/ingress-nginx-controller
        - --election-id=ingress-controller-leader
        - --controller-class=k8s.io/ingress-nginx
        - --configmap=$(POD_NAMESPACE)/ingress-nginx-controller
        - --validating-webhook=:8443
        - --validating-webhook-certificate=/usr/local/certificates/cert
        - --validating-webhook-key=/usr/local/certificates/key
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: LD_PRELOAD
          value: /usr/local/lib/libmimalloc.so
        image: k8s.gcr.io/ingress-nginx/controller:v1.1.1
        imagePullPolicy: IfNotPresent
        lifecycle:
          preStop:
            exec:
              command:
              - /wait-shutdown
        livenessProbe:
          failureThreshold: 5
          httpGet:
            path: /healthz
            port: 10254
            scheme: HTTP
          initialDelaySeconds: 10
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
        name: controller
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
        - containerPort: 443
          name: https
          protocol: TCP
        - containerPort: 8443
          name: webhook
          protocol: TCP
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /healthz
            port: 10254
            scheme: HTTP
          initialDelaySeconds: 10
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
        resources:
          requests:
            cpu: 100m
            memory: 90Mi
        securityContext:
          allowPrivilegeEscalation: true
          capabilities:
            add:
            - NET_BIND_SERVICE
            drop:
            - ALL
          runAsUser: 101
        volumeMounts:
        - mountPath: /usr/local/certificates/
          name: webhook-cert
          readOnly: true
      dnsPolicy: ClusterFirst
      nodeSelector:
        kubernetes.io/os: linux
      serviceAccountName: ingress-nginx
      terminationGracePeriodSeconds: 300
      volumes:
      - name: webhook-cert
        secret:
          secretName: ingress-nginx-admission
```

Create the deployment.

```
kubectl apply -f deployment.yaml
```

To ensure that deployment is working, check the pod status.

```
kubectl get pods -n ingress-nginx
```

## Deploy a Demo Application

For testing ingress, we will deploy a demo application and add a ClusterIp service to it. This application will be accessible only within the cluster without ingress.

**Step 1:** Create a namespace named dev

```
kubectl create namespace dev
```

**Step 2:** Create a file named `hello-app.yaml`

**Step 3:** Copy the following contents and save the file.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-app
  namespace: dev
spec:
  selector:
    matchLabels:
      app: hello
  replicas: 3
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
      - name: hello
        image: "gcr.io/google-samples/hello-app:2.0"
```

**Step 4:** Create the deployment using kubectl

```
kubectl create -f hello-app.yaml
```

Check the deployment status.

```
kubectl get deployments -n dev
```

**Step 5:** Create a file named `hello-app-service.yaml`

**Step 6:** Copy the following contents and save the file.

```
apiVersion: v1
kind: Service
metadata:
  name: hello-service
  namespace: dev
  labels:
    app: hello
spec:
  type: ClusterIP
  selector:
    app: hello
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
```

**Step 7:** Create the service using kubectl.

```
kubectl create -f hello-app-service.yaml
```

## Create Ingress Object for Application

Now let’s create an ingress object to access our hello app using a DNS. An ingress object is nothing but a setup of routing rules.

If you are wondering how the ingress object is connected to the Nginx controller, the ingress controller pod connects to the Ingress API to check for rules and it updates its `nginx.conf` accordingly.

Since I have wildcard DNS mapped (`*.apps.mlopshub.com`) with the DNS provider, I will use `demo.apps.mlopshub.com` to point to the hello app service.

**Step 1:** Create a file named `ingress.yaml`

**Step 2:** Copy the following contents and save the file.

Replace `demo.apps.mlopshub.com` with your domain name. Also, we are creating this ingress object in the `dev` namespace as the hello app is running in the `dev` namespace.

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  namespace: dev
spec:
  ingressClassName: nginx
  rules:
  - host: "demo.apps.mlopshub.com"
    http:
      paths:
        - pathType: Prefix
          path: "/"
          backend:
            service:
              name: hello-service
              port:
                number: 80
```

**Step 3:** Describe created ingress object created to check the configurations.

```
kubectl describe ingress  -n dev
```

Now if I try to access `demo.apps.mlopshub.com`  domain, I will be able to access the hello app as shown below. (You should replace it with your domain name)

![[Pasted image 20230919110828.png]]
## TLS With Nginx Ingress

You can configure TLS certificates with each ingress object. The TLS gets terminated at the ingress controller level.

The following image shows the ingress TLS config. The TLS certificate needs to be added as a secret object.

![[Pasted image 20230919110855.png]]
👉 Take a look at the [guide to configure ingress TLS on Kubernetes.](https://devopscube.com/configure-ingress-tls-kubernetes/)


----------------- EOB -----------------------

Test k8 setup : [https://www.youtube.com/watch?v=-ovJrIIED88&list=PL2We04F3Y_41jYdadX55fdJplDvgNGENo&index=18](https://www.youtube.com/watch?v=-ovJrIIED88&list=PL2We04F3Y_41jYdadX55fdJplDvgNGENo&index=18)