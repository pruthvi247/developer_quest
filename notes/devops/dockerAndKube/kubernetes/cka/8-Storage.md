## Volumes

The data that is on the container lives with the container, It means that if the container died the data is destroyed. To persit the date, we have to attach a volumne in the container to retain permanently.

**Example**

- In volumes, firt we need to create the volume call it: data-volume, then the hostPath where we will store the data
- In container section, we mount the data-volume in a container directory /opt
- If the pod is deleted the file /data still on the host

```shell
kubect create -f pod-definition.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: random-number-generator
spec:
  containers:
  - name: alpine
    image: alpine
    command: ["/bin/sh", "-c"]
    args: ["shuf -i 0-100 -n 1 >> /opt/number.out;"]
    volumeMounts:
    - mountPath: /opt
      name: data-volume
  volumes:
    - name: data-volume
      hostPath:
        path: /data
        type: Directory
```

!!! Note: One issue with above volume path is, if pod restarts there are chances that pod starts in any node of cluster but not the same node where it was running earlier, hence data would be lost. We can overcome this by creating persistent volumes which is common across cluster


## Persistent Volumes - PV

A persistent volume is a cluster wide pool of storage volumes configured by an administrator to be used. The users can select storage from this pool using Persisten Volume claims.

Note: AccessModes support:

- ReadOnlyMany
- ReadWriteOnce
- ReadWriteMany
![[Pasted image 20230917103701.png]]

```shell
kubectl create -f pv-definition.yaml
kubectl get persistentvolume
```

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-vo11
spec:
  accessModes:
    - ReadWriteOnde
  capacity:
    storage: 1Gi
  hostPath:
    path: /data
```

## Persistent Volumes Claims - PVC

Persistent volumes and persistent volume claims are separate objects in Kubernetes namespaces. An administrator create a persistent volumes and an user create a persisten volume claims to use storage.

Kubernetes binds the persistent Volumes to Claims based. Every persistent Volume Claim is bound to a single Persistent Volume.

```shell
kubectl create -f pvc-definition.yaml
kubectl get persistentvolumeclaim
```

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests: 
      storage: 500Mi
```

Note: The Persistent Volume Claim after creation will be on Pending status, when claim is created Kubernetes looks for a "volume" created previously, if the accessModes match, the capacity is less thatn Persistent Volume, since there are not other who match with the claim requierement, the persistent volume claim will be bound to the persisten volume.

```shell
kubectl get persistentvolumeclaim
kbuectl create -f pvc-definition.yaml
```

### Deleting PVCs

```shell
kubectl delete persistencevolumeclaim myclaim

# We can choose what do with the volume,, by default is Retain
PesistentVolumeReaclaimPolicy: Retain  # The persistent volume will remain until it is deleted manually by the administrator, is not available for other claims
PesistentVolumeReaclaimPolicy: Delete # Delete automatically, if the claim is deleted the volume will be deleted too
PesistentVolumeReaclaimPolicy: Recycle # The data in the data volume will be scrubbed before making it availabe to other claims
```

## Using PVCs in PODs

In the pod we are using the Persistent Claim that we already created "myclaim" as a volume. Then mount that volumen in the container.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim
```

```shell
#logs
kubectl exec webapp -- cat /log/app.log
```
### Other commands

```shell
kubectl get pvc
kubectl get pv
k get pv,pvc
k delete pvc claim-log-1
```

# Storage classes

## What Is Kubernetes StorageClass?

A Kubernetes StorageClass is a [Kubernetes storage](https://bluexp.netapp.com/blog/cvo-blg-kubernetes-storage-an-in-depth-look) mechanism that lets you dynamically provision persistent volumes (PV) in a Kubernetes cluster. Kubernetes administrators define classes of storage, and then pods can dynamically request the specific type of storage they need.

Storage classes can define properties of storage systems such as:

- Speed (for example, SSD vs. HDD storage)
- Quality of service levels
- Backup or replication policies
- Type of file system
- Or any other property defined by the administrator

Every StorageClass has the following fields:

- Provisioner—this is the plugin used to provision the storage volume
- Parameters—indicate properties of the underlying storage system
- reclaimPolicy—indicates under what conditions the storage is released by a pod and can be reclaimed for use by other pods

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
    name: my-storageclass
provisioner: kubernetes.io/aws-ebs
volumeBidingMode: WaitForFirstConsumer
```
- **Provisioner:** This property is essential, and it must be specified. It is a field that determines which volume plugin should be used to provision the PVs. There are many volume plugins that are classified as either internal or external provisioners. (e.g., GCEPersistentDisk, Azuredisk, Azurefile, AWSElasticBlockStore, NFS, Flexvolume, Local, etc.). The first four use internal provisioner plugins, while the last three are external. Each of these has its config example used as part of the provisioner field’s value, depending on which volume plugin you want to use.

The table below shows the standard volume plugins and their provisioners.

![plugins and their provisioners](https://d33wubrfki0l68.cloudfront.net/35e34b766bee7a412d9bbafa72fdf7c0027fc2c2/3da9e/static/storage-class.jpg)

You can find more volume plugins and their provisioners here [Kubernetes official documentation](https://kubernetes.io/docs/concepts/storage/storage-classes/).

- **volumeBindingMode:** This property has two values, Immediate and WaitForFirstConsumer.
    
    - **Immediate Mode:** This mode involves the automatic volume binding of PVs to PVCs with a StorageClass once a PVC is created.
    - **WaitForFirstConsumer Mode:** This mode will delay the binding and dynamic provisioning of PVs, until a Pod that will use it is created.

The following stages will guide you through how to create and use a StorageClass.

**Stages:**

1. Create a StorageClass
2. Create a PVC for storage request from StorageClass
3. Create a Pod to consume the claim by referencing the PVC in the Pod


```bash
kubectl get sc my-storageclass
```
**Create a PVC:** You can read more on [PVC](https://www.kubermatic.com/blog/keeping-the-state-of-apps-4-persistentvolumes-and-persistentvolum/) in this [previous](https://www.kubermatic.com/blog/keeping-the-state-of-apps-4-persistentvolumes-and-persistentvolum/) chapter in the series. A **“storageClassName”** property should be added to the PVC manifest file, with the StorageClass name created in stage 1 as its value, which in this case will be **“my-storageclass”**. When this field is omitted, the default StorageClass, which is **“Standard,”**, will be provisioned with the PVC. It is always suggested to reference the StorageClass name in the PVC to use the desired StorageClass. The complete configuration will look like this:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-claim
spec:
   accessModes:
     - ReadWriteOnce
   storageClassName: my-storageclass 	
   resources:
       requests:
           storage: 2Gi
```
**Step 1:** Create the PVC with `kubectl create` command:

```bash
$ kubectl create -f my-pvc.yaml
  persistentvolumeclaim/my-claim created
```

**Step 2:** Check the status of the PVC:

```bash
$ kubectl get pvc my-claim

NAME       STATUS   VOLUME   CAPACITY   ACCESS  MODES   STORAGECLASS     AGE
my-claim   Pending                                      my-storageclass  9s
```

The status output shows that the PVC is pending, because **WaitForFirstConsumer** is used as the **VolumeBindingMode** value in the StorageClass configuration. It will remain in this state until a Pod that will consume the claim is created.

Now, Check the **PersistentVolume** status using `kubectl get` command:

```bash
$ kubectl get pv
No resources found
```

You can’t see an available PersistentVolume on the cluster, even though a PVC has been created. Delete the PVC and then the StorageClass, change the **volumeBindingMode** value in the StorageClass manifest file to **“Immediate,”** create the two objects again and check the status. You can now go to **stage 3** and create a Pod.

**Stage 3:**

**Create a Pod to consume the claim:** The previous configuration will be used. The **PVC** name must be the same as the **persistentClaimVolume.claimName** field’s value in the Pod. The configuration will look like this:

```yaml
apiVersion: v1
kind: Pod
metadata:
    name: my-pod
spec:
   containers:
   - name: stclass-test
      image: nginx
      volumeMounts:
      - mountPath: "/app/data"
        name: my-volume
   volumes:
    - name: my-volume
      persistentVolumeClaim:
         claimName: my-claim 
```

