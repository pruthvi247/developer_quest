[source : kode kloud CKAD]

service vs loadbalancer vs ingress:

[link : https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0]


Headless service:

What is a Headless Service?
When there is no need of load balancing or single-service IP addresses.We create a headless service which is used for creating a service grouping. That does not allocate an IP address or forward traffic.So you can do this by explicitly setting ClusterIP to “None” in the mainfest file, which means no cluster IP is allocated.

headless-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: headless-service
spec:
  clusterIP: None # <-- Don't forget!!
  selector:
    app: api
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000

pod-def.yaml

apiVersion: v1
kind: Pod
metadata:
  name: init-demo
spec:
  containers:
  - name: nginx
    image: nginx
  subdomain:headless-service
  hostname: init-demo


### pls note that subdomain and host name we give only in pod definition file, we dont give it in deployment files

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  serviceName: headless-service
  selector:
    matchLabels:
      app: nginx
  replicas: 2 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80


## if we specify subdomain and host name to deployment then it will assign subdomain and host name to all pods, because deployment duplicates specs to all the pods.

> serviceName property in deployment definition file will help to match headless service and deployment. so all pods will get a different DNS record
> pod to pvc will work, but what happens when we use deployements with 5 replicas ?? all the 5 pods will use same persistence volume, there is nothing wrong if that is what is desired, but if we want every pod to have its own peristence volume in headless service ?? 

> We can achieve that using volume claim template 


statefulset.yaml

apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: STATEFULSET_NAME
spec:
  selector:
    matchLabels:
      app: APP_NAME
  serviceName: "SERVICE_NAME"
  replicas: 3
  updateStrategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: APP_NAME
    spec:
      containers:
      - name: CONTAINER_NAME
        image: ...
        ports:
        - containerPort: 80
          name: PORT_NAME
        volumeMounts:
        - name: PVC_NAME
          mountPath: ...
  volumeClaimTemplates:
  - metadata:
      name: PVC_NAME
      annotations:
        ...
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi




























 

















