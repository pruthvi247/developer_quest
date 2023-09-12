The important aspects of deployments are: Upgrade, Rollout, Rollback.

**Upgrade**: The ability to deploy latest major version and shut older version(s).

**Rollout**: The ability to deploy lates minor version (bugfix, hotfix, minor feature, enhancement) without downtime.

**Rollback**: The ability to restore back the older working version in case something goes wrong.

> H**ere is what happens in the world of K8s:**

1. When we first create a deployment, it creates a rollout.
2. A new rollout creates a new revision.
3. In the future, when a new deployment (of same name) is triggered, a new rollout is created with increased version.
4. This helps us keeps track of changes made and enables us to rollback to previous version deployment.
5. To check status of rollout: `kubectl rollout status deployment <deployment-name>`
6. To check the history, revision and change-cause of rollout: `kubectl rollout history deployment <deployment name>`
### **What is Revision:**

Whenever we create/update a Pod using the Deployment, the Kubernetes will create versioning for the Deployment. That is called **Revision**. Revision assigns an incremental number to each change of the deployment like 1, 2, 3, etc. And stores a copy of the YAML code used for creating/updating the deployment in each revision.

### **Deployment strategy #1 -> Recreate:**

1. Suppose there are 5 instances of your app running
2. When deploying a new version, we can destroy the 5 instances of older version and then deploy 5 instances of newer version.
3. The issue is there will be a downtime.
4. This is majorly done during major changes, breaking changes or when backward compatibility is not possible.
5. This is not the default strategy in K8s.

###  **Deployment strategy #2 -> Rolling update:**

1. In this strategy, we do not drop all the already running instances.
2. We drop instances by a certain percentage at a time and simultaneously spawn equal percentage of newer version pods.
3. This upgrade is the default strategy in K8s.
4. This has no downtime.

### How upgrades work under the hood:

1. When a deployment is applied, it creates a replica-set and spins up pods with number of instances as mentioned in the deployment configuration.
2. Then, when the deployment is re-applied with changes, it creates a new replica-set and spins up pods with number of instances as mentioned in the deployment configuration and drops pod simultaneously from older replica-set.
3. But the thing to note is, the older replica-set still exists, which will be used for rollback if required.
4. To rollback a deployment: `kubeclt rollout undo deployment <deployment name>` — this will also run in the similar sequence as it happened while upgrade.
5. After rollback the new replicaset still persists.
6. Remember in order to see change cause of historical revisions, we need to add — record flag while editing/applying deployments (needs to be set once per deployment)
7. When we do a rollback, the revision to which the rollback happens is removed from history and a new entry is made in the history instead.
8. If any error occurs during upgrade, kubernetes will proactively stop the upgrade and stop dropping previously running instances

> In Kubernetes, rolling updates are the default strategy to update the running version of our app. So, Kubernetes runs a cluster of nodes, and each node consists of pods. The rolling update cycles the previous Pod out and brings the newer Pod in incrementally.

## Example
This is our Kubernetes deployment file which specifies replica as 3 for `demo-app` and the container image is pointing to AWS ECR.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-app
  labels:
    app: demo-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: demo-app
  template:
    metadata:
      labels:
        app: demo-app
    spec:
      containers:
        - name: image
          image: 73570586743739.dkr.ecr.us-west-2.amazonaws.com/demo-app:v1.0
          imagePullPolicy: Always
          ports:
            - containerPort: 3001
```
Now when we run
`kubectl apply -f <deployment file path>`

This will create the deployment with 3 pods running and we can see the status as running.

`kubectl get pods`

```javascript
   NAME                                READY     STATUS    RESTARTS   AGE
  demo-app-1564180363-khku8            1/1       Running   0          14s
  demo-app-1564180363-nacti            1/1       Running   0          14s
  demo-app-1564180363-z9gth            1/1       Running   0          14s
```

Now, if we need to update the deployment or need to push the new version out, assuming CI has already pushed the new image to ECR, we can just copy and update the image URL.

`kubectl set image deployment.apps/demo-app image=73570586743739.dkr.ecr.us-west-2.amazonaws.com/demo-app:v2.0`

The output is similar to:

```javascript
  >> deployment.apps/demo-app image updated
```

We can also add the description to the update, so we would know what has changed.

`kubectl annotate deployment.apps/demo-app kubernetes.io/change-cause="demo version changed from 1.0 to 2.0"`

We can always check the status of the rolling update.

`kubectl rollout status deployment.apps/demo-app`

#Note 
 >Remember, if we do step `kubectl set ....`, then there will be inconsistency in the actual file and the deployment definition in the cluster, Better to use `kubectl apply -f` for upgrades
 
as another example, to rollback to the third revision of the Deployment, run the following command:

```
kubectl rollout undo deployment <deployment-name> --to-revision 3
```

### Apply vs create
#goodread [kubectl apply vs create](https://www.airplane.dev/blog/kubectl-apply-vs-create)
`apply` - makes incremental changes to an existing object  
`create` - creates a whole new object (previously non-existing / deleted)
# These are **imperative commands** :

`kubectl run` = `kubectl create deployment`

### Advantages:

- Simple, easy to learn and easy to remember.
- Require only a single step to make changes to the cluster.

### Disadvantages:

- Do not integrate with change review processes.
- Do not provide an audit trail associated with changes.
- Do not provide a source of records except for what is live.
- Do not provide a template for creating new objects.

# These are **imperative object config**:

`kubectl create -f your-object-config.yaml`

`kubectl delete -f your-object-config.yaml`

`kubectl replace -f your-object-config.yaml`

### Advantages compared to imperative commands:

- Can be stored in a source control system such as Git.
- Can integrate with processes such as reviewing changes before push and audit trails.
- Provides a template for creating new objects.

### Disadvantages compared to imperative commands:

- Requires basic understanding of the object schema.
- Requires the additional step of writing a YAML file.

### Advantages compared to declarative object config:

- Simpler and easier to understand.
- More mature after Kubernetes version 1.5.

### Disadvantages compared to declarative object configuration:

- Works best on files, not directories.
- Updates to live objects must be reflected in configuration files, or they will be lost during the next replacement.

# These are declarative object config

`kubectl diff -f configs/`

`kubectl apply -f configs/`

### Advantages compared to imperative object config:

- Changes made directly to live objects are retained, even if they are not merged back into the configuration files.
- Better support for operating on directories and automatically detecting operation types (create, patch, delete) per-object.

### Disadvantages compared to imperative object configuration:

- Harder to debug and understand results when they are unexpected.
- Partial updates using diffs create complex merge and patch operations.

**K8s has three resource management methods**

- **Command Based Object Management**: directly use commands to operate kubernetes resources. eg:
    
    `kubectl run nginx-pod --image=nginx:1.17.1 --port=80`
    
- **Command Type Object Configuration**: operate Kubernetes resources through command configuration and configuration files. eg:
    
    `kubectl create/patch -f nginx-pod.yaml`
    
- **Declarative Object Configuration**: operate kubernetes resources through the apply command and configuration file. eg:
    
    `kubectl apply -f nginx-pod.yaml`

### Apply vs replace

`kubectl apply` uses the provided spec to create a resource if it does not exist and update, i.e., patch, it if it does. The spec provided to `apply` need only contain the required parts of a spec, when creating a resource the API will use defaults for the rest and when updating a resource it will use its current values.

The `kubectl replace` completely replaces the existing resource with the one defined by the provided spec. `replace` wants a _complete_ spec as input, including read-only properties supplied by the API like `.metadata.resourceVersion`, `.spec.nodeName` for pods, `.spec.clusterIP` for services, and `.secrets` for service accounts. `kubectl` has some internal tricks to help you get that right, but typically the use case for `replace` is getting a resource spec, changing a property, and then using that changed, complete spec to replace the existing resource.

The `kubectl replace` command has a `--force` option which actually does not use the replace, i.e., `PUT`, API endpoint. It forcibly deletes (`DELETE`) and then recreates, (`POST`) the resource using the provided spec.

If you used `create` to create the resource, then use `replace` to update it. If you used `apply` to create the resource, then use `apply` to update it.

Note that both `replace` and `apply` require a complete spec, and both create the new resources first before deleting the old ones (unless `--force` is specified).

## Application Commands
![[Pasted image 20230912114646.png]]
 If we pass 10 during` docker run`  5 will get replaced with 10
 If we dont pass 10 then 5 will get updated
#Note CMD in docker will get overridden if we pass command from cli
#Note  If we want to over ride entry point then we have to specify it during `docker run`
```sh
docker run --name <container-name> <image-name> --entrypoint sleep2.0 10

docker run --entrypoint [new_command] [docker_image] [optional:value]```
## Configure Applications
![[Pasted image 20230912124708.png]]

## ENV Variables in kubernetes

When you create a Pod, you can set environment variables for the containers that run in the Pod. To set environment variables, include the `env` or `envFrom` field in the configuration file.

The `env` and `envFrom` fields have different effects.

`env`

allows you to set environment variables for a container, specifying a value directly for each variable that you name.

`envFrom`

allows you to set environment variables for a container by referencing either a ConfigMap or a Secret. When you use `envFrom`, all the key-value pairs in the referenced ConfigMap or Secret are set as environment variables for the container. You can also specify a common prefix string.

You can read more about [ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configure-all-key-value-pairs-in-a-configmap-as-container-environment-variables) and [Secret](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#configure-all-key-value-pairs-in-a-secret-as-container-environment-variables).
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: envar-demo
  labels:
    purpose: demonstrate-envars
spec:
  containers:
  - name: envar-demo-container
    image: gcr.io/google-samples/node-hello:1.0
    env:
    - name: DEMO_GREETING
      value: "Hello from the environment"
    - name: DEMO_FAREWELL
      value: "Such a sweet sorrow"

```

List the Pod's container environment variables:
```sh
kubectl exec <container-name> -- printenv
```

### Using environment variables inside of your config[](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/#using-environment-variables-inside-of-your-config)

Environment variables that you define in a Pod's configuration under `.spec.containers[*].env[*]` can be used elsewhere in the configuration, for example in commands and arguments that you set for the Pod's containers. In the example configuration below, the `GREETING`, `HONORIFIC`, and `NAME` environment variables are set to `Warm greetings to`, `The Most Honorable`, and `Kubernetes`, respectively. The environment variable `MESSAGE` combines the set of all these environment variables and then uses it as a CLI argument passed to the `env-print-demo` container.


```yaml
apiVersion: v1
kind: Pod
metadata:
  name: print-greeting
spec:
  containers:
  - name: env-print-demo
    image: bash
    env:
    - name: GREETING
      value: "Warm greetings to"
    - name: HONORIFIC
      value: "The Most Honorable"
    - name: NAME
      value: "Kubernetes"
    - name: MESSAGE
      value: "$(GREETING) $(HONORIFIC) $(NAME)"
    command: ["echo"]
    args: ["$(MESSAGE)"]
```

Upon creation, the command `echo Warm greetings to The Most Honorable Kubernetes` is run on the container.

# Config Maps
## What is a ConfigMap in Kubernetes?

A ConfigMap is a dictionary of configuration settings. This dictionary consists of key-value pairs of strings. Kubernetes provides these values to your containers. Like with other dictionaries (maps, hashes, ...) the key lets you get and set the configuration value.
Use a ConfigMap to keep your application code separate from your configuration.


![[configmap-diagram.gif]]

### 1. Define the ConfigMap in a YAML file.

Create a YAML file setting the key-value pairs for your ConfigMap.

```yaml
kind: ConfigMap 
apiVersion: v1 
metadata:
  name: example-configmap 
data:
  # Configuration values can be set as key-value properties
  database: mongodb
  database_uri: mongodb://localhost:27017
  
  # Or set as complete file contents (even JSON!)
  keys:  
    image.public.key=771 
    rsa.public.key=42
```
### 2. Create the ConfigMap in your Kubernetes cluster

Create the ConfigMap using the command `kubectl apply -f config-map.yaml`

### 3.Add the `envFrom` property to your Pod's YAML

Set the `envFrom` key in each container to an object containing the list of ConfigMaps you want to include.
```yaml
kind: Pod 
apiVersion: v1 
metadata:
  name: pod-env-var 
spec:
  containers:
    - name: env-var-configmap
      image: nginx:1.7.9 
      envFrom:
        - configMapRef:
            name: example-configmap
```


### 3.a Mount the ConfigMap through a Volume

Each property name in this ConfigMap becomes a new file in the mounted directory (`/etc/config`) after you mount it. This is other way to create config map
```yaml
apiVersion: v1 
metadata:
  name: pod-using-configmap 

spec:
  # Add the ConfigMap as a volume to the Pod
  volumes:
    # `name` here must match the name
    # specified in the volume mount
    - name: example-configmap-volume
      # Populate the volume with config map data
      configMap:
        # `name` here must match the name 
        # specified in the ConfigMap's YAML 
        name: example-configmap

  containers:
    - name: container-configmap
      image: nginx:1.7.9
      # Mount the volume that contains the configuration data 
      # into your container filesystem
      volumeMounts:
        # `name` here must match the name
        # from the volumes section of this pod
        - name: example-configmap-volume
            mountPath: /etc/config
```


## What are the other ways to create and use ConfigMaps?

There are three other ways to create ConfigMaps using the `kubectl create configmap` command. I prefer the methods used above, but here are your options.

1. Use the contents of an entire directory with `kubectl create configmap my-config --from-file=./my/dir/path/`
2. Use the contents of a file or specific set of files with `kubectl create configmap my-config --from-file=./my/file.txt`
3. Use literal key-value pairs defined on the command line with `kubectl create configmap my-config --from-literal=key1=value1 --from-literal=key2=value2`

You can get more information about this command using `kubectl create configmap --help`.

Read config maps
```sh
kubectl get configmap
kubectl describe cm <configmap-name>
```
## Immutable ConfigMaps[](https://kubernetes.io/docs/concepts/configuration/configmap/#configmap-immutable)

**FEATURE STATE:** `Kubernetes v1.21 [stable]`

The Kubernetes feature _Immutable Secrets and ConfigMaps_ provides an option to set individual Secrets and ConfigMaps as immutable. For clusters that extensively use ConfigMaps (at least tens of thousands of unique ConfigMap to Pod mounts), preventing changes to their data has the following advantages:

- protects you from accidental (or unwanted) updates that could cause applications outages
- improves performance of your cluster by significantly reducing load on kube-apiserver, by closing watches for ConfigMaps marked as immutable.

You can create an immutable ConfigMap by setting the `immutable` field to `true`. For example:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  ...
data:
  ...
immutable: true
```
![[Pasted image 20230912180459.png]]

# kubernetes Secrets
The Kubernetes API provides various built-in secret types for a variety of use cases found in the wild. When you create a secret, you can declare its type by leveraging the `type` field of the Secret resource, or an equivalent `kubectl` command line flag. The Secret type is used for programmatic interaction with the Secret data.

## Types of Kubernetes Secrets[](https://spacelift.io/blog/kubernetes-secrets#types-of-kubernetes-secrets)

The following are several types of Kubernetes Secrets:
- **Opaque Secrets**: Opaque Secrets are used to store arbitrary user-defined data. Opaque is the default Secret type, meaning that when creating a Secret and you don’t specify any type, the secret will be considered Opaque.
- **Service account token Secrets**: You use a Service account token Secret to store a token credential that identifies a [service account](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/). It is important to note that when using this Secret type, you must ensure that the kubernetes.io/service-account.name annotation is set to an existing service account name.
-  **Docker config Secrets**: You use a Docker config secret to store the credentials for accessing a container image registry. You use Docker config secret with one of the following type values:
    - kubernetes.io/dockercfg 
    - kubernetes.io/dockerconfigjson
- **Basic authentication Secret**: You use this Secret type to store credentials needed for basic authentication.  When using a basic authentication Secret, the data field must contain at least one of the following keys:
    - username: the user name for authentication
    - password: the password or token for authentication
- **faskjhfa** fafhahjfla
-  **SSH authentication secrets**: You use this Secret type to store data used in SSH authentication. When using an SSH authentication, you must specify a ssh-privatekey key-value pair in the data (or stringData) field as the SSH credential to use.
- **TLS secrets**: You use this Secret type to store a certificate and its associated key typically used for TLS. When using a TLS secret, you must provide the tls.key and the tls.crt key in the configuration’s data (or stringData) field. 
- **Bootstrap token Secrets**: You use this Secret type to store bootstrap token data during the node bootstrap process. You typically create a bootstrap token Secret in the kube-system namespace and named it in the form bootstrap-token-\<token-id\>

## Ways to Create Kubernetes Secrets[](https://spacelift.io/blog/kubernetes-secrets#ways-to-create-kubernetes-secrets)

To create Kubernetes Secrets, you can use one of the following methods:

- [Create Kubernetes Secrets using kubectl.](https://spacelift.io/blog/kubernetes-secrets#creating-kubernetes-secrets-using-kubectl)
- [Create Kubernetes Secrets using a manifest file.](https://spacelift.io/blog/kubernetes-secrets#creating-secrets-using-a-manifest-file)
- [Create Kubernetes Secrets using a generator like Kustomize.](https://spacelift.io/blog/kubernetes-secrets#creating-secrets-using-a-generator-like-kustomize)


## Creating Kubernetes Secrets Using kubectl[](https://spacelift.io/blog/kubernetes-secrets#creating-kubernetes-secrets-using-kubectl)

There are two ways of providing the Secret data to kubectl when creating Secrets using Kubectl, and there are:

- Providing the secret data through a file using the `--from-file=<filename>` tag or
- Providing the literal secret data using the `--from-literal=<key>=<value>` tag

This article will use the file method.

It is important to note that when providing the secret data `--from-literal=<key>=<value>` tag, special characters such as $, \, *, =, and ! require escaping. However, you can easily escape in most shells with single quotes (‘).

To start creating a Secret with kubectl providing the Secret data from a file in any directory of your choice. Create files to store the hypothetical user credentials with the following command:

```bash
$ echo -n 'admin' > username.txt
$ echo -n 'password' > password.txt
```

The `-n` flag in the above command ensures that no newline character is added at the end of the text. This is crucial since kubectl will encode the extra newline character if present when it reads the file and turns the content into a base64 string.
Now, create the Kubernetes Secret with the files using the kubectl command below:
```bash
$ kubectl create secret generic database-credentials \  
    --from-file=username.txt \ 
    --from-file=password.txt \
    --namespace=secrets-demo
```
The generic subcommand tells kubectl to create the Secret with Opaque type.

**Note**: When using the above command, the key of your secret data will be the filename (`username.txt` and `password.txt`) by default.  To provide keys for the Secret data, use the following syntax `--from-file=[key=]source`, for example:

```bash
kubectl create secret generic database-credentials \
--from-file=username=username.txt \
--from-file=password=password.txt \
--namespace=secrets-demo
```
To verify the Secret creation, run the following command:

```bash
$ kubectl -n secrets-demo get secrets
```
## Creating Secrets Using a Manifest File[](https://spacelift.io/blog/kubernetes-secrets#creating-secrets-using-a-manifest-file)

Before you create a Secret using a manifest file, you must first decide how you want to add the Secret data using the data field and/or the stringData field.

Using the data field, you must encode the secret data using base64.  To convert the username and password to base64, run the following command:

```bash
echo -n 'admin' | base64
echo -n 'password' | base64
```
After running the above command, you will get an output similar to the image below. Copy the base64 values and store them as that is what you will put in your manifest file.

![kubernetes secrets base64](https://spacelift.io/_next/image?url=https%3A%2F%2Fspaceliftio.wpcomstaging.com%2Fwp-content%2Fuploads%2F2022%2F10%2Fkubernetes-secrets-base64.png&w=3840&q=75)

Now create a demo-secret.yaml manifest file using any means you prefer (text editor, vim or nano, etc.) and add the following configuration.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: demo-secret
type: Opaque
data:
  username: YWRtaW4=
  password: cGFzc3dvcmQ=
```
In the above manifest file, the username and password values in the data field are the base64 encoded values of the original credentials. 

When using the stringData field, the manifest file will be:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: demo-secret
type: Opaque
stringData:
  username: admin
  password: password
```
To create the Secret, run the following command:

```bash
$ kubectl -n secrets-demo apply -f demo-secret.yaml
```

## Creating Secrets Using a Generator Like Kustomize[](https://spacelift.io/blog/kubernetes-secrets#creating-secrets-using-a-generator-like-kustomize)

Using a resource Generator like [Kustomize](https://kustomize.io/) can help you create Kubernetes Secrets quickly.

Check out [Kustomize vs. Helm comparison](https://spacelift.io/blog/kustomize-vs-helm).

To create a Secret using Kustomize, first create a kustomization.yaml file. In that file, define a secretGenerator to reference one of the following:

- Files that store the secret data,
- The unencrypted literal version of the secret data values,
- Environment variable (.env) files.

You don’t need to base64 encode the values with all these methods.

When referencing Secret data files, you define the secretGenerator like:

```bash
secretGenerator:
- name: database-credentials
  files:
  - username.txt
  - password.txt
```

When using the literal version of the data values, you define the secretGenerator like:

```bash
secretGenerator:
- name: database-credentials
  literals:
  - username=admin
  - password=password
```

When using .env files, you define the secretGenerator like:

```bash
secretGenerator:
- name: database-credentials
  envs:
  - .env.secret
```

Create the kustomization.yaml file, and paste either of the first two options.

Then in the same directory as the file, generate the Secret with the following kubectl command:

```bash
$ kubectl -n secrets-demo apply -k .
```

After running the above command, you should see an output similar to the image below.

![create kubernetes secrets with kustomize](https://spacelift.io/_next/image?url=https%3A%2F%2Fspaceliftio.wpcomstaging.com%2Fwp-content%2Fuploads%2F2022%2F10%2Fcreate-kubernetes-secrets-with-kustomize.png&w=3840&q=75)

So far, you’ve learned what Kubernetes secrets are, its built-in types, and the methods you can use to create them. Next, you will learn how to describe a Secret, decode a Secret, edit Secret values, and finally, how to use a Secret in Pods.

## Describing a Kubernetes Secret Using kubectl describe[](https://spacelift.io/blog/kubernetes-secrets#describing-a-kubernetes-secret-using-kubectl-describe)

Using the kubectl describe, you can view some basic information about Kubernetes objects. To use it to view the description of one of the Secrets you’ve created in the article, run:

```bash
$ kubectl -n secrets-demo describe secrets/database-credentials
```

After running the above command, you will get an output similar to the image below.

![kubernetes secret kubectl describe](https://spacelift.io/_next/image?url=https%3A%2F%2Fspaceliftio.wpcomstaging.com%2Fwp-content%2Fuploads%2F2022%2F10%2Fkubernetes-secret-kubectl-describe.png&w=3840&q=75)

If you notice, the above output doesn’t show the contents of the Secret. This is to protect the Secret from being exposed or logged in the terminal. 

To view the Secret data, you will need to decode the secret.

## Decoding a Kubernetes Secret[](https://spacelift.io/blog/kubernetes-secrets#decoding-a-kubernetes-secret)

To view the data of the Secret you created, run the following command:

```bash
$ kubectl -n secrets-demo get secret database-credentials -o jsonpath='{.data}'
```

After running the above commands, it will output the encoded key-value pairs of the secret data as in the image below. 

![kubernetes secrets encoded key-value pairs](https://spacelift.io/_next/image?url=https%3A%2F%2Fspaceliftio.wpcomstaging.com%2Fwp-content%2Fuploads%2F2022%2F10%2Fkubernetes-secrets-encoded-key-value-pairs.png&w=3840&q=75)

To decode the encoded strings, you can use the following command:

To decode the encoded strings, you can use the following command:

```bash
$ echo 'YWRtaW4=' | base64 --decode
$ echo 'cGFzc3dvcmQ=' | base64 --decode
```

**Note**: If you do the above, you could store the Secret data in your shell history. To avoid that, combine the previous two steps into one command like the one below.

```bash
$ kubectl get secret database-credentials -o jsonpath='{.data.password}' | base64 --decode
```

## Editing a Kubernetes Secret[](https://spacelift.io/blog/kubernetes-secrets#editing-a-kubernetes-secret)

To edit the content of the Secret you created, run the following kubectl command:

```bash
$ kubectl -n secrets-demo edit secrets database-credentials
```

The above command will open your terminal’s default editor to allow you to update the base64 encoded Secret data in the data field 
**Note:** It is important to note that when you set a Secret as immutable upon creation, you can’t edit it. Nonetheless, you can edit any existing mutable Secret to make it immutable by adding immutable: true in the manifest file 

## How to Use Kubernetes Secrets[](https://spacelift.io/blog/kubernetes-secrets#how-to-use-kubernetes-secrets)

The following are the three main ways a Pod can use a Secret:

- As container environment variables 
- As files in a [volume](https://kubernetes.io/docs/concepts/storage/volumes/) mounted on one or more of its containers.
- By the kubelet when pulling images for the Pod — imagePullSecrets.

### Using Secret data as container environment variables

For demo purposes, below is a Pod manifest with the Kubernetes Secret data you created exposed as environment variables. Create a secret-test-env-pod.yaml and paste the configuration in it.

```bash
apiVersion: v1
kind: Pod
metadata:
  name: env-pod
spec:
  containers:
    - name: secret-test
      image: nginx
      command: ['sh', '-c', 'echo "Username: $USER" "Password: $PASSWORD"']
      env:
        - name: USER
          valueFrom:
            secretKeyRef:
              name: database-credentials
              key: username.txt
        - name: PASSWORD
          valueFrom:
            secretKeyRef:
              name: database-credentials
              key: password.txt
```

```bash
$ kubectl -n secrets-demo apply -f secret-test-evn-pod.yaml
```

To verify that Kubernetes mounted the Secret on the Pod, describe the Pod with the following command:

```bash
# "env-pod" is the Pod name as in the above manifest file
$ kubectl -n secrets-demo describe pod env-pod
```
Also, seeing the echo command in the Pod manifest file, you can verify by checking the [logs of the Pod](https://spacelift.io/blog/kubectl-logs) with:

```bash
$ kubectl -n secrets-demo logs env-pod
```

### Using Secret data as files in a volume mounted on a Pod’s container(s)

For demo purposes, below is a Pod manifest with the Kubernetes Secret data you created as files in a volume mounted on the Pod’s containers. 

Create a secret-test-volume-pod.yaml and paste the configuration in it.

```bash
apiVersion: v1
kind: Pod
metadata: 
  name: volume-test-pod
spec:
  containers:
  - name: secret-test
    image: nginx
    volumeMounts:
    - name: secret-volume
      mountPath: /etc/config/secret
  volumes:
  - name: secret-volume
    secret:
      secretName: database-credentials
```

Create the Pod using the following kubectl command:

```bash
$ kubectl -n secrets-demo apply -f secret-test-volume-pod.yaml
```

To verify that the Pod can access the Secret data, connect to the container and run the following commands in the volume directory:

```bash
$ kubectl -n secrets-demo exec volume-test-pod -- cat /etc/config/secret/username.txt

$ kubectl -n secrets-demo exec volume-test-pod -- cat /etc/config/secret/password.txt

$ kubectl -n secrets-demo exec volume-test-pod -- ls /etc/config/secret
```
### kubelet using Secret data when pulling images for a Pod

You use this way when you want to fetch container images from a private repository. These secrets are configured at the Pod level.

To use this method, you configure the Secret data in the imagePullSecrets field of your Pod manifest file. The kubelet on each node will authenticate to that repository. 

```bash
apiVersion: v1
kind: Pod
metadata:
  ...
spec:
  containers:
    ...
  imagePullSecrets:
    - name: <your-registry-key>
```

## Best Practices to Follow When Using Kubernetes Secrets[](https://spacelift.io/blog/kubernetes-secrets#best-practices-to-follow-when-using-kubernetes-secrets)

By default, Kubernetes stores Secrets unencrypted in the etcd data store. To safely use Kubernetes Secrets, take at least the following steps:

1. [Enable Encryption at Rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/) for Secrets.
2. Set least-privilege access to Secrets as the default setting with [RBAC rules](https://kubernetes.io/docs/reference/access-authn-authz/authorization/).
3. Only allow certain containers to have access to a certain Secret.
4. Use [third-party Secret store providers](https://secrets-store-csi-driver.sigs.k8s.io/concepts.html#provider-for-the-secrets-store-csi-driver), if possible.

For more guidelines on how to safely use Secrets, read the following documentation:

- [Good practices for Kubernetes Secrets](https://kubernetes.io/docs/concepts/security/secrets-good-practices/) 
- [Information security for Secrets](https://kubernetes.io/docs/concepts/configuration/secret/#information-security-for-secrets)

#Note on sectets
- Secrets are not encrypted. Only encoded.
- Secrets are not encrypted in ETCD
- Anyone able to create pods/deployments in the same namespace can access the secrets
- A secret is only sent to a node if a pod on that node requires it.
- Kubelet stores the secret into a tmpfs so that the secret is not written to disk storage.
- Once the Pod that depends on the secret is deleted, kubelet will delete its local copy of the secret data as well.
Having said that, there are other better ways of handling sensitive data like passwords in Kubernetes, such as using tools like Helm Secrets, [HashiCorp Vault](https://www.vaultproject.io/).


## Encrypting Confidential Data at Rest
-  https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/
 - Also refer cka udemy course : [Lec-108](https://rakuten.udemy.com/course/certified-kubernetes-administrator-with-practice-tests/learn/lecture/34549248#overview)

# Multicontainer Pods

## [Use Cases for Multi-Container Pods](https://linchpiner.github.io/k8s-multi-container-pods.html#_use_cases_for_multi_container_pods)

The primary purpose of a multi-container Pod is to support co-located, co-managed helper processes for a main program. There are some general patterns of using helper processes in Pods:

**Sidecar containers** "help" the main container. For example, log or data change watchers, monitoring adapters, and so on. A log watcher, for example, can be built once by a different team and reused across different applications. Another example of a sidecar container is a file or data loader that generates data for the main container.

## [Communication Between Containers in a Pod](https://linchpiner.github.io/k8s-multi-container-pods.html#_communication_between_containers_in_a_pod)

### [Shared volumes](https://linchpiner.github.io/k8s-multi-container-pods.html#_shared_volumes)

In Kubernetes, you can use a shared Kubernetes Volume as a simple and efficient way to share data between containers in a Pod. For most cases, it is sufficient to use a directory on the host that is shared with all containers within a Pod. Kubernetes Volumes enables data to survive container restarts. It has the same lifetime as a Pod. That means that it exists as long as that Pod exists. If that Pod is deleted for any reason, even if an identical replacement is created, the shared Volume is also destroyed and created anew.

A standard use case for a multi-container Pod with shared Volume is when one container writes to the shared directory (logs or other files), and the other container reads from the shared directory. Example:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mc1
spec:
  volumes:
    - name: html
      emptyDir: {}
  containers:
    - name: 1st
      image: nginx
      volumeMounts:
        - name: html
          mountPath: /usr/share/nginx/html
    - name: 2nd
      image: debian
      volumeMounts:
        - name: html
          mountPath: /html
      command: ["/bin/sh", "-c"]
      args:
        - while true; do
          date >> /html/index.html;
          sleep 1;
          done
```
In this example, we define a volume named `html` and its type is `emptyDir`: volume that is first created when a Pod is assigned to a node, and exists as long as that Pod is running on that node. As the name says, it is initially empty. The first container runs nginx server and has the shared volume mounted to the directory `/usr/share/nginx/html`. The second container uses Debian image and has the shared volume mounted to the directory `/html`. The second container every second adds current date and time and into `index.html` that is located in the shared volume. Nginx servers reads this file and transfers it to the user for each HTTP request to the web server.
![[Pasted image 20230912201559.png]]
You can check that the pod is working either exposing nginx port and accessing it using your browser. Another way to check the shared directory directly in containers:
```bash
$ kubectl exec mc1 -c 1st -- /bin/cat /usr/share/nginx/html/index.html
...
Fri Aug 25 18:36:06 UTC 2017

$ kubectl exec mc1 -c 2nd -- /bin/cat /html/index.html
...
Fri Aug 25 18:36:06 UTC 2017
Fri Aug 25 18:36:07 UTC 2017
```
### [Inter-process communications (IPC)](https://linchpiner.github.io/k8s-multi-container-pods.html#_inter_process_communications_ipc)

Containers in a Pod share the same IPC namespace and they can also communicate with each other using standard inter-process communications like SystemV semaphores or POSIX shared memory.

In the following example, we define a Pod with two containers. We use the same Docker image for both, see [https://github.com/allingeek/ch6_ipc](https://github.com/allingeek/ch6_ipc). The first container (producer) creates a standard Linux message queue, writes a number of random messages and then writes a special exit message. The second container (consumer) opens the same message queue for reading and reads messages until it receives the exit message. We also set restart policy to 'Never', so the Pod stops after termination of both containers.

```
apiVersion: v1
kind: Pod
metadata:
  name: mc2
spec:
  containers:
  - name: 1st
    image: allingeek/ch6_ipc
    command: ["./ipc", "-producer"]
  - name: 2nd
    image: allingeek/ch6_ipc
    command: ["./ipc", "-consumer"]
  restartPolicy: Never
```
Create the pod using `kubectl create` and watch the Pod status:

```bash
$ kubectl get pods --show-all -w
NAME      READY     STATUS              RESTARTS  AGE
mc2       0/2       Pending             0         0s
mc2       0/2       ContainerCreating   0         0s
mc2       0/2       Completed           0         29s
```

Now you can check logs for each container and verify that the 2nd container received all messages from the 1st container, including the exit message:
```bash
$ kubectl logs mc2 -c 1st
...
Produced: f4
Produced: 1d
Produced: 9e
Produced: 27

$ kubectl logs mc2 -c 2nd
...
Consumed: f4
Consumed: 1d
Consumed: 9e
Consumed: 27
Consumed: done
```

![[Pasted image 20230912201921.png]]
!!!Note: there is one major problem with this Pod. Can you see it? Check "Additional Details about Multi-Containers Pods" for the explanation.

### [Network](https://linchpiner.github.io/k8s-multi-container-pods.html#_network)

Containers in a Pod are accessible via "localhost", they use the same network namespace. For containers, the observable host name is a Pod’s name. Since containers share the same IP address and port space, you should use different ports in containers for incoming connections. Because of this, applications in a Pod must coordinate their usage of ports.

In the following example, we will create a multi-container Pod, where nginx in one container works as a reverse proxy for a simple web application running in the second container.

![[Pasted image 20230912202016.png]]

**Step 1.** Create a ConfigMap with nginx configuration file. Incoming HTTP requests to the port 80 will be forwarded to the port 5000 on localhost:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: mc3-nginx-conf
data:
  nginx.conf: |-
    user  nginx;
    worker_processes  1;

    error_log  /var/log/nginx/error.log warn;
    pid        /var/run/nginx.pid;

    events {
        worker_connections  1024;
    }

    http {
        include       /etc/nginx/mime.types;
        default_type  application/octet-stream;

        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for"';

        access_log  /var/log/nginx/access.log  main;

        sendfile        on;
        keepalive_timeout  65;

        upstream webapp {
            server 127.0.0.1:5000;
        }

        server {
            listen 80;

            location / {
                proxy_pass         http://webapp;
                proxy_redirect     off;
            }
        }
    }
```
**Step 2.** Create a multi-container Pod with simple web app and nginx in separate containers. Note that for the Pod, we define only nginx port 80. Port 5000 will not be accessible outside of the Pod.

```
apiVersion: v1
kind: Pod
metadata:
  name: mc3
  labels:
    app: mc3
spec:
  containers:
  - name: webapp
    image: training/webapp
  - name: nginx
    image: nginx:alpine
    ports:
    - containerPort: 80
    volumeMounts:
    - name: nginx-proxy-config
      mountPath: /etc/nginx/nginx.conf
      subPath: nginx.conf
  volumes:
  - name: nginx-proxy-config
    configMap:
      name: mc3-nginx-conf
```

**Step 3**. Expose the Pod using the `NodePort` service:

```bash
$ kubectl expose pod mc3 --type=NodePort --port=80
service "mc3" exposed
```
**Step 4.** Identify port on the node that is forwarded to the Pod:

```bash
$ kubectl describe service mc3
...
NodePort:		<unset>	31418/TCP
...
```

Now you can use your browser (or `curl`) to navigate to your node’s port to access the web application through reverse proxy.
## [Additional Details about Multi-Containers Pods](https://linchpiner.github.io/k8s-multi-container-pods.html#_additional_details_about_multi_containers_pods)

**How to expose different containers in a Pod?**

It’s quite common case when several containers in a Pod listen on different ports and you need to expose all this ports. You can use two services or one service with two exposed ports.

**In what order containers are being started in a Pod?**

Currently, all containers in a Pod are being started in parallel and there is no way to define that one container must be started after other container (however, there are [Kubernetes Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)). Therefore, in your IPC example there is a chance that the second container starts before the first one. In this case, the second container will fail, because in the `consumer` mode it expects that the message queue exists. To fix this issue we, for example, can change the application to wait for the message queue to be created.

# InitContainers

In a multi-container pod, each container is expected to run a process that stays alive as long as the POD's lifecycle. For example in the multi-container pod that we talked about earlier that has a web application and logging agent, both the containers are expected to stay alive at all times. The process running in the log agent container is expected to stay alive as long as the web application is running. If any of them fails, the POD restarts.

  

But at times you may want to run a process that runs to completion in a container. For example a process that pulls a code or binary from a repository that will be used by the main web application. That is a task that will be run only  one time when the pod is first created. Or a process that waits  for an external service or database to be up before the actual application starts. That's where **initContainers** comes in.

  

An **initContainer** is configured in a pod like all other containers, except that it is specified inside a `initContainers` section,  like this:
```yaml
1. apiVersion: v1
2. kind: Pod
3. metadata:
4.   name: myapp-pod
5.   labels:
6.     app: myapp
7. spec:
8.   containers:
9.   - name: myapp-container
10.     image: busybox:1.28
11.     command: ['sh', '-c', 'echo The app is running! && sleep 3600']
12.   initContainers:
13.   - name: init-myservice
14.     image: busybox
15.     command: ['sh', '-c', 'git clone <some-repository-that-will-be-used-by-application> ; done;']
```
When a POD is first created the initContainer is run, and the process in the initContainer must run to a completion before the real container hosting the application starts. 

You can configure multiple such initContainers as well, like how we did for multi-containers pod. In that case each init container is run **one at a time in sequential order**.

If any of the initContainers fail to complete, Kubernetes restarts the Pod repeatedly until the Init Container succeeds.

```yaml
1. apiVersion: v1
2. kind: Pod
3. metadata:
4. name: myapp-pod
5. labels:
6. app: myapp
7. spec:
8. containers:
9. - name: myapp-container
10. image: busybox:1.28
11. command: ['sh', '-c', 'echo The app is running! && sleep 3600']
12. initContainers:
13. - name: init-myservice
14. image: busybox:1.28
15. command: ['sh', '-c', 'until nslookup myservice; do echo waiting for myservice; sleep 2; done;']
16. - name: init-mydb
17. image: busybox:1.28
18. command: ['sh', '-c', 'until nslookup mydb; do echo waiting for mydb; sleep 2; done;']
```

#Note  Init containers are not shown when we execute `kubectl get pods`
# Self Healing Applications

Kubernetes supports self-healing applications through ReplicaSets and Replication Controllers. The replication controller helps in ensuring that a POD is re-created automatically when the application within the POD crashes. It helps in ensuring enough replicas of the application are running at all times.

Kubernetes provides additional support to check the health of applications running within PODs and take necessary actions through Liveness and Readiness Probes.