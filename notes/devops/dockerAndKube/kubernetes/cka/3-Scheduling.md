A scheduler watches for newly created Pods that have no Node assigned. For every Pod that the scheduler discovers, the scheduler becomes responsible for finding the best Node for that Pod to run on

Predicates - Hard constraints (Memory requirement,Node selector)
Priorities - Soft constraints (Spread across multiple VM)

### Node selection in kube-scheduler[](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/#kube-scheduler-implementation)

kube-scheduler selects a node for the pod in a 2-step operation:

1. Filtering
2. Scoring

The _filtering_ step finds the set of Nodes where it's feasible to schedule the Pod. For example, the PodFitsResources filter checks whether a candidate Node has enough available resource to meet a Pod's specific resource requests. After this step, the node list contains any suitable Nodes; often, there will be more than one. If the list is empty, that Pod isn't (yet) schedulable.

In the _scoring_ step, the scheduler ranks the remaining nodes to choose the most suitable Pod placement. The scheduler assigns a score to each Node that survived filtering, basing this score on the active scoring rules.

There are two supported ways to configure the filtering and scoring behavior of the scheduler:

1. [Scheduling Policies](https://kubernetes.io/docs/reference/scheduling/policies) allow you to configure _Predicates_ for filtering and _Priorities_ for scoring (This is used more).
2. [Scheduling Profiles](https://kubernetes.io/docs/reference/scheduling/config/#profiles) allow you to configure Plugins that implement different scheduling stages, including: `QueueSort`, `Filter`, `Score`, `Bind`, `Reserve`, `Permit`, and others. You can also configure the kube-scheduler to run different profiles.
```
sort(filter(Nodes))
```
![[Pasted image 20230905124911.png]]
The following points in the workflow are open to plugin extension:
[good read](https://thenewstack.io/a-deep-dive-into-kubernetes-scheduling/)
- **QueueSort**: Sort the pods in the queue
- **PreFilter**: Check the preconditions of the pods for scheduling cycle
- **Filter**: Filter the nodes that are not suitable for the pod
- **PostFilter**: Run if there are no feasible nodes found for the pod
- **PreScore**: Run prescoring tasks to generate shareable state for scoring plugins
- **Score**: Rank the filtered nodes by calling each scoring plugins
- **NormalizeScore**: Combine the scores and compute a final ranking of the nodes
- **Reserve**: Choose the node as reserved before the binding cycle
- **Permit**: Approve or deny the scheduling cycle result
- **PreBind**: Perform any prerequisite work, such as provisioning a network volume
- **Bind**: Assign the pods to the nodes in Kubernetes API
- **PostBind**: Inform the result of the binding cycle

The simplest configuration option is setting the **nodeName** field in `podspec` directly as follows:

```yaml
### schedule-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  nodeName: node-01
```

```sh
kubectl replace --force -f schedule-pod.yaml
### Instead of deleting and recreating pod, we can use replace command
```
The nginx pod above will run on node-01 by default. However, **nodeName** has many limitations that lead to non-functional pods, such as unknown node names in the cloud, out of resource nodes, and nodes with intermittent network problems. For this reason, you should not use **nodeName** at any time other than during testing or development.

If you want to run your pods on a specific set of nodes, use **nodeSelector** to ensure that happens. You can define the **nodeSelector** field as a set of key-value pairs in `PodSpec`:

``` yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  nodeSelector:
    disktype: ssd
```
For the nginx pod above, Kubernetes Scheduler will find a node with the disktype: ssd label. Of course, the node can have additional labels, and Kubernetes already populates common labels to the nodes kubernetes.io/arch or kubernetes.io/os. You can check the complete list of tags in the [Kubernetes reference documentation](https://kubernetes.io/docs/reference/kubernetes-api/labels-annotations-taints/).

The use of `nodeSelector` efficiently constrains pods to run on nodes with specific labels. However, its use is only constrained with labels and their values. There are two more comprehensive features in Kubernetes to express more complicated scheduling requirements: **node affinity**, to mark pods to attract them to a set of nodes; and **taints and tolerations**, to mark nodes to repel a set of pods. These features are discussed below

### Annotations
You can use either labels or annotations to attach metadata to Kubernetes objects. Labels can be used to select objects and to find collections of objects that satisfy certain conditions. In contrast, annotations are not used to identify and select objects.

Here are some examples of information that could be recorded in annotations:
- Fields managed by a declarative configuration layer. Attaching these fields as annotations distinguishes them from default values set by clients or servers, and from auto-generated fields and fields set by auto-sizing or auto-scaling systems.
- Build, release, or image information like timestamps, release IDs, git branch, PR numbers, image hashes, and registry address.
- Pointers to logging, monitoring, analytics, or audit repositories.
- Client library or tool information that can be used for debugging purposes: for example, name, version, and build information.
- User or tool/system provenance information, such as URLs of related objects from other ecosystem components.
- Lightweight rollout tool metadata: for example, config or checkpoints.
- Phone or pager numbers of persons responsible, or directory entries that specify where that information can be found, such as a team web site.
- Directives from the end-user to the implementations to modify behavior or engage non-standard features.
    
Instead of using annotations, you could store this type of information in an external database or directory, but that would make it much harder to produce shared client libraries and tools for deployment, management, introspection
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: annotations-demo
  annotations:
    imageregistry: "https://hub.docker.com/"
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```


```js
/// command to read annotations
$kubectl get pods annotations-demo -o custom-columns=ANNOTATIONS:.metadata.annotations
```
## Taints and Tolerations

`Taints` and `Tolerations` are used to set restrictions on what pods can be shared on that node.

When the PODS are created, kubernetes scheduler tries to place these pods on the available worker nodes.  
As of now, there are no restrictions or limitations and so scheduler places the PODs across all of the nodes to balance them out equally.

Let us assume, we have dedicated resources on node1 for a particular use case or application. so, we would like only those PODs that belong this application to be placed on node1.

First, we prevent all PODs from placing on node1 by placing a taint on the node, lets say it as blue.  
By default, PODs won't have any tolerations i.e., unless specified otherwise none of the PODs can tolerate any taint. So, in this case none the PODs can be placed on node1 as none of them can tolerate the taint blue. i.e., no unwanted PODs can be placed on node1.  
Now, we need to enable certain PODs to be placed on this node. For this, we must specify which PODs are tolerant for this particular taint. In our case, we would like to allow only POD D to be placed on this node. So, we add a toleration to POD D. POD D is now tolerant to blue. Now, when scheduler tries to place POD D on node1, it goes through. Node1 can only accept PODs that are tolerant to blue taint.

![[Pasted image 20230905140958.png]]

#Note " Taints are set on nodes and Tolerations are set on PODs "

### Taints - Node
[good read](https://bhavyasree.github.io/kubernetes-CKAD/14.taints-tolerations/)

`kubectl taint nodes node-name key=value:taint-effect`  
To taint a node , specify the node name to taint followed by a taint itself which is a key value pair.  
taint-effect defines what would happen to the PODs if they do not tolerate the taint.

There are three taint effects.  
* `NoSchedule` -- PODs will not be scheduled on the node. 
* `PreferNoSchedule` -- The system will try to avoid placing a POD on the node but that is not guaranteed. 
* `NoExecute` -- The new PODs will not be scheduled on the node and the existing pods on the nodes will be evicted if they do not tolerate the taint. These PODs may have been scheduled on the node before taint was applied on the node.

`kubectl taint nodes node1 app=blue:NoSchdule`

### Tolerations - PODs

To add a toleration to the POD, pull up the pod-definition file, under spec section, add tolerations section and in this section move all the values thats specified while placing taint on the node.
`kubectl taint nodes node1 app=blue:NoSchedule`

`pod-definition file`
``` yaml
apiVersion: v1
kind: Pod
metadata: 
  name: myapp-pod
spec:
  containers:
   - name: nginx-container
      image: nginx
  tolerations:
    - key: "app"
      operator: "Equal"
      value: "blue"
      effect: "NoSchedule"
```
When the PODs are now created or update with new tolerations, they are either not scheduled on node1 or evicted from the existing node, depending on the effect set.

Taints and Tolerations are only meant to retsrict nodes from accepting certain PODs. It does not gurantee that the POD with the toleration will be kept only placed on the node with taint. Since there won't be any taints on other nodes, the POD with toleration can very well be placed on other nodes.

#Note " Taints and Tolerations does not tell the POD to go to a particular node. Instead, it tells the node to only accept PODs with certain Tolerations."

The second Pod below can be also scheduled onto a tainted node although it uses the operator “**Exists**” and does not have the key’s value defined.
```yaml
apiVersion: v1  
kind: Pod  
metadata:  
name: pod-2  
labels:  
security: s1  
spec:  
containers:  
- name: bear  
image: supergiantkir/animals:bear  
tolerations:  
- key: "app"  
operator: "Exists"  
effect: "NoSchedule"
```
---------------------------SOB-------------------------------
Below point from blog : https://medium.com/kubernetes-tutorials/making-sense-of-taints-and-tolerations-in-kubernetes-446e75010f4e
#### Master Node :
The scheduler does not schedule any PODs on the master node.  
When the kubernetes cluster is first set up, a taint is set up on the master node automatically that prevents any PODs from being scheduled on this node.  
We can modify this if required. However, the best practice is to not deploy application workloads on master server.

To view the taints on the master node  
`kubectl describe node <nodename> | grep Taint`

The image below illustrates two tolerations using the operator:”Equal” . Because we use this operator, the toleration’s and taint’s keys, values, and effects all should be _equal_. Therefore, only the first Pod that has the same key, value, and effect as the taint can be scheduled onto the `host1` .
![[Pasted image 20230905143015.png]]

# Some Special Cases

Let’s take a look at another toleration example:
```yaml
apiVersion: v1  
kind: Pod  
metadata:  
name: pod-2  
labels:  
security: s1  
spec:  
containers:  
- name: bear  
image: supergiantkir/animals:bear  
tolerations:  
- operator: "Exists"
```
As you see, the key , value , and effect fields of this Pod’s toleration are empty. We just used the operator: `Exists` . This toleration will match all keys, values, and effects. In other words, it will tolerate any node.

Let’s look at yet another example:
```yaml
apiVersion: v1  
kind: Pod  
metadata:  
name: pod-2  
labels:  
security: s1  
spec:  
containers:  
- name: bear  
image: supergiantkir/animals:bear  
tolerations:  
- operator: "Exists"  
key: "special"
```
The toleration with the empty effect in this Pod will match all effects with the key “special”.

#### Working with Multiple Taints and Tolerations

Kubernetes users can set multiple taints on nodes. The process of matching tolerations with these taints then works as a filter. The system will ignore those taints for which the tolerations exist and make _un-ignored_ taints have the indicated effect on the Pod.

Let’s illustrate how this works by applying several taints to our node:
```js
kubectl taint nodes host1 key1=value1:NoSchedule  
kubectl taint nodes host1 key1=value1:NoExecute  
kubectl taint nodes host1 key2=value2:NoSchedule
```
Next, let’s specify two tolerations in the Pod:
```yaml
apiVersion: v1  
kind: Pod  
metadata:  
name: pod-2  
labels:  
security: s1  
spec:  
containers:  
- name: bear  
image: supergiantkir/animals:bear  
tolerations:  
- key: "key1"  
operator: "Equal"  
value: "value1"  
effect: "NoSchedule"  
- key: "key1"  
operator: "Equal"  
value: "value1"  
effect: "NoExecute"
```

This Pod tolerates the first and the second taint but does not tolerate the third taint with the effect `NoSchedule` . Even though the Pod has two matching tolerations, it won’t be scheduled onto the `host01` . The Pod, however, will continue running on this node if it was scheduled before the taint is added because it tolerates the `NoExecute` effect.

#### NoExecute Effect

The taint with the `NoExecute` effect results in the eviction of all Pods without a matching toleration from the node. When using the toleration for the `NoExecute` effect you can also specify an optional `tolerationSeconds` field. Its value defines how long the Pod that tolerates the taint can run on that node before eviction and after the taint is added. Let’s look at the manifest below:
```yaml
apiVersion: v1  
kind: Pod  
metadata:  
name: pod-2  
labels:  
security: s1  
spec:  
containers:  
- name: bear  
image: supergiantkir/animals:bear  
tolerations:  
- key: "key1"  
operator: "Equal"  
value: "value1"  
effect: "NoExecute"  
tolerationSeconds: 3600
```

If this Pod is running and a matching taint is added to the node, it will stay bound to the node for `3600` seconds. If the taint is removed by that time, the Pod won’t be evicted.

In general, the following rules apply for the `NoExecute` effect:

- Pods with no tolerations for the taint(s) are evicted immediately.
- Pods with the toleration for the taint but that do not specify `tolerationSeconds` in their toleration stay bound to the node forever.
- Pods that tolerate the taint with a specified `tolerationSeconds` remain bound for the specified amount of time.

### TaintNodesByCondition Feature and Taints Based Evictions

Kubernetes 1.6 introduced alpha support for representing [node conditions](https://kubernetes.io/docs/concepts/architecture/nodes/#condition). The node controller adds the `conditions` field that describes the status of all `Running` nodes. This feature is very useful for monitoring node health and configuring Pod’s behavior when a certain condition is met.

This feature is important for our discussion of taints and tolerations because in the recent versions of Kubernetes nodes are automatically tainted by the node controller based on their conditions and users can interact with these conditions to change the default Pod scheduling behavior. This feature is known as `TaintNodesByCondition` .

Since Kubernetes 1.8 up to Kubernetes 1.11, `TaintNodesByCondition` feature is available as alpha. This means that it is disabled by default in these versions. However, administrators can use [feature gates](https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/) to enable `TaintNodesByCondition` in these releases. Feature gates are a set of `key=value` pairs that allow disabling/enabling alpha or experimental features.

There are many other taints by default provided by k8's. For example, `node.kubernetes.io/unschedulable` is added if the node is unschedulable and `node.cloudprovider.kubernetes.io/uninitialized` is added to identify that the node is unusable until a controller from the `cloud-controller-manager` initializes this node.

You can check the node conditions by running:

!!! Users can choose to ignore certain node problems by adding appropriate Pod tolerations. If your cluster has `TaintNodesByCondition` enabled, you can then use tolerations to allow Pods to be scheduled onto nodes with these taints. For example:
```yaml
kind: Pod  
apiVersion: v1  
metadata:  
name: test  
spec:  
tolerations:  
- key: node.kubernetes.io/network-unavailable  
operator: Exists  
effect: NoSchedule  
- key: node.kubernetes.io/notReady  
operator: Exists  
effect: NoSchedule  
containers:  
- name: nginx  
image: nginx
```
This Pod will be scheduled onto nodes even if they have the taints `node.kubernetes.io/network-unavailable` and `node.kubernetes.io/notReady` applied by the node lifecycle controller.

### Taint-based Evictions

Another useful feature for advanced Pod scheduling is taint-based evictions introduced in Kubernetes 1.6 as alpha. Similarly to `TaintNodesByCondition` , `TaintBasedEvictions` allows automatically adding taints to nodes based on node conditions. If this feature is enabled and `NoExecute` effect is used users can change the normal logic of Pod eviction based on the Ready `NodeCondition` .

Using taint-based evictions is quite simple. Let’s say you have an application that has accumulated a lot of local state. Ideally, you would want it to stay bound to the unreachable node hoping that the node controller will hear from it soon. In this case, you can use the following Pod toleration:

```yaml
apiVersion: v1  
kind: Pod  
metadata:  
name: pod-2  
labels:  
security: s1  
spec:  
containers:  
- name: bear  
image: supergiantkir/animals:bear  
tolerations:  
- key: "node.kubernetes.io/unreachable"  
operator: "Exists"  
effect: "NoExecute"  
tolerationSeconds: 6000
```
This toleration will make the Pod bound to the unreachable node for 6000 seconds.

#Note: if the taint-based evictions are enabled, Kubernetes will automatically add default toleration for `node.kubernetes.io/not-ready` with `tolerationSeconds=300` . The user-defined toleration can then change this default behaviour.

## Implementing Dedicated Nodes using Taints and Node Affinity

At the beginning of the article, we mentioned that taints and tolerations are very convenient for creating dedicated nodes. Let’s implement this use case with the example below.

### Step 1: Add taints

The first step is to add a taint to one or more nodes. The Pods that are allowed to use these nodes will tolerate the taint. We attach the same taint `dedicated=devs:NoSchedule` to a couple of nodes to mark them as dedicated nodes for the Devs team.

```js
kubectl taint nodes host1 dedicated=devs:NoSchedule  
node “host1” tainted
kubectl taint nodes host2 dedicated=devs:NoSchedule  
node “host2” tainted
```

## Step 2 Add Label to a Node

Next, we need to attach a label to the same set of nodes (we’ll use the same key/value pair for the node label as we used for the taint). Thus, Pods that tolerate the taint must also use the node affinity or `nodeSelector` matching the label to be able to run on those nodes. Let’s go ahead and attach the label to both nodes.
```js
kubectl label nodes host1 dedicated=devs  
node “host1” labeled
kubectl label nodes host2 dedicated=devs  
node “host2” labeled
```
### Step 3 Add Tolerations and Affinity

Finally, we need to create a Pod with the matching toleration for the above-created taint and the appropriate node affinity’s `nodeSelectorTerms` that matches the node’s label we created in the second step. The manifest will look something like this
```yaml
apiVersion: v1  
kind: Pod  
metadata:  
name: pod-test  
spec:  
affinity:  
nodeAffinity:  
requiredDuringSchedulingIgnoredDuringExecution:  
nodeSelectorTerms:  
- matchExpressions:  
- key: dedicated  
operator: In  
values:  
- devs  
tolerations:  
- key: "dedicated"  
operator: "Equal"  
value: "devs"  
effect: "NoSchedule"  
containers:  
- name: just-container  
image: supergiantkir/animals:bear
```
As you see, we used “hard” `requiredDuringSchedulingIgnoredDuringExecution` node affinity to ensure that the Pod is scheduled only onto the nodes with the “**dedicated:devs**” label. We also specified one toleration with the key “**dedicated**“, the value “**devs**” and the effect “**NoSchedule**“. This toleration matches the taints of two nodes we attached above.

Since this Pod also has the affinity label selector that matches the node label, it will be scheduled only onto those two nodes that we created. This will make these nodes dedicated for the Pod. The Devs team can then create Pods with this label and toleration to ensure that they use only two nodes allocated to them by the IT department.
---------------------------EOB-------------------------------

## Kubernetes Node Selector vs. Node Affinity

In Kubernetes, you can create flexible definitions to control which pods should be scheduled to which nodes. Two such mechanisms are node selectors and node affinity. Both of them are defined in the pod template.

Both node selectors and node affinity can use Kubernetes labels—metadata assigned to a node. Labels allow you to specify that a pod should schedule to one of a set of nodes, which is more flexible than manually attaching a pod to a specific node.

The difference between node selector and node affinity can be summarized as follows:

- **A node selector** is defined via the nodeSelector field in the pod template. It contains a set of key-value pairs that specify labels. The Kubernetes scheduler checks if a node has these labels to determine if it is suitable for running the pod.
- **Node affinity** is an expressive language that uses soft and hard scheduling rules, together with logical operators, to enable more granular control over pod placement.
### Kubernetes Node Affinity

Node affinity defines under which circumstances a pod should schedule to a node. There are two types of node affinity:

- **Hard affinity**—also known as required node affinity. Defined in the pod template  
    `under``spec:` `affinity:nodeAffinity:requiredDuringSchedulingIgnoredDuringExecution`. This specifies conditions that a node must meet for a pod to schedule to it.
- **Soft affinity**—also known as preferred known affinity. Defined in the pod template under `spec:affinity:nodeAffinity:preferredDuringSchedulingIgnoredDuringExecution`. This specifies conditions that a node should preferably meet, but if they are not present, it is still okay to schedule the pod (as long as hard affinity criteria are met).

Both types of node affinity use logical operators including `In, NotIn, Exists`, and `DoesNotExist`.

It is a good idea to define both hard and soft affinity rules for the same pod. This makes scheduling more flexible and easier to control across a range of operational situations.


### Kubernetes Anti-Affinity

Anti-affinity is a way to define under which conditions a pod should **not** be scheduled to a node. Common use cases include:

- **Avoiding single point of failure**—when distributing a service across multiple pods, it is important to ensure each pod runs on a separate node. Anti-affinity can be used to achieve this.
- **Preventing competition for resources**—certain pods might require ample system resources. Anti-affinity can be used to place them away from other resource-hungry pods.

Kubernetes provides the `spec:affinity:podAntiAffinity` field in the pod template, which allows you to prevent pods from scheduling with each other. You can use the same operators to define criteria for pods that the current pod should not be scheduled with.

Note that there is no corresponding “node anti affinity” field. In order to define which nodes a pod should not schedule to, use the Kubernetes taints and tolerations feature (learn more in our guide to [Kubernetes nodes](https://komodor.com/learn/kubernetes-nodes-complete-guide/)).

![[Pasted image 20230905191636.png]]

# Resource Management for Pods and Containers

When you specify a [Pod](https://kubernetes.io/docs/concepts/workloads/pods/), you can optionally specify how much of each resource a [container](https://kubernetes.io/docs/concepts/containers/) needs. The most common resources to specify are CPU and memory (RAM);

if the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more resource than its `request` for that resource specifies. However, a container is not allowed to use more than its resource `limit`.

For example, if you set a `memory` request of 256 MiB for a container, and that container is in a Pod scheduled to a Node with 8GiB of memory and no other Pods, then the container can try to use more RAM.

## How to set Resource Request & Limits

In the below example, we have a pod with two containers: `app` and `log-aggregator`. The sidecar container helps facilitate the proper execution of core business logic in the main container.

```yaml
apiVersion: v1
  kind: Pod
  metadata:
   name: frontend
  spec:
   containers:
   - name: app
     image: images.my-company.example/app:v4
     resources:
       requests:
         memory: "64Mi"
         cpu: "250m"
       limits:
         memory: "128Mi"
         cpu: "500m"
   - name: log-aggregator
     image: images.my-company.example/log-aggregator:v6
     resources:
       requests:
         memory: "64Mi"
         cpu: "250m"
       limits:
         memory: "128Mi"
         cpu: "500m"
```

As you can see, resource requests and limits are specified for each container. The pod also tracks this information in totality using two fields:

Resource.requested: equal to the sum of requested resources for all of its containers Resources.limited: equal to the sum of limited resources for all of its containers.

These pod fields are used to locate which node is best for scheduling the pod. The Kubernetes control plane’s algorithms compare the resource requests to the available resources on each node in the cluster, and automatically assign a node to the pod being provisioned

### CPU Resource Requests and Limits

Limits and request for CPU resources are measured in millicores. If your container needs one full core to run, you would put the value “1000m.” If your container only needs ¼ of a core, you would put a value of “250m.”

That seems straight-forward enough. But what happens if you accidentally provide a value larger than the core count of your biggest node? Requesting 2000m from a cluster of quad-core machines is no problem; but 5000m? Your pod will never be scheduled.

On the other hand, let’s say that you quickly hit the CPU resource limit after your pod is deployed onto a worker node. Since CPU is considered as a compressible resource, instead of terminating the container, Kubernetes starts throttling it which could result in a slow-running application that is difficult to diagnose.

### Memory Resource Requests and Limits

Limits and requests for Memory resources are defined in bytes. Most people typically provide a mebibyte value for memory (essentially, the same thing as a megabyte), but you can also use anything from bytes to petabytes.

Similar to over-requested CPU resources, placing a memory request larger than the amount of memory on your nodes causes the pod to not get scheduled. However, unlike how a container throttles its pod when CPU limits have been met, a pod might simply terminate when its memory limit is met.

If the pod is restartable, the kubelet will restart it, but keep in mind that containers which exceed their memory requests can cause the offending pod to get evicted whenever the node runs out of memory. An eviction happens when a cluster is running out of either memory or disk, which in turn causes kubelets to reclaim resources, kill containers, and declare pods as failed until the usage rises above the eviction threshold level.

## [Setting Requests & Limits Via Namespaces](https://www.densify.com/kubernetes-tools/kubernetes-resource-limits/)

Kubernetes namespaces help divide a cluster into multiple virtual clusters. You can then allocate your virtual clusters to specific applications, services, or teams. This is useful when you have several engineers or engineering teams working within the same large Kubernetes cluster.

After you have defined namespaces for all of your teams, we advise establishing consistent resource requirement thresholds for each namespace to ensure no resources are needlessly reserved. You can achieve this using [Resource Quotas](https://www.densify.com/kubernetes-autoscaling/kubernetes-resource-quota/) and Limit Ranges to allocate resources to those namespaces.

### Resource Quotas

Resource quotas guarantee a fixed amount of compute resources for a given virtual cluster by reserving the quoted resources for exclusive use within a single, defined namespace.

Over-commitments stemming from generously defined resource quotas are a common reason for increased infrastructure cost. However, under-committed resource quotas risk degrading your application’s performance.

You can also use resource quotas to limit the number of objects created by a given type or by its resource consumption within the namespace.

#### Example

Let’s create a resource quota on a number of pods.

First, we’ll specify a hard limit of 2 pods. This means one can only create 2 pods in the default namespace.
```sh

cat <<EOF | kubectl apply -f -
  apiVersion: v1
  kind: ResourceQuota
  metadata:
   name: pod-examples
  spec:
   hard:
     pods: "2"
  EOF
```
The next step is to run the above command in the terminal to create a resource quota named pod-examples.

## A quick note on editing Pods and Deployments

#### Edit a POD

Remember, you CANNOT edit specifications of an existing POD other than the below.
- spec.containers[*].image
- spec.initContainers[*].image
- spec.activeDeadlineSeconds
- spec.tolerations
    

For example you cannot edit the environment variables, service accounts, resource limits (all of which we will discuss later) of a running pod. But if you really want to, you have 2 options:

1. Run the `kubectl edit pod <pod name>` command.  This will open the pod specification in an editor (vi editor). Then edit the required properties. When you try to save it, you will be denied. This is because you are attempting to edit a field on the pod that is not editable.
![[Pasted image 20230905200650.png]]
![[Pasted image 20230905200700.png]]

A copy of the file with your changes is saved in a temporary location as shown above.

You can then delete the existing pod by running the command:

`kubectl delete pod webapp`

Then create a new pod with your changes using the temporary file
`kubectl create -f /tmp/kubectl-edit-ccvrq.yaml`

2. The second option is to extract the pod definition in YAML format to a file using the command
`kubectl get pod webapp -o yaml > my-new-pod.yaml`

Then make the changes to the exported file using an editor (vi editor). Save the changes
`vi my-new-pod.yaml`
Then delete the existing pod
`kubectl delete pod webapp`
Then create a new pod with the edited file
`kubectl create -f my-new-pod.yaml`
#### Edit Deployments

With Deployments you can easily edit any field/property of the POD template. Since the pod template is a child of the deployment specification,  with every change the deployment will automatically delete and create a new pod with the new changes. So if you are asked to edit a property of a POD part of a deployment you may do that simply by running the command

`kubectl edit deployment my-deployment`

# DemonSet
The DaemonSet feature is used to ensure that some or all of your [pods](https://www.bmc.com/blogs/kubernetes-pods/) are scheduled and running on every single available node. This essentially runs a copy of the desired pod across all nodes.

- When a new node is added to a Kubernetes cluster, a new pod will be added to that newly attached node.
- When a node is removed, the DaemonSet controller ensures that the pod associated with that node is garbage collected. Deleting a DaemonSet will clean up all the pods that DaemonSet has created.
Use case: 
- To run a daemon for logs collection on each node, such as Fluentd and logstash.
- To run a daemon for [node monitoring](https://www.bmc.com/blogs/kubernetes-monitoring/) on every note, such as Prometheus Node Exporter, collectd, or Datadog agent.
![[Pasted image 20230906213455.png]]

#CommonCommands 
```
kubectl apply -f <<DaemonSet>>
kubectl get daemonsets -A
kubectl describe daemonsets <daemonsetname> -n <name space>
```

- The default strategy in Kubernetes, this will delete old DaemonSet pods and automatically create new pods when a DaemonSet template is updated.
- When using this option, new DaemonSet pods are created only after a user manually deletes old DaemonSet pods.

DaemonSet pods adhere to taints and tolerations in Kubernetes. The node.kubernetes.io/unschedulable:NoSchedule toleration is automatically added to DaemonSet pods.

# Static Pods

_Static Pods_ are managed directly by the kubelet daemon on a specific node, without the [API server](https://kubernetes.io/docs/concepts/overview/components/#kube-apiserver) observing them. Unlike Pods that are managed by the control plane (for example, a [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)); instead, the kubelet watches each static Pod (and restarts it if it fails).

Static Pods are always bound to one [Kubelet](https://kubernetes.io/docs/reference/generated/kubelet) on a specific node.

Static pods are pods created and managed by kubelet daemon on a specific node without API server observing them. If the static pod crashes, kubelet restarts them. Control plane is not involved in lifecycle of static pod. Kubelet also tries to create a mirror pod on the kubernetes api server for each static pod so that the static pods are visible i.e., when you do `kubectl get pod` for example, the mirror object of static pod is also listed.
![[Pasted image 20230906215139.png]]
![[Pasted image 20230906215035.png]]

You almost never have to deal with static pods. Static pods are usually used by software bootstrapping kubernetes itself. For example, `kubeadm` uses static pods to bringup kubernetes control plane components like api-server, controller-manager as static pods. `kubelet` can watch a directory on the host file system (configured using `--pod-manifest-path` argument to kubelet) or sync pod manifests from a web url periodically (configured using `--manifest-url` argument to kubelet). When `kubeadm` is bringing up kubernetes control plane, it generates pod manifests for api-server, controller-manager in a directory which kubelet is monitoring. Then kubelet brings up these control plane components as static pods.

#Note  
We can only create static pods but not replica sets or deployments

![[Pasted image 20230906214806.png]]

#Note 
- Static pods will have node name in the end when we do `kubectl get pods`
- we can also see if pod is static by looking at `owner` property by describing pod
#Important
> To see static pod configurations `cat /var/lib/kubelet/conf.yaml` 

# Multiple Schedulers
Kubernetes ships with a default scheduler that is described [here](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/). If the default scheduler does not suit your needs you can implement your own scheduler. Moreover, you can even run multiple schedulers simultaneously alongside the default scheduler and instruct Kubernetes what scheduler to use for each of your pods.

`kubectl get events -o wide` //Command to view schedulers
