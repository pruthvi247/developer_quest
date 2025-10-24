The `Kubernetes API server` is the main point of entry to a cluster for external parties (users and services) interacting with it.

------------- SOB -----------------------
[source](https://www.cloudthat.com/resources/blog/detailed-overview-of-kubernetes-security-primitives)

Due to the dispersed, dynamic nature of a Kubernetes cluster, Kubernetes security is crucial throughout the container’s lifetime. For each of the three stages of an application’s lifecycle—build, deploy, and runtime—different security strategies are needed. Kubernetes has built-in benefits for security.

Attackers who get unauthorized access to the kubelet have access to the APIs, which puts node or cluster security at risk.

### Action needed to prevent the Kubernetes Cluster's Security Breach

1. Limiting who has access to the Kubernetes API.
2. Regulating kubelet access
3. Adjusting a workload’s or user’s capabilities in real-time
4. Preventing breaches of cluster components

#### 1: Limiting who has access to the Kubernetes API

1. **For all API communication, use Transport Layer Security (TLS)**
2. **Authentication using API**
3. **Authorization for API**
##### 1. For all API communication, use Transport Layer Security (TLS)

- Most installation techniques will enable the creation of the required certificates and their distribution to the cluster components.
- Kubernetes expects that all API communication in the cluster is encrypted by default with TLS.
- Administrators should become familiar with each component’s settings to spot potentially insecure communications.
- due to the possibility of some components and installation processes enabling local ports through HTTP.

##### 2. Authentication using API

- When installing a cluster, pick an authentication method that corresponds to the usual access patterns for the API servers.
- Even clients that are a part of the infrastructure, such as nodes, proxies, the scheduler, and volume plugins, all API clients require authentication.
- These clients are normally service accounts or employ x509 client certificates, and they are either set up as part of the cluster installation or established automatically during cluster starts.
##### 3. Authorization for API

- Each API call must successfully pass an authorization check after it has been authenticated.
- A built-in Role-Based Access Control (RBAC) component that comes with Kubernetes matches an incoming user or group to a set of permissions contained in roles.
- It is advised that you combine the NodeRestriction admission plugin with the Node and RBAC authorizers.
- For smaller clusters, basic and broad roles could be appropriate.
- however, when more users engage with the cluster it might be required to divide teams into separate namespaces with more restrictive roles.
- more restricted responsibilities need to be carefully examined to avoid unintentional escalation. If the roles that come out of the box don’t work for your use case, you can create your own.

#### 2: Regulating kubelet access

- Kubelets expose HTTPS endpoints that give nodes and containers powerful control. Kubelets by default permit unauthorized access to this API.
- Production clusters must have authentication and permission for Kubelet enabled.
#### 3: Adjusting a Workload's or user's Capabilities in Real-Time
There are stronger restrictions available as rules to restrict how those objects interact with the cluster, themselves, and other resources according to use case
##### 1. Limiting resource usage on a cluster
- The quantity or capacity of resources allotted to a namespace is constrained by a resource quota.
- It is most frequently used to restrict the amount of CPU, RAM, or persistent disc that a namespace can allocate.
- To prevent users from demanding unreasonably high or low values for often reserved resources like RAM, limit ranges restrict the maximum or minimum size of certain of the aforementioned resources. They also serve as default limits when no limits are defined.

##### 2. Controlling what privileges containers run with

- You can set up Pod security admission to enforce a specific Pod Security Standard inside a namespace or to monitor for violations.

##### 3. Preventing containers from loading unwanted kernel

- When a piece of hardware is connected or a filesystem is mounted, the Linux kernel automatically loads kernel modules from the disc if they are required. Even unprivileged processes can make some kernel modules related to network protocols load simply by creating a socket of the right type, which is especially relevant to Kubernetes. As a result, a security flaw in a kernel module that the administrator believed to be inactive may be exploited by an attacker.
- You can remove certain modules from the node or create rules to prevent them from loading automatically.

##### 4. Restricting network access

- Using a namespace’s network policies, application writers can limit which pods from other namespaces are allowed to access ports and pods inside of their namespace.

##### 5. Restricting cloud metadata API access

- Limit the rights granted to instance credentials when operating Kubernetes on a cloud platform, utilize network policies to limit pod access to the metadata API, and stay away from utilizing provisioning data to send secrets.
##### 6. Controlling which nodes pods may access

- There are no limitations on which nodes can run a pod by default.
- End users have access to a wide range of rules that Kubernetes provides to regulate the deployment of pods into nodes as well as taint-based pod placement and eviction.
- As an administrator, a beta admission plugin Pod NodeSelector can be used to force pods within a namespace to default or require a specific node selector, and if end users cannot alter namespaces, this can strongly limit the placement of all of the pods in a specific workload
#### Preventing Breaches of Cluster Components

##### 1. Restrict access to etcd

- The etcd servers should always be isolated behind a firewall that only the API servers may access, and administrators should always utilize strong credentials from the API servers to their etcd server, such as mutual auth using TLS client certificates.
##### 2. Enable audit logging

- An experimental feature is known as the audit logger logs API actions for later review in the case of a hack. Enabling audit logging and storing the audit file on a secure server are both advised.
##### 3. Restrict access to alpha or beta features

- Beta and alpha Kubernetes features are still under development and could include flaws or restrictions that lead to security concerns. Always weigh the potential benefits of an alpha or beta feature against any security risks. Disable features you don’t utilize when in doubt.
##### 4.Rotate infrastructure credentials frequently

- It becomes more difficult for an attacker to use a secret or credential the shorter its lifespan. Automate the rotation of certificates and give them a short lifespan.
- Employ a source of authentication that can regulate the duration of issued tokens, and whenever possible, use short lifetimes. Consider rotating service-account tokens often if you utilize them in external integrations.
- A bootstrap token used to create nodes should have its permission removed once the bootstrap phase is finished.
##### 5.Review third-party integrations before enabling them

- Numerous third-party Kubernetes integrations could change the cluster’s security profile. Always check the permissions that an extension seeks before providing it access when enabling an integration.
- For example, many security integrations may request access to view all secrets on your cluster which is effectively making that component a cluster admin. When in doubt, restrict the integration to functioning in a single namespace if possible.
##### 6. Encrypt secrets at rest

- Any information accessed through the Kubernetes API will often be stored in the etcd database, which might give an attacker extensive insight into the state of your cluster.
- Always use a reputable backup and encryption solution to encrypt your backups, and whenever it’s practical, think about employing whole disc encryption.
------------- EOB -----------------------

# Authentication

[Kubernetes authentication](https://kubernetes.io/docs/reference/access-authn-authz/authentication) means validating the identity of who or what is sending a request to the Kubernetes server. A request can originate from a pod, within a cluster, or from a human user. Kubernetes authentication is needed to secure an application by validating the identity of a user.


All Kubernetes clusters have two categories of users: 
- service accounts managed by Kubernetes
- and normal users.

1. **Kubernetes managed users**: user accounts created by the Kubernetes cluster itself and usually **used by in-cluster apps** (i.e. workload identities).
2. **Non-Kubernetes managed users**: users that are external to the Kubernetes cluster, such as users authenticated through **external identity providers** like Keystone, Google account, and LDAP.
![[Pasted image 20230915222122.png]]
**The API server is the first component in the control plane to receive that request.**

The API server parses the requests and stores the object in etcd.

Article on Setting up Basic Authentication

#### Setup basic authentication on Kubernetes (Deprecated in 1.19)

> Note: This is not recommended in a production environment. This is only for learning purposes. Also note that this approach is deprecated in Kubernetes version 1.19 and is no longer available in later releases

Follow the below instructions to configure basic authentication in a kubeadm setup.
Create a file with user details locally at `/tmp/users/user-details.csv`

```
1. # User File Contents
2. password123,user1,u0001
3. password123,user2,u0002
4. password123,user3,u0003
5. password123,user4,u0004
6. password123,user5,u0005
```

  

Edit the kube-apiserver static pod configured by kubeadm to pass in the user details. The file is located at `/etc/kubernetes/manifests/kube-apiserver.yaml`

  ```yaml
1. apiVersion: v1
2. kind: Pod
3. metadata:
4. name: kube-apiserver
5. namespace: kube-system
6. spec:
7. containers:
8. - command:
9. - kube-apiserver
10. <content-hidden>
11. image: k8s.gcr.io/kube-apiserver-amd64:v1.11.3
12. name: kube-apiserver
13. volumeMounts:
14. - mountPath: /tmp/users
15. name: usr-details
16. readOnly: true
17. volumes:
18. - hostPath:
19. path: /tmp/users
20. type: DirectoryOrCreate
21. name: usr-details
```

Modify the kube-apiserver startup options to include the basic-auth file
```yaml
1. apiVersion: v1
2. kind: Pod
3. metadata:
4. creationTimestamp: null
5. name: kube-apiserver
6. namespace: kube-system
7. spec:
8. containers:
9. - command:
10. - kube-apiserver
11. - --authorization-mode=Node,RBAC
12. <content-hidden>
13. - --basic-auth-file=/tmp/users/user-details.csv
```

Create the necessary roles and role bindings for these users:

```yaml
1. ---
2. kind: Role
3. apiVersion: rbac.authorization.k8s.io/v1
4. metadata:
5. namespace: default
6. name: pod-reader
7. rules:
8. - apiGroups: [""] # "" indicates the core API group
9. resources: ["pods"]
10. verbs: ["get", "watch", "list"]

12. ---
13. # This role binding allows "jane" to read pods in the "default" namespace.
14. kind: RoleBinding
15. apiVersion: rbac.authorization.k8s.io/v1
16. metadata:
17. name: read-pods
18. namespace: default
19. subjects:
20. - kind: User
21. name: user1 # Name is case sensitive
22. apiGroup: rbac.authorization.k8s.io
23. roleRef:
24. kind: Role #this must be Role or ClusterRole
25. name: pod-reader # this must match the name of the Role or ClusterRole you wish to bind to
26. apiGroup: rbac.authorization.k8s.io
```
Once created, you may authenticate into the kube-api server using the users credentials

`curl -v -k https://localhost:6443/api/v1/pods -u "user1:password123"`

!!!Note : Service Accounts are not part of CKA curriculum, instead, they are part of CKAD. So the video and labs on Service Accounts are available in the CKAD course.

# TLS Intro

Udemylesson:  [certificate Basics](https://rakuten.udemy.com/course/certified-kubernetes-administrator-with-practice-tests/learn/lecture/14296090#overview)


**Server certificate**: Alice is another room. You can't see her. She passed you a note but how do you know it really came from her or is Eve trying to trick you? The note has a special signature that says "Ted certifies this note came from Alice: AJ 23 74 H1 D3" You use the secret decoder ring you use to talk to Ted to check the secret code in this signature, and if it matches "ALICE" then you are assured the note really came from Alice.
Certificate Authorities (the people who give out SSL certificates) have all their decrypt keys in a database, this means you know they were the ones who made the certificate for a website. The CA is responsible for finding out you are who you say you are before they first create a certificate. This is usually done by getting business licenses or talking on the phone and other boring non-internet things.

The certificate, which tells you whose certificate it is, has one side of one of a pair of keys in it as well. This key is unrelated to the key that lets you know it's a valid certificate.

The computer accessing this website encrypts what it sends the website (that needs to be kept secret) with that key, and only the website can unencrypt it with its secret key.

In reality, they pass a third secret key in the first message that encrypts and decrypts. This makes the communication faster and since it was sent over the secure connection, it's secure.

---------------- SOB --------------------
[source-reddit](https://www.reddit.com/r/explainlikeimfive/comments/jsq3m/eli5_what_are_online_security_certificates_ssl/?rdt=49527)
There are several different technologies here. I will focus on what's called Public Key Infrastructure (PKI) and Secure Socket Layer / Transport Layer Security (SSL / TLS). Note that the below describes the "ideal" case. SSL and PKI have some horrible, horrible problems that mean it is often not so straightforward in practice.

When you want to communicate something privately, you often want to know two things: am I talking to who I think I am, and can anyone else hear me? PKI solves the first problem; SSL / TLS the second. Third, you may want to ensure that what's said has integrity, or it hasn't changed (much like things can do in the children's game Telephone).

On the Internet, when you go to a web page to do something that you'd like to keep private (like buy something) you often "look for the lock" that indicates a secure connection. This is something that your web browser shows you to let you know that a SSL connection has been initiated.

But in order to give you that peace of mind, the web site's owner first has to have in place a certificate that verifies their identity. They do this through paying a "trusted entity" (aka a certificate authority or "CA") to tie the trusted identity's assurance to the web site owners certificate file. The certificate file is a complex electronic file which is valid for a specific server or set of servers; the trusted identity's assurance is through a cryptographic operation called a digital signature. Together, the site owner's certificate and the trusted identities signature make up two links in what's called a "chain of trust". The CA is responsible for ensuring that the certificate bearer is who they say they are through some process of authentication. At the top of the chain are companies that have a reputation for integrity and they delegate the ability for other entities or companies to certify other entities / companies. A valid security certificate will have the digital signatures of one or more trusted identities, ultimately going back to a top-level entity which many, many people trust. These trusts are stored in browsers and/or operating systems.

Once that certificate, with its trust signature in place, is referenced by the web server software, it's presented to any client (e.g. web browser) when a connection is made. So if you browse to [https://www.paypal.com](https://www.paypal.com/) you can find a way in your browser to view the certificate chain. You'll see at the bottom is "www.paypal.com" (the domain for which the certificate is valid). Then there is an intermediary, "VeriSign Class 3 Extended Validation SSL CA" and finally the root certificate authority "VeriSign Class 3 Public Primary Certification Authority - G5". If your computer or browser has a trust defined for either the Public Primary CA or the Class 3 Extended Validation CA, then your browser will let you know that the connection is secure because your system trusts those entities higher in the chain. Further, the certificate for "www.paypal.com" would not be valid for the site "othersite.paypal.com"

Now that identity has been assured, your browser will initiate what's known as an SSL / TLS handshake. This is a series of ordered steps which do some pretty complex cryptographic functions. While many things take place, the most important feature is called Public Key Cryptography. PKC relies on some mathematical means to generate two files: one public, one private. When these files are used to perform cryptographic operations, anything signed or encrypted by the public key can only be verified or decrypted by the private key. Anything signed or encrypted by the private key can be verified or decrypted by anyone with the public key. You always, always need to keep that private key private. You can post the public key anywhere you'd like; in fact, the server's certificate is its public key.

Along the way, the sensitive information is "signed" by the server's certificate; other parts are also encrypted. Clients can also have certificates, though this is not as common among most users. When the server "signs" some information, the client can verify it comes from the server and only the server, because of PKC. Further, the client can encrypt information to the server using its certificate (public key) because only the certificate holder, the website, can decrypt it because the web site and only the web site has the private key. This also means that someone can't just download PayPal's public certificate and pretend to be PayPal. As soon as the client received information from the fake server, they would send things back encrypted to the public certificate and if the attacking site didn't have PayPal's private key, they wouldn't be able to complete the connection.

Public key cryptography is strong, but it's slow. So what ultimately happens is that the server and client use PKC to exchange a session key and then use the session key to do much faster cryptography (symmetric key crypto, where both sides use the same pre-shared "password" to encrypt and decrypt). This is OK because the PKC is used to securely share that symmetric key; no one else knows it. But it can't be done first because if someone were able to intercept that symmetric key, then anyone could eavesdrop.

The final benefit of SSL is that users can be assured that their connections are not being altered (not just remaining private from eavesdropping). The electronic signatures on the data ensure that nothing has been changed; cryptographic functions verify that every bit is in order and present as sent by the system which signed it.

---------------- EOB --------------------


---------------- [SOB](https://www.freecodecamp.org/news/encryption-explained-in-plain-english/) --------------------
**Sender**
![[Pasted image 20230916114345.png]]
**Receiver**
![[Pasted image 20230916114401.png]]

The two key ingredients needed to send a message to your friend that only they can read is an **encryption algorithm** and a **key**.

The encryption algorithm is simply a mathematical formula designed to scramble data, while the key is used as part of the formula. The encryption algorithm is generic, but the key, used as an input to the algorithm, is what ensures the uniqueness of the scrambled data.

## Symmetric and Asymmetric Key Encryption

The core of any encryption process is the encryption algorithm and the key. There are many types of encryption algorithms. But there are, broadly speaking, two types of keys – symmetric and asymmetric keys.

In symmetric key encryption, the same key used to encrypt the data is used to decrypt the data. In asymmetric key encryption, one key is used to only encrypt the data (the public key) and another key is used to decrypt (the private key).

### Asymmetric key encryption

First, let’s look at asymmetric key encryption with a simple analogy.

Imagine you wanted to send something to your friend, but it was absolutely essential that nobody else, except your friend, could have access to that object. So, your friend buys an indestructible box, fabricated from the strongest metal on the planet, and sends it to you so that you can place the object in it. Your friend also sends you the key that can only be used to lock the box.

Now, this box has one more special property. It has two keyholes. One keyhole to open the box, another to lock the box.

![[Pasted image 20230916115142.png]]

Naturally, this box will also need two keys – one to open and another to lock it.

![[Pasted image 20230916115155.png]]
Both keys are similar, but not identical. As you can see in the image above, for example, the key used to open the box has two prongs while the key used to lock the box has three prongs.

As the sender of the object, all you have is the box to place the object in and a key to lock the box. Only your friend has the key that can unlock the box.

The key used to lock the box is called the public key, and cannot be used to open it, as that requires the private key. If anyone intercepted the package and made a copy of the public key, it could not be used to open the box, only to lock it. Only the person who holds the private key can open the box.

![[Pasted image 20230916115222.png]]

Asymmetric key encryption is used when there are two or more parties involved in the transfer of data. This type of encryption is used for encrypting data in transit, that is encrypting data being sent between two or more systems. The most popular example of asymmetric key encryption is [RSA](https://nordvpn.com/blog/rsa-encryption/).

  
Symmetric key encryption uses the same key for encryption and decryption. This makes sharing the key difficult, as anyone who intercepts the message and sees the key can then decrypt your data.

This is why symmetric key encryption is generally used for encrypting data at rest. AES-256 is the most popular symmetric key encryption algorithm. It is used by AWS for encrypting data stored in hard disks (EBS volumes) and S3 buckets. GCP and Azure also use it for encrypting data at rest.

main strength of symmetric key encryption is that it is computationally easier and faster to encrypt and decrypt data using a single key, just as it is easier to build a box with a single lock and key.

The drawback of asymmetric key encryption is that the encryption and decryption process is slower and more complicated. Asymmetric key encryption is ideal for encrypting data in transit, where you need to share the key with another system.

What if there was a way of getting the speed and computational simplicity of symmetric encryption without increasing the risk of exposing your keys?

TLS/SSL encryption use both symmetric and asymmetric keys to encrypt data in transit, and is used with the HTTP protocol for secure communications over a computer network.

### TLS/SSL Encryption Explained

TSL (Transport Layer Security) and SSL (Secure Sockets Layer) are often used interchangeably to mean the same thing. But when people say SSL, they often mean TLS.
TLS is generally considered more secure than SSL due to several improvements made to the protocol, such as stronger cryptographic algorithms. Due to security concerns with SSL, most modern web browsers and applications have dropped support for SSL and only support TLS. As a result, TLS has become the standard for secure communication over the internet.

### How to Use Symmetric and Asymmetric Encryption at the Same Time

Let's say you want to securely send a parcel to your friend. But you don’t want to keep using the special indestructible box that has two keyholes and two locks. It is expensive, heavy and impractical to use for frequent communications. You still want to use an indestructible box, but one that is simpler, with a single lock and key.

However, if you are using a box with only a single lock and key, you now need to figure out how to securely share the key for that simpler box with your friend.

Since the same key is used to both open and lock it, you cant just send the key to your friend without somehow protecting it first. If the key is intercepted and a copy is taken by someone, they can now open your box and take what is inside.

How can you securely share this key with your friend so that you can use this simpler box for future communication?
![[Pasted image 20230916120012.png]]

1. First, your friend sends the box with the two locks plus the public key used to lock it. But you don’t want to keep using this box. You will only use this box once – to transfer the key for another simpler box that you will use for future exchanges.
2. You place the master key that will be used in future exchanges inside this box and lock it with the public key sent by your friend.
3. You send the locked box which contains a copy of the master key inside back to your friend.
4. Your friend uses his private key to open the box. Now you both have the master key and can be sure no one else has it since it was sent in a secure box
5. All future items are then placed in this simpler box with a single lock and key which can be opened and locked using the master key you just sent to your friend.
### TLS/SSL Encryption Sequence

The analogy in the previous section neatly maps to how TLS/SSL encryption actually works. But there are some prerequisite steps which I ignored in this analogy, like creating a TCP connection and the server sending its certificate (Steps 1 and 2 below).

Also, Step 6 is a simplification of the process. In reality, the master key is used to generate a further set of keys that the client and server will use to encrypt and decrypt messages and also to authenticate that the messages were indeed sent by the client and server.


To read more about the low level detail, I’d recommend Chapter 8 of "[Computer Networking](https://www.amazon.co.uk/Computer-Networking-Global-James-Kurose/dp/1292405465/ref=sr_1_1?keywords=computer+networking+a+top-down+approach&qid=1680219419&sprefix=computer+netw%2Caps%2C168&sr=8-1)" by Kurose & Ross.

But, at a high level, the sequence is as follows:

1. Client establishes TCP connection with the server
2. Client verifies that the server is who it says it is – server sends certificate which has the public key. The accompanying private key remains with the server.
3. Client creates a master secret key and uses the server's public key to encrypt it. This master secret key is a symmetric key so the same key is used for encryption and decryption.
4. Client sends the encrypted master secret key to the server.
5. Server decrypts the encrypted master key using its private key.
6. All future messages between client and server now use the symmetric master key to encrypt and decrypt messages.
## Best of Both Worlds

Using both symmetric and asymmetric key encryption gives you the speed of symmetric key encryption without compromising on the extra security provided by asymmetric key encryption.

But nothing comes for free, of course. With TLS, there is an added layer of complexity since you need to first use asymmetric keys to establish a secure connection before exchanging the symmetric key for future communication.

So by using both symmetric and asymmetric encryption, TLS/SSL gets the best of both worlds with limited downsides.
---------------- EOB --------------------

# TLS in kubenetes

A **Root SSL certificate** is a certificate issued by a **trusted certificate authority**
In the SSL ecosystem, anyone can generate a signing key and use it to sign a new certificate. However, that certificate isn’t considered valid unless it has been directly or indirectly signed by a trusted CA.
A **trusted certificate authority** is an entity that’s entitled to verify someone is who they say they are. In order for this model to work, all participants must agree on a set of trusted CAs. All operating systems and most web browsers ship with a set of trusted CAs.

The SSL ecosystem is based on a model of a trust relationship, also called the “chain of trust”. When a device validates a certificate, it compares the certificate issuer with the list of trusted CAs. If a match isn’t found, the client checks to see if the certificate of the issuing CA was issued by a trusted CA, and continues until the end of the [certificate chain](https://support.dnsimple.com/articles/what-is-ssl-certificate-chain). The top of the chain, the **root certificate**, must be issued by a trusted Certificate Authority.
![[Pasted image 20230916122351.png]]

![[Pasted image 20230916122835.png]]

![[Screenshot 2023-09-16 at 12.31.36 PM.png]]
>Client is with respect to kube api server
  Server wrt kub3 api server, i.e kubeapiserver talks to etcd so etcd is server to kubeapi


# TLS Certificate Generation

Tools available to generate certificates
1. EASYRSA
2. OPENSSL
3. CFSSL
4. .....
## Certificate Authority (CA)

- Generate Keys
    
    ```
    $ openssl genrsa -out ca.key 2048
    ```
    
- Generate CSR
    
    ```
    $ openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr
    ```
    
- Sign certificates
    
    ```
    $ openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt
    ```

![[Pasted image 20230916125647.png]]


## Generating Client Certificates

#### [](https://github.com/kodekloudhub/certified-kubernetes-administrator-course/blob/master/docs/07-Security/07-TLS-in-Kubernetes-Certificate-Creation.md#admin-user-certificates)Admin User Certificates

- Generate Keys
    
    ```
    $ openssl genrsa -out admin.key 2048
    ```
    
- Generate CSR
    
    ```
    $ openssl req -new -key admin.key -subj "/CN=kube-admin" -out admin.csr
    ```
    
- Sign certificates
    
    ```
    $ openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -out admin.crt
    ```
    
   ![[Pasted image 20230916125732.png]]
    
- Certificate with admin privilages
    
    ```
    $ openssl req -new -key admin.key -subj "/CN=kube-admin/O=system:masters" -out admin.csr
    ```
    

#### [](https://github.com/kodekloudhub/certified-kubernetes-administrator-course/blob/master/docs/07-Security/07-TLS-in-Kubernetes-Certificate-Creation.md#we-follow-the-same-procedure-to-generate-client-certificate-for-all-other-components-that-access-the-kube-apiserver)We follow the same procedure to generate client certificate for all other components that access the kube-apiserver.
![[Pasted image 20230916125759.png]]
![[Pasted image 20230916125808.png]]
![[Pasted image 20230916125818.png]]
![[Pasted image 20230916125829.png]]
![[Pasted image 20230916161712.png]]
![[Pasted image 20230916161800.png]]
![[Pasted image 20230916161910.png]]
![[Pasted image 20230916162001.png]]

# View certificate details
![[Pasted image 20230916162558.png]]


Kubernetes Certificate Health Check Spreadsheet here:

[https://github.com/mmumshad/kubernetes-the-hard-way/tree/master/tools](https://github.com/mmumshad/kubernetes-the-hard-way/tree/master/tools)

We can find the kubeapiserver cert details from below file
```bash
cat /etc/kubernetes/manifests/kube-apiserver.yaml
```
for etcd server details

```bash
cat /etc/kubernetes/manifests/etcd .yaml
```
#CommonCommands 
```bash

### command to see the CA certificate details
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout

openssl x509 -in /etc/kubernetes/pki/etcd/ server.crt -text -noout

```
# CertificateAPI
- The CA is really just the pair of key and certificate files that we have generated, whoever gains access to these pair of files can sign any certificate for the kubernetes environment.
#### Kubernetes has a built-in certificates API that can do this for you.

- With the certificate API, we now send a certificate signing request (CSR) directly to kubernetes through an API call.
- ![[Pasted image 20230916190259.png]]
#### This certificate can then be extracted and shared with the user.

- A user first creates a key
    
    ```
    $ openssl genrsa -out jane.key 2048
    ```
    
- Generates a CSR
    
    ```
    $ openssl req -new -key jane.key -subj "/CN=jane" -out jane.csr 
    ```
    
- Sends the request to the administrator and the adminsitrator takes the key and creates a CSR object, with kind as "CertificateSigningRequest" and a encoded "jane.csr"
    
    ```
    apiVersion: certificates.k8s.io/v1beta1
    kind: CertificateSigningRequest
    metadata:
      name: jane
    spec:
      groups:
      - system:authenticated
      usages:
      - digital signature
      - key encipherment
      - server auth
      request:
        <certificate-goes-here>
    ```
    
    $ cat jane.csr |base64 $ kubectl create -f jane.yaml
![[Pasted image 20230916190334.png]]

- To list the csr's
    
    ```
    $ kubectl get csr
    ```
    
- Approve the request
    
    ```
    $ kubectl certificate approve jane
    ```
    
- To view the certificate
    
    ```
    $ kubectl get csr jane -o yaml
    ```
    
- To decode it
    
    ```
    $ echo "<certificate>" |base64 --decode
    ```
![[Pasted image 20230916190359.png]]

#### All the certificate releated operations are carried out by the controller manager.

- If anyone has to sign the certificates they need the CA Servers, root certificate and private key. The controller manager configuration has two options where you can specify this.
![[Pasted image 20230916190427.png]]
![[Pasted image 20230916190444.png]]

![[Pasted image 20230916191147.png]]
![[Pasted image 20230916191215.png]]
![[Pasted image 20230916191257.png]]
![[Pasted image 20230916191338.png]]
![[Pasted image 20230916191413.png]]


# Kubeconfig

#### Client uses the certificate file and key to query the kubernetes Rest API for a list of pods using curl.

- You can specify the same using kubectl
![[Pasted image 20230916191514.png]]
- We can move these information to a configuration file called kubeconfig. And the specify this file as the kubeconfig option in the command.
    
    ```
    $ kubectl get pods --kubeconfig config
    ```
## Kubeconfig File

- The kubeconfig file has 3 sections
    
    - Clusters
    - Contexts
    - USers
![[Pasted image 20230916191643.png]]
![[Pasted image 20230916191703.png]]
- To view the current file being used
    
    ```
    $ kubectl config view
    ```
    
- You can specify the kubeconfig file with kubectl config view with "--kubeconfig" flag
    
    ```
    $ kubectl config veiw --kubeconfig=my-custom-config
    ```
![[Pasted image 20230916191740.png]]
How do you update your current context? Or change the current context

```
$ kubectl config view --kubeconfig=my-custom-config
```
![[Pasted image 20230916191843.png]]

kubectl config help

```
$ kubectl config -h
```
![[Pasted image 20230916192251.png]]
![[Pasted image 20230916192307.png]]
![[Pasted image 20230916192430.png]]


# API-Groups
![[Pasted image 20230916193024.png]]
The kubernetes API is grouped into multiple such groups based on their purpose. Such as one for **`APIs`**, one for **`healthz`**, **`metrics`** and **`logs`** etc.
![[Pasted image 20230916193039.png]]
## API and APIs

- These APIs are catagorized into two.
    
    - The core group - Where all the functionality exists
    - The Named group - More organized and going forward all the newer features are going to be made available to these named groups.
- ![[Pasted image 20230916193151.png]]
- ![[Pasted image 20230916193159.png]]
To list all the api groups

![[Pasted image 20230916193216.png]]
## Note on accessing the kube-apiserver

- You have to authenticate by passing the certificate files.
![[Pasted image 20230916193309.png]]

An alternate is to start a **`kubeproxy`** client
![[Pasted image 20230916193328.png]]
![[Pasted image 20230916193342.png]]

# Authorization
![[Pasted image 20230916200459.png]]
## Why do you need Authorization in your cluster?

- As an admin, you can do all operations
    ```
    $ kubectl get nodes
    $ kubectl get pods
    $ kubectl delete node worker-2
    ```
![[Pasted image 20230916195052.png]]

## Authorization Mechanisms

- There are different authorization mechanisms supported by kubernetes
    - Node Authorization
    - Attribute-based Authorization (ABAC)
    - Role-Based Authorization (RBAC)
    - Webhook

### Node Authorization
A special-purpose authorizer that grants permissions to kubelets based on the pods they are scheduled to run on.
![[Pasted image 20230916195904.png]]
### ABAC
An authorizer through which access rights are granted to users through policies combining attributes (resources attributes, user attributes, objects, etc.)
![[Pasted image 20230916195958.png]]

### RBAC
A method of regulating access to computer or network resources based on the roles of individual users within an enterprise.
![[Pasted image 20230916200023.png]]

### Webhook
A webhook is a HTTP callback – a HTTP POST that occurs when something happens. This mode allows for integration with Kubernetes external authorizers.
![[Pasted image 20230916200125.png]]

When you specify multiple modes, it will authorize in the order in which it is specified
![[Pasted image 20230916205443.png]]

# RBAC

## How do we create a role?

- Each role has 3 sections
    - apiGroups
    - resources
    - verbs
- create the role with kubectl command
    
    ```
    $ kubectl create -f developer-role.yaml
    ```
    

## [](https://github.com/kodekloudhub/certified-kubernetes-administrator-course/blob/master/docs/07-Security/17-RBAC.md#the-next-step-is-to-link-the-user-to-that-role)The next step is to link the user to that role.

- For this we create another object called **`RoleBinding`**. This role binding object links a user object to a role.
- create the role binding using kubectl command
    
    ```
    $ kubectl create -f devuser-developer-binding.yaml
    ```
    
- Also note that the roles and role bindings fall under the scope of namespace.
    
    ```
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      name: developer
    rules:
    - apiGroups: [""] # "" indicates the core API group
      resources: ["pods"]
      verbs: ["get", "list", "update", "delete", "create"]
    - apiGroups: [""]
      resources: ["ConfigMap"]
      verbs: ["create"]
    ```
    
    ```
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: devuser-developer-binding
    subjects:
    - kind: User
      name: dev-user # "name" is case sensitive
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: Role
      name: developer
      apiGroup: rbac.authorization.k8s.io
    ```
![[Pasted image 20230916205647.png]]
## View RBAC

- To list roles
    ```
    $ kubectl get roles
    ```
    
- To list rolebindings
    ```
    $ kubectl get rolebindings
    ```
    
- To describe role 
    ```
    $ kubectl describe role developer
    ```
To describe rolebinding
```
$ kubectl describe rolebinding devuser-developer-binding
```
You can use the kubectl auth command
```
$ kubectl auth can-i create deployments
$ kubectl auth can-i delete nodes
```
```
$ kubectl auth can-i create deployments --as dev-user
$ kubectl auth can-i create pods --as dev-user
```
```
$ kubectl auth can-i create pods --as dev-user --namespace test
```

## Resource Names

- Note on resource names we just saw how you can provide access to users for resources like pods within the namespace.
    
    ```
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      name: developer
    rules:
    - apiGroups: [""] # "" indicates the core API group
      resources: ["pods"]
      verbs: ["get", "update", "create"]
      resourceNames: ["blue", "orange"]
    ```
![[Pasted image 20230916205955.png]]

# Cluster-Roles
the resources are categorized as either namespaced or cluster scoped.

- To see namespaced resources
    ```
    $ kubectl api-resources --namespaced=true
    ```

- To see non-namespaced resources
    ```
    $ $ kubectl api-resources --namespaced=false
    ```
![[Pasted image 20230916211955.png]]

## Cluster Roles and Cluster Role Bindings

- Cluster Roles are roles except they are for a cluster scoped resources. Kind as **`CLusterRole`**
    
    ```
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: cluster-administrator
    rules:
    - apiGroups: [""] # "" indicates the core API group
      resources: ["nodes"]
      verbs: ["get", "list", "delete", "create"]
    ```
    
    ```
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: cluster-admin-role-binding
    subjects:
    - kind: User
      name: cluster-admin
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: ClusterRole
      name: cluster-administrator
      apiGroup: rbac.authorization.k8s.io
    ```
    
    ```
    $ kubectl create -f cluster-admin-role.yaml
    $ kubectl create -f cluster-admin-role-binding.yaml
    ```
![[Pasted image 20230916212058.png]]
- You can create a cluster role for namespace resources as well. When you do that user will have access to these resources across all namespaces.


# Service Accounts
Whenever you access your Kubernetes cluster with **[kubectl](https://kubernetes.io/docs/reference/kubectl/)**, you are authenticated by Kubernetes with your user account. User accounts are meant to be used by humans. But when a pod running in the cluster wants to access the Kubernetes API server, it needs to use a service account instead. Service accounts are just like user accounts but for non-humans.
But, you may wonder, why would pods inside the Kubernetes cluster need to connect to the Kubernetes API at all? Well, there are multiple use cases for it. The most common one is when you have a CI/CD pipeline agent deploying your applications to the same cluster. Many cloud-native tools also need access to your Kubernetes API to do their jobs, such as logging or monitoring applications.

- **User Account**: It is used to allow us, humans, to access the given Kubernetes cluster. Any user needs to get authenticated by the API server to do so. A user account can be an admin or a developer who is trying to access the cluster level resources.
- **Service Account**: It is used to authenticate machine level processes to get access to our Kubernetes cluster. The API server is responsible for such authentication to the processes running in the pod

## Service Account :

In the Kubernetes cluster, any processes or applications in the container which resides within the pod can access the cluster by getting authenticated by the API server, using a service account.

## For Example:

An application like **Prometheus** accessing the cluster to monitor it is a type of service account
A service account is an identity that is attached to the processes running within a pod.
```bash
kubectl get serviceaccount

### to see the token generated by service account
kubectl exec -it <podname> --ls /var/run/secrets/kubernetes.io/serviceaccount
```


```yaml
apiVersion: v1
kind: ServiceAccount
imagePullSecrets:
- name: pierone.stups.zalan.do  # required to pull images from private registry
metadata:
  name: operator
  namespace: $YOUR_NAMESPACE
```

The service account can be used in an example deployment like this:
```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: nginx
  namespace: acid
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
      serviceAccountName: operator  #this is where your service account is specified
      hostNetwork: true
```

# Image Security

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx
```
![[Pasted image 20230916215217.png]]
# Private Registry

- To login to the registry
    ```
    $ docker login private-registry.io
    ```
    
- Run the application using the image available at the private registry
    ```
    $ docker run private-registry.io/apps/internal-app
    ```
- To pass the credentials to the docker untaged on the worker node for that we first create a secret object with credentials in it.
    
    ```
    $ kubectl create secret docker-registry regcred \
      --docker-server=private-registry.io \ 
      --docker-username=registry-user \
      --docker-password=registry-password \
      --docker-email=registry-user@org.com
    ```
    
- We then specify the secret inside our pod definition file under the imagePullSecret section
    
    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: nginx-pod
    spec:
      containers:
      - name: nginx
        image: private-registry.io/apps/internal-app
      imagePullSecrets:
      - name: regcred
    ```

# Docker-security

```bash
docker run --user=1001 ubuntu sleep 3600
docker run --cap-add <User> ubuntu
```

# Networking
![[Pasted image 20230916215659.png]]
![[Pasted image 20230916215714.png]]
## Create network policy

- To create a network policy
    ```
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
     name: db-policy
    spec:
      podSelector:
        matchLabels:
          role: db
      policyTypes:
      - Ingress
      ingress:
      - from:
        - podSelector:
            matchLabels:
              role: api-pod
        ports:
        - protocol: TCP
          port: 3306
    ```
    
    ```
    $ kubectl create -f policy-definition.yaml

	```
![[Pasted image 20230916220731.png]]
![[Pasted image 20230916220645.png]]

![[Pasted image 20230916220650.png]]
![[Pasted image 20230916221143.png]]
![[Pasted image 20230916221209.png]]


# Kubectx and Kubens – Command line Utilities

Through out the course, you have had to work on several different namespaces in the practice lab environments. In some labs, you also had to switch between several contexts.

  

While this is excellent for hands-on practice, in a real “live” kubernetes cluster implemented for production, there could be a possibility of often switching between a large number of namespaces and clusters.

  

This can quickly become and confusing and overwhelming task if you had to rely on kubectl alone.

  

This is where command line tools such as kubectx and kubens come in to picture.

  

Reference: [https://github.com/ahmetb/kubectx](https://github.com/ahmetb/kubectx)

  

**Kubectx:**

With this tool, you don't have to make use of lengthy “kubectl config” commands to switch between contexts. This tool is particularly useful to switch context between clusters in a multi-cluster environment.

  

**Installation:**

1. sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
2. sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx

  

**Syntax:**

To list all contexts:

> kubectx

  

To switch to a new context:

> kubectx <context_name>

  

To switch back to previous context:

> kubectx -

  

To see current context:

> kubectx -c

  

  

**Kubens:**

This tool allows users to switch between namespaces quickly with a simple command.

**Installation:**

1. sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
2. sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

  

**Syntax:**

To switch to a new namespace:

> kubens <new_namespace>

  

To switch back to previous namespace:

> kubens -










