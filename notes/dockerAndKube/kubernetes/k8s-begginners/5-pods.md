[Source](https://rakuten.udemy.com/course/learn-kubernetes/learn/lecture/9723234#overview)

# Kubernetes controllers

 Controllers are the brain behind Kubernetes. They are processes that monitor kubernetes objects and respond accordingly.

**Replica set vs Replica controllers**
Both have the same purpose but they are not the same. Replication Controller is the older technology that is being replaced by Replica Set. Replica set is the new recommended way to setup replication.There are minor differences in the way each works.
`replication-controller-def.yml`
```yml
apiVersion: v1  
kind: ReplicationController
metadata:
	name: myapp-rc 
	labels:
		app: myapp
		type: front-end  
spec:
 - template:
	 metadata:  
		name: myapp-pod 
		labels:
			app: myapp
			type: front-end 
	spec:
	containers:  
	- name: nginx-container
	  image: nginx

 replicas: 3
```

`replication-set-def.yml`
```yml
apiVersion: apps/v1  
kind: ReplicaSet
metadata:
	name: myapp-replicaset
	labels:
		app: myapp
		type: front-end  
spec:
 - template:
	 metadata:  
		name: myapp-pod 
		labels:
			app: myapp
			type: front-end 
	spec:
	containers:  
	- name: nginx-container
	  image: nginx

 replicas: 3
 selector:
 matchLabels:
	 type: front-end
```
> there is one major difference between replication controller and replica set. Replica set requires a selector definition. The selector section helps the replicaset identify what pods fall under it. But why would you have to specify what PODs fall under it, if you have provided the contents of the pod-definition file itself in the template? It’s BECAUSE, replica set can ALSO manage pods that were not created as part of the replicaset creation. Say for example, there were pods created BEFORE the creation of the ReplicaSet that match the labels specified in the selector, the replica set will also take THOSE pods into consideration when creating the replicas


Commands: 
```
> kubectl create -f replicaset-definition.yml
> kubectl get replicaset
> kubectl delete replicaset myapp-replicaset (Also delets all underlying POD's)
> kubectl replace -f replicaset-definition.yml
> kubectl scale --replicas=6 -f replicaset-definition.yml
> kubectl scale --replicas=6  replicaset myapp-replicaset
```

# Deployments

k8's deployment provides us with capabilities to upgrade the underlying instances seamlessly using rolling updates, undo changes, and pause and resume changes to deployments.
when newer versions of application builds become available on the docker registry, you would like to UPGRADE your docker instances seamlessly.

However, when you upgrade your instances, you do not want to upgrade all of them at once as we just did. This may impact users accessing our applications, so you may want to upgrade them one after the other. And that kind of upgrade is known as Rolling Updates.
```
apiVersion: apps/v1 
kind: Deployment 
metadata:
  name: myapp-deployment 
  labels:
    app: myapp
    type: front-end 
spec:
  template: 
    metadata:
      name: myapp-pod 
      labels:
        app: myapp
        type: front-end 
    spec:
      containers:
      - name: nginx-container
  replicas: 3 
  selector:
    matchLabels:
      type: front-end
```


# Rollout and versioning

A rollout is the process of gradually deploying or upgrading your application containers. When you first create a deployment, it triggers a rollout. A new rollout creates a new Deployment revision. Let’s call it revision 1. In the future when the application is upgraded – meaning when the container version is updated to a new one – a new rollout is triggered and a new deployment revision is created named Revision 2. This helps us keep track of the changes made to our deployment and enables us to rollback to a previous version of deployment if necessary.

**commands**
> kubectl rollout status deployment/myapp-deployment
> kubectl rollout history deployment/myapp-deployment
> kubectl rollout undo deployment/myapp-deployment
> 





  
  