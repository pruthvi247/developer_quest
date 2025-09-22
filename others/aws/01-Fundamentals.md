[pluralsight-source](https://app.pluralsight.com/ilx/aws-certified-solutions-architect-associate-(saa-c03)-fundamental-services/7d0e551b-697a-4e2f-b24c-0536b081ab33/1c0ada31-9fad-42b8-b404-66c44df6db5b)

**Edge Locations** : Edge Locations are endpoints for AWS that are used for caching content
A **region** is a physical location -> A region may have many Availability zones (like data center)

> It's best practice to group users and provide permissions, instead of giving permissions individually

![[Pasted image 20250225090955.png]]
![[Pasted image 20250225204746.png]]
## NAT GateWay
You can use a network address translation gate way to **enable instances in private subnet** to connect to the internet or other AWS services while preventing the internet from initiating a connection with those instances

![[Pasted image 20250225230657.png]]
private subnet can use internet through NAT Gate way, 

![[Pasted image 20250225230747.png]]## Network ACLs
 A network access control list (ACL) is ans optional layer of security for your VPC that acts as a firewall for controlling traffic in and out of one or more subnets

We might setup network ACL with rules similar to your security groups in order to add another layer of security to your VPC, Custom network ACL's by default denies all inbound and outbound traffic until you add rules

Each subnet in your VPC must be associated with a network ACL. If you don't explicitly associate a subnet with a network ACL, The subnet is automatically associated with the default network ACL

Blocking IP addresses should be done using network ACL not security groups

- We can associate a network ACL with multiple subnets; however, a subnet can be associated with only 1 network ACL at a time. When you associate a network ACL with a subnet, the previous association is removed
- Network ACL contain a numbered list of rules that are evaluated in order, starting with the lowest numbered rule
- Network ACL have separate inbound and outbound rules, and each rule can either allow or deny traffic
- Network ACL are stateless; responses to allowed inbound traffic are subject to the rules for outbound traffic (and vice versa)

`Note:` Security group are stateful, Network ACL is stateless

we can associate a network ACL with multiple subnets; however, a subnet can be associated with only 1 network ACL at a time. When you associate a network ACL with a subnet, the previous association is removed

Network ACL's Contain a numbered list of rules that are evaluated in order, starting with the lowest numbered rule.

**Ephemeral ports**
Ephemeral ports are those allocated temporarily, generally for outbound connection source ports. Technically, there are a few protocols that allocate temporary ports for incoming connections, but those are rare. FTP is the main example.
An **ephemeral port** is a temporary network communication endpoint used to establish a connection with a server application over the internet or a local network. Ports have port numbers, which are numeric values used to identify communication endpoints in an IP network. Port numbers help direct network traffic to the appropriate end destination and facilitate communication. The system ensures that the selected port is not in use by any other active connection to avoid conflicts.

The purpose of ephemeral ports is to allow multiple client applications to establish simultaneous connections to a server without interfering with each other. Once the communication session between the client and server is complete or terminated, the ephemeral port is released and becomes available for reuse by other applications when necessary.

In a stateless firewall that is filtering in both directions, you have to permit the return packets. So, from the client to server you'd need to permit source yourIP:1024-65535 destination serverIP:22, and then in the other direction you'd need to permit source serverIP:22 destination yourIP:1024-65535.

In general, stateless ACLs are a terrible way to do security that includes ports. Stateless is fine for controlling what IPs can talk to what other IPs, but once you get into ports you really need to be doing stateful ACLs to make it secure and not absurdly complex and prone to accidents.

>NAT gateways are not directly related to security, they're for enabling routing from a private IPv4 subnet. NAT gateways might provide some indirect benefit but that's not their primary purpose.
>
>NACL are the primary mechanism for permitting/denying access to a subnet.


[medium-source](https://medium.com/awesome-cloud/aws-difference-between-security-groups-and-network-acls-adc632ea29ae)

![[Pasted image 20250226151755.png]]

# TL;DR:

- **Security group** is the firewall of EC2 **Instances**.  
- **Network ACL** is the firewall of the VPC **Subnets**.
- Instance can have multiple Security groups.
- Subnet can have only one NACL.
- Security group rule allows CIDR, IP, and Security Group as destinations.
- Network ACL rule only allows CIDR as a destination.
- Security group first layer of defense, whereas Network ACL is the second layer of defense for outbound/egress traffic.
- Network ACL first layer of defense, whereas the Security group is the second layer of defense for inbound/ingress traffic.
--------------------
[image-source](https://dev.to/aws-builders/aws-networking-aws-vpc-subnets-security-groups-nat-gateway-ip-addresses-4p8c)

![[Pasted image 20250226154004.png]]

-------------------
## VPC Endpoints
A VPC endpoint enables you to privately connect your vpc to supported AWS service and VPC endpoint services powered by private link without requiring an internet gateway, NAT device, VPN connection, or AWS Direct connect connection

VPC endpoints are virtual devices. They are horizontally scaled, redundant, and highly available Amazon VPC components that allow communication between instances in an Amazon VPC and services without imposing availability risks or bandwidth constraints on network traffic. There are two types of VPC endpoints:

- _interface endpoints_
- _gateway endpoints_

**User-case**: When you want to connect AWS service without leaving the amazon internal network

![[Pasted image 20250226154956.png]]

### VPC Peering
A VPC peering connection is a networking connection between two VPCs that enables you to route traffic between them using private IPv4 addresses or IPv6 addresses. Instances in either VPC can communicate with each other as if they are within the same network. You can create a VPC peering connection between your own VPCs, or with a VPC in another AWS account. The VPCs can be in different Regions (also known as an inter-Region VPC peering connection).

`Note` : Transitive peering is not supported in VPC Peering
![[Pasted image 20250226155906.png]]

VPC-B can not be connected to VPC-C through VPC-A (Transitive), we should establish a connection between VPC-B to VPC-C

 AWS VPN CloudHub is a networking solution provided by Amazon Web Services (AWS) that enables you to establish multiple site-to-site VPN connections between your on-premises network and multiple Amazon Virtual Private Clouds (VPCs). It allows you to connect your on-premises network to multiple VPCs in different AWS Regions using a central hub configuration.
 
>`note`: Block ip address using Network ACL But not using security groups

![[Pasted image 20250228090758.png]]

#### ENI:
For basic networking. Perhaps you need a separate management network from your production network or a separate logging network, and you need to do this at a low cost. In this secenario, use multiple ENI's for each network

#### EFA:
For when you need to accelerate High Performance Computing (HPC) and machine learning applications or if you need to do an OS-by pass. if you see a scenario. question mentioning HPC or ML and asking what network adapter you want, choose EFA

#### Enhanced Networking
For when you need speeds between 10Gbps and 100 Gbps. Anywhere you need reliable, high throughput

## EC2 Placement groups

To meet the needs of your workload, you can launch a group of _interdependent_ EC2 instances into a _placement group_ to influence their placement.

Depending on the type of workload, you can create a placement group using one of the following placement strategies:

- **Cluster** – Packs instances close together inside an Availability Zone. This strategy enables workloads to achieve the low-latency network performance necessary for tightly-coupled node-to-node communication that is typical of high-performance computing (HPC) applications.
    
- **Partition** – Spreads your instances across logical partitions such that groups of instances in one partition do not share the underlying hardware with groups of instances in different partitions. This strategy is typically used by large distributed and replicated workloads, such as Hadoop, Cassandra, and Kafka.
    
- **Spread** – Strictly places a small group of instances across distinct underlying hardware to reduce correlated failures.
    

Placement groups are optional. If you don't launch your instances into a placement group, EC2 tries to place the instances in such a way that all of your instances are spread out across the underlying hardware to minimise correlated failures.

###### Pricing

There is no charge for creating a placement group.

###### Rules and limitations

Before you use placement groups, be aware of the following rules:

- An instance can be placed in one placement group at a time; you can't place an instance in multiple placement groups.
    
- You can't merge placement groups.
    
- [On-Demand Capacity Reservations](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-capacity-reservations.html#capacity-reservations-limits) and [zonal Reserved Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/reserved-instances-scope.html) allow you to reserve capacity for EC2 instances in Availability Zones. When you launch an instance, if the instance attributes match those specified by an On-Demand Capacity Reservation or a zonal Reserved Instance, then the reserved capacity is automatically used by the instance. This is also true if you launch the instance into a placement group.
    
- You can't launch Dedicated Hosts in placement groups.
    
- You can't launch a Spot Instance that is configured to stop or hibernate on interruption in a placement group.

##### TIPS
- A Cluster Placement group can't span multiiple Availability zones, whereas a spred placement group and partition placement group can
- Only certain types of instances can be launched in a placement group (compute optimised, GPU, memory optimized, storage optimised)
- AWS recommends homogenous instance within cluster placement groups
- You can't merge placement groups
- You can move an existing instance into placement group. Before you move the instance, the instance must be in the stopped state. You can move or remove an instance using the AWS CLI or an AWS SDK, but you can't do it via the console yet

# EC2 Boot strapping
https://421849021883.signin.aws.amazon.com/console?region=us-east-1
cloud_user
3nwCYEatv7_8&SS5W}$v

--------------------
[medium-source](https://medium.com/awesome-cloud/aws-vpc-difference-between-internet-gateway-and-nat-gateway-c9177e710af6)
### TL;DR:

==Internet Gateway (IGW) allows instances with public IPs to access the internet.  
NAT Gateway (NGW) allows instances with no public IPs to access the internet.==

#### **Internet Gateway**

- Internet Gateway (IGW) is a horizontally scaled, redundant, and highly available VPC component that allows communication between your VPC and the internet.
- Internet Gateway enables resources (like EC2 instances) in public subnets to connect to the internet. Similarly, resources on the internet can initiate a connection to resources in your subnet using the public.
- If a VPC _does not_ have an Internet Gateway, then the resources in the VPC cannot be accessed from the Internet (unless the traffic flows via a Corporate Network and VPN/Direct Connect).
- Internet Gateway supports IPv4 and IPv6 traffic.
- Internet Gateway does not cause availability risks or bandwidth constraints on your network traffic.
- In order to make subnet public, add a route to your subnet’s route table that directs internet-bound traffic to the internet gateway.
- You can associate exactly one Internet Gateway with a VPC.
- Internet Gateway is not Availability Zone specific.
- There’s no additional charge for having an internet gateway in your account.
#### **NAT Gateway**

- NAT Gateway (NGW) is a managed Network Address Translation (NAT) service.
- NAT Gateway does something similar to Internet Gateway (IGW), but it only works one way: Instances in a private subnet can connect to services outside your VPC but external services cannot initiate a connection with those instances.
- NAT gateways are supported for IPv4 or IPv6 traffic.
- NAT gateway supports the following protocols: TCP, UDP, and ICMP.
- Each NAT gateway is created in a specific Availability Zone and implemented with redundancy in that zone.
- If you have resources in multiple Availability Zones and they share one NAT gateway, and if the NAT gateway’s Availability Zone is down, resources in the other Availability Zones lose internet access.
- To create an Availability Zone-independent architecture, create a NAT gateway in each Availability Zone.
- You can associate exactly one Elastic IP address with a public NAT gateway.
- You are charged for each hour that your NAT gateway is available and each Gigabyte of data that it processes.

NAT gateway replaces the source IP address of the instances with the IP address of the NAT gateway.


---------------
[blog-source](https://towardsaws.com/networking-in-aws-fb88c9336e22)

AWS Resources that we will be using throughout the tutorial:

1. VPC
2. Subnets
3. Security groups
4. Network ACLs
5. Internet Gateway
6. NAT Gateway
7. EC2

Let’s start with some networking basics that will help us better understand amazon's virtual private cloud (VPC).

**Bandwidth: _Bandwidth_** the word describes itself — The maximum amount of data transmitted over an internet connection in a given amount of time — it's about the volume of data transmitted rather than the speed of the data transmitted.

**Latency:** The time it takes a request to go from client to server then back from the server to the client is called latency. Latency could depend on multiple parameters but one of the most crucial ones is; distance.

**Throughput:** Bandwidth + latency

Suppose you are hitting [www.google.](http://www.google.xyz/)com, the request will then go to the Domain name server (DNS); DNS consists of a zone file; this zone file consist the records;  
A record might look like this:

Name                        Type                      Value  
www.google.com               A                        172.217.19.164  
.  
.

Now the DNS server will send the IP back to the client and then the client will then make a request to the IP address and that’s how we are prompted with the google home page.

**IP V4 Addresses:**

_This is just a refresher, assuming that you already know the IP address, their classes, subnet mask, and subnets._

We will take an example to understand what are subnets. Here we are taking class B IP address, Class b has 16 network bits and 16 hosts bits.

**Class B IP:** 172.168.0.0  
**Subnet mask:** 255.255.0.0

This subnet mask could be translated like this in octet:  
11111111.11111111.00000000.00000000

This combination of IP and subnet mask makes a subnet: 172.168.0.0/**16**

Here the /16 indicates that there are 16 network bits.  
We can host 65,536 nodes in this subnet. _how? as we have 16 host bits._

**Amazon Virtual Private Cloud VPC**

A bit of context here; AWS has many different regions where we can deploy our cloud infrastructure.  
Every region contains a default vpc and in that default vpc we have multiple availability zones and each availability zone have a public subnet.

VPC contains a CIDR block which stands for _classless inter domain routing_, its basically a _block_ of IP address from which we can take _ranges_ of IP address to make a subnet; a CIDR looks like this 172.31.0.0/16.

Take CIDR as a cake, from which we can take slices as a subnet. So VPC has a CIDR block and from that CIDR block we will create multiple subnets.

CIDR: 172.31.0.0/16 this has 16 network bits  
Subnet-1: 172.31.0.0/20 ~~ this has 20 network bits  
Subnet-2: 172.31.16.0/20  
Subnet-3: 172.31.31.0/20

![[Pasted image 20250302094039.png]]
**Public and private subnets:**

We now know that every availability zone has a public subnet, but we can also make a private subnet in that same availability zone; A VPC could contain over 200 subnets.

A resource in a public subnet can communicate with the outside world via an internet gateway.

Whereas a resource in a private subnet **cannot** communicate with the outside world.

Resources in public and private subnet can talk to each other.

Suppose there is a VPC in which there are two subnets; one public; one private and each of the subnet contains one ec2 instance, so these instances have a route table pre-configured which allow them to talk two each other until they are in one VPC regardless if they are in the private subnet or public subnet.

_So what if we want our resources in a private subnet to communicate with the outside world?_

We can configure a NAT gateway in our default public subnet so the resource in our private subnet will talk to the NAT gateway and then the NAT gateway will talk to Internet Gateway and vice versa.

## Firewalls:

A firewall allows or denies ingress traffic and egress traffic. We can define rules to allow or deny inbound traffic or similarly we can allow or deny outbound traffic.

In AWS Network ACLs and Security groups both act as a firewall.

`TIP`
>**Network ACLs:** Network ACLs are stateless firewalls and works on the subnet level.  
  **Security groups:** Security groups are stateful firewalls and work on instance level.

To understand stateful and stateless firewalls we can take an example.

Suppose a client with IP _192.168.1.1_ and port _61394_ wants to communicate with a web server having IP _214.178.0.1_ and port _80._

**Protocol**  **SourceIP**     **DestinationIP**   **SourcePort**   **DestinationPort**  
**1.**HTTP    192.168.1.1  214.178.0.1     61394        80  
**2.**HTTP    214.178.0.1  192.168.1.1     80           61394

So a stateless firewall isn’t intelligent enough, we have to set rules on a webserver to allow traffic coming from the client from IP _192.168.1.1_ on port 61394 and **also** allow traffic going out of the server to IP _192.168.1.1_ on port 61394. In a stateless firewall, we have to set both rules above. A stateless firewall doesn’t remember the state of connection and needs to set two rules for the same connection.

Whereas a stateful firewall remembers the state of the connection and only requires to set rules for the incoming traffic for the same connection. In a stateful firewall, we have to set only the first rule (1.) above because it remembers the state of the connection.

# _A gist of what we will be doing hands-on:_

1. We will be creating a VPC, in that VPC we will create two subnets; one public; one private.
2. We will attach an internet gateway to our public subnet; so that the resources in the public subnet can communicate with the outside world.
3. We will create two security groups one for the public subnet and another for the private subnet.
4. Then we will launch one ec2 instance in the public subnet and another one private subnet.
5. Then we will create a NAT gateway in the public subnet and add a route of it in the private route table; so that the resources in the private subnet can talk to the internet.
# Gear up and heads towards the aws console:

## AWS VPC

Search VPC from the search bar and create a VPC.

Add the name of your VPC, and give IPv4 CIDR block, every VPC has a CIDR block and subnets are created from the with in this CIDR block. So we can make multiple subnets from one CIDR block. A VPC can contain over 200 subnets.

Here we are giving 10.0.0.0/16 as a CIDR. This means that this CIDR block has 16 network bits and 16 hosts bits. So we can have nearly 65,536 hosts within this CIDR block.

This is an amazing [website](http://www.cidr.xyz/) to understand and play with CIDR.

![[Pasted image 20250302094951.png]]

Now when we have successfully created a VPC, we will create subnets within this VPC and we would have to choose IP ranges for the subnets from within CIDR IPv4 block.

This is an extremely powerful [_website_](https://network00.com/NetworkTools/IPv4SubnetCreator/) that will help you with the subnet IP ranges.  
Here we have entered our CIDR IPv4 block and ask that we need to have ~ 4000 host in each subnet.
This CIDR block can contain 16 subnets, and each subnet have 4096 hosts with

In the left pane, click subnet and choose the VPC we just made.

Give the name of subnet as a public subnet, and because we are making this subnet in 1a availability zone. We can name our subnet as Public-1a to have better visibility.  
Choose an IP range for this subnet, we have an IP range as 10.0.0.0/20  
This means that this subnet will have 20 network bits and 12 hosts bits so we can have 4096 hosts within this subnet.

![[Pasted image 20250302095149.png]]
Now select the subnet and choose Modify auto-assign IP settings from the drop-down.
![[Pasted image 20250302095233.png]]
> Now follow the same procedure above to make a private subnet in the same VPC we made our public subnet.

**Subnet name: private-1a**  
**Availability zone:** us-east-1a  
**IPv4 CIDR block:** 10.0.16.0/20

Don’t Enable auto-assign public IP for this private subnet as we don’t want that the resource that resides in this private subnet are exposed on the internet.

Now we have two subnets one Private and one Public.

**Internet Gateway:**

Now in order to enable our public subnet in the VPC, talk to the internet we want one more thing, the _internet gateway._ Choose internet gateway from the left pane and hit create internet gateway.

Give a suitable name to the internet gateway and hit create.
![[Pasted image 20250302095349.png]]
Now are internet gateway is successfully created.

Attach the internet gateway to the VPC in which we have our subnets.

Every VPC has a default route table and we can also create more route tables within a VPC.  
Head over to the routing table in the left pane and select the one which is associated with the VPC which consists of our subnets.

Create a route with the destination 0.0.0.0/0 and choose the internet gateway as the target.
![[Pasted image 20250302095843.png]]
⭐ The first route tells that if the resource in the subnet is trying to reach any IP within the range of 10.0.0.0/16, then route it locally because this IP range lies within our CIDR.

⭐ The second route tells that if the resource is trying to reach some destination with any other IP, route it via internet gateway.
## Create a Route table for private routes

Name the route table and add the associate it with our VPC.

![[Pasted image 20250302100058.png]]
Edit the subnet association and move the private subnet in the private route table.

Under explicit subnet association, we can see that we successfully associate the private subnet
![[Pasted image 20250302100159.png]]
## Create a Security group:

We will make two security groups one for our resources in public subnet and one for our resources in private subnet.

Here we are creating a security group for the resources in our public subnet.  
and we are allowing everyone to take ssh to our resource.
![[Pasted image 20250302100302.png]]
Create another security group for the resources in our private subnet. Here we are allowing only the resources in the public subnet to take ssh into our private subnet so that nobody can take ssh into the system directly from the internet.

Choose public security as a source so that only it can have inbound access to our private resources.
![[Pasted image 20250302100350.png]]
We have our default network ACLs in place.

We will not create a network ACLs in this tutorial, but remember that network ACLs rules follow precedence. Here the default network ACL have rule that allow all traffic with any protocol and any source to communicate with our subnet.
![[Pasted image 20250302100431.png]]

Now it’s time to check our network configuration, we will make two ec2 resources. One in public and another one in private subnet.  
Then from the ec2 instance in the public subnet we will take ssh into the ec2 in the private subnet.

But remember our the resource in the private subnet cannot talk to the internet because it doesn’t have the access to internet gateway, but what if we have to ping google.com from the resource in the private subnet ?

We have to configure a NAT gateway in order to give the access to our resources in private subnet to communicate with the internet.

But we will do that later ..

**ec2 creation**
![[Pasted image 20250302100556.png]]
Now repeat the same process for creating the second EC2 instance this time create it in the private subnet, because we had already created one in public subnet.

For the private subnet choose the private security group, as this instance will be launched in private subnet.

**Take ssh into public ec2-instance**

Here “key.pem” is the name of my permission file, make sure you are in the directory where your pem key resides and then hit this command.
```sh
$ ssh -i "key.pem" ec2-user@the-public-ip-of-ec2
```
Now form the public ec2 instance take ssh into the private ec2 instance. To make this ssh succesfull you need your permission key in public ec2. Just copy paste the pem file from your local computer to your public ec2.

then take ssh from the public instance into the private instance by following command:
```sh
$ ssh -i “key.pem” ec2-user@the-private-ip-of-ec2
```
Here in private ec2 you can see we can’t be able to talk to the internet from our private instance. for this we have to configure a NAT Gateway in the public subnet. So our request from the private subnet will then go to the NAT gateway in the public subnet and from there to the internet gateway.

## Create a NAT gateway

Make sure that you launch NAT gateway in public subnet, and allocate the elastic IP. Elastic IP is a static IP given by the AWS.
![[Pasted image 20250302100811.png]]

Now add a route to this NAT Gateway, in our private route table.

Here we have the default route that tells that if the resource in the subnet is trying to reach any ip with in the range of 10.0.0.0/16, then route it locally because this ip range lies within our CIDR. This rule allow ec2 in private subnet to talk to ec2 in public subnet. But it doesn’t know have route if it has to communicate with any resource on the internet, So..
.. So here we are adding a route that follow as: if the resource wants to communicate with any IP other than 10.0.0.0/16 it will go trough the NAT gateway.

![[Pasted image 20250302100924.png]]
🎉 Now you can see that the private ec2 instance can ping [www.google.com,](http://www.google.com,/) that tells that it can communicate with the resources on the internet.

A huge shout out to [Neal Davis](https://medium.com/u/dbd8e479f1a7?source=post_page---user_mention--fb88c9336e22---------------------------------------) for his amazing content on AWS VPC.
Heidel bot setup
![[Pasted image 20250414183457.png]]

------------------------------
[reddit-source](https://www.reddit.com/r/aws/comments/10oysxj/basics_of_aws_vpc_understanding_subnets_route/?rdt=53734)
## What is AWS VPC?

Amazon Virtual Private Cloud (VPC) is a virtual network allocated to your AWS account. If you are wondering what a virtual network is, it allows communication between computers, servers, or other devices. VPC allows you to start AWS resources like EC2(Server) in your virtual network.

>`TIP` VPC is basically an IP CIDR block that AWS allocates to your AWS account. 

While creating the AWS VPC, you just need to give inputs to the VPC name and IPv4 CIDR block for example **10.30.0.0/24**. There are some advanced configuration options as well but you don't need to worry about them for now.

For example, you have created VPC named **dev-vpc** with an IP range **10.0.0.0/24**

- VPC Name: **dev-vpc**
- IPV4 Range: **10.0.0.0/24**

Now, this IP range is allocated to your AWS account and nobody else can have the same IP range.
## What is Subnet?


> `TIP` A subnet is a set of IP addresses in your VPC. A subnet must be in a single availability zone. 

Availability Zones are distinct locations within the AWS Region. For example, one availability zone is **ap-south-1**: Asia Pacific.

To create a new Subnet, you need to first select the VPC from the VPC dropdown. Second, name your subnet, choose the availability zone and give IPV4 CIDR block. Please note that your IPV4 CIDR block must reside within the IP range of your selected VPC.

**Create public subnet**

- Choose VPC: **dev-vpc**
- Subnet name: **public-subnet-1**
- Availability Zone: **ap-south-1**
- IPV4 CIDR Block: **10.0.1.0/24**

**Create private subnet**

- Choose VPC: **dev-vpc**
- Subnet name: **private-subnet-1**
- Availability Zone: **ap-south-1**
- IPV4 CIDR Block: **10.0.2.0/24**

Once you create the subnet, resources within this subnet are not able to connect to the internet or route outbound traffic yet. There are 2 types of subnects.

1. Public subnet
2. Private subnet
## Difference between the public subnet and private subnet

If we talk in simple language, instances in the public subnet can send traffic to the outside world whereas instances in the private subnet can't.

Now you must be wondering how we define/identify public and private subnets. To understand it better, let's come back to the subnet we created named **public-subnet-1**. I have named it "**public**" but it is not public yet.

To understand between the public subnet and private subnet, let's understand the Route table, Internet gateway, and NAT gateway

> _**Route Table:**_ _It is used to do routing decisions. It contains existing routes to CIDR blocks outside of the ranges in your VPC. For example, it controls routing to Internet gateways, NAT gateways_
> 
> _**Internet Gateway:**_ _It is a component that allows communication between VPC and internet. If your VPC doesn't have an internet gateway, resources within your VPC can't be accessed from the internet. For example, a website deployed to one of your EC2 servers._
> 
> _**NAT Gateway:**_ _A Network Address Translation (NAT) allows instances in your private subnet to connect to outside services like Databases but restricts external services to connecting to these instances._

One key thing to note while creating NAT Gateway is that **"You must create NAT gateway in a public subnet so that other resources within the same VPC can communicate internally"**

You just need to give a name to the route table and create. Once the route table is created, you can select that route table, and add routes to it. For example:

**RTB-Public:** A route table with a target to Internet gateway is a public route table.

**RTB-Private:** A route table with a target to NAT gateway is a private route table.

Now, let's come to the difference between public and private subnets.

> _**A subnet which is connected to**_ _**Public route table**_ _**is**_ _**Public subnet**_ _**since the resources under that subnet can route outbound traffic to internet and outside services**_ _**can also connect**_ _**to these instances.**_

_A subnet which is_ _**connected to**_ _**Private route table**_ _is_ _**Private subnet**_ _since the resources under that subnet can route outbound traffic to internet but outside services_ _can't connect_ _to these instances._

Create an Internet Gateway named "**igw-dev**".

Create the NAT Gateway named "**nat-dev**" under one of the public subnets.

Choose route table **RTB-Public,** select **Routes** tab, and select **Add Route**. Under the Target, select the internet gateway named "**igw-dev**"

Choose route table **RTB-Private,** select **Routes** tab, and select **Add Route**. Under the Target, select the NAT gateway named "**nat-dev**"

Now, both public and private route tables are ready. We can assign subnets to these route tables.

- Select route table **RTB-Public** again. Select the "Subnet associations" tab and click "Edit subnet associations". There check "public-subnet-1" and click "Save associations"
    
- Select route table **RTB-Private** again. Select the "Subnet associations" tab and click "Edit subnet associations". There check "private-subnet-1" and click "Save associations"
    

Now, you have successfully created VPC, Subnets (Public & Private), Internet gateway, NAT gateway, Route tables and associations between Route table to Subnets.

It is important to use security groups and network access control lists(ACLs) to control inbound and outbound traffic to your resources. This can help increase the security of your VPC by only allowing the necessary traffic to reach your resources while blocking all other traffic.

> _**One tip for using AWS subnets is to use different subnets for different types of resources and different levels of trust. For example, you can use one subnet for public-facing resources such as a web server, and another subnet for private resources such as a database.**_

I will cover more details in an upcoming blog. Stay tuned!

---------------
`Prompt` : Am learning AWS cloud, trying to understand networking concepts
but am confused to find difference between below topics

1.VPC
2.subnet
3.Internet gate way
4.Route table
5.Security Group
6.NAT
7.Network ACL


1. **VPC (Virtual Private Cloud)**:
    
    - A VPC is a virtual network dedicated to your AWS account. It is logically isolated from other virtual networks in the AWS cloud. You can launch AWS resources, such as EC2 instances, into your VPC.
    - Think of it as your own private network in the cloud.
2. **Subnet**:
    
    - A subnet is a range of IP addresses in your VPC. You can launch AWS resources into a specified subnet.
    - Subnets can be public (accessible from the internet) or private (not accessible from the internet).
3. **Internet Gateway**:
    
    - An Internet Gateway is a horizontally scaled, redundant, and highly available VPC component that allows communication between instances in your VPC and the internet.
    - It serves as a target in your VPC route tables for internet-routable traffic.
4. **Route Table**:
    
    - A route table contains a set of rules, called routes, that are used to determine where network traffic is directed.
    - Each subnet in your VPC must be associated with a route table, which controls the routing for the subnet.
5. **Security Group**:
    
    - A security group acts as a virtual firewall for your instance to control inbound and outbound traffic.
    - Security groups are stateful, meaning if you allow an incoming request from an IP, the response is automatically allowed.
6. **NAT (Network Address Translation)**:
    
    - A NAT Gateway or NAT Instance enables instances in a private subnet to connect to the internet or other AWS services, but prevents the internet from initiating connections with those instances.
    - It allows outbound traffic to the internet while keeping the instances secure from inbound traffic.
7. **Network ACL (Access Control List)**:
    
    - A Network ACL is an optional layer of security for your VPC that acts as a firewall for controlling traffic in and out of one or more subnets.
    - Network ACLs are stateless, meaning you need to explicitly allow both inbound and outbound traffic.

### Summary

- **VPC**: Your private network in AWS.
- **Subnet**: A segment of your VPC's IP address range where you can place groups of isolated resources.
- **Internet Gateway**: Allows your VPC to connect to the internet.
- **Route Table**: Determines how traffic is directed within your VPC.
- **Security Group**: Controls inbound and outbound traffic to your instances (stateful).
- **NAT**: Allows private subnet instances to access the internet without exposing them to inbound internet traffic.
- **Network ACL**: Controls inbound and outbound traffic at the subnet level (stateless).

####  `Prompt` : What are the differences between an Internet Gateway and a NAT Gateway in AWS networking?
1. **Purpose**:
    
    - **Internet Gateway**: Allows instances in a VPC to connect to the internet and allows the internet to connect to instances in the VPC. It is used for instances that need to be accessible from the internet.
    - **NAT Gateway**: Allows instances in a private subnet to connect to the internet or other AWS services, but prevents the internet from initiating connections with those instances. It is used to provide internet access to instances in private subnets without exposing them to inbound internet traffic.
2. **Accessibility**:
    
    - **Internet Gateway**: Provides both inbound and outbound internet access. Instances with a public IP address can be accessed from the internet.
    - **NAT Gateway**: Provides only outbound internet access. Instances in private subnets can initiate outbound connections to the internet, but cannot receive inbound connections initiated from the internet.
3. **Placement**:
    
    - **Internet Gateway**: Attached directly to the VPC. It is a VPC-wide resource.
    - **NAT Gateway**: Deployed in a specific public subnet within the VPC. It requires an Elastic IP address.
4. **Routing**:
    
    - **Internet Gateway**: Requires a route in the route table that directs internet-bound traffic (0.0.0.0/0) to the Internet Gateway.
    - **NAT Gateway**: Requires a route in the private subnet's route table that directs internet-bound traffic (0.0.0.0/0) to the NAT Gateway.
5. **Security**:
    
    - **Internet Gateway**: Instances must have public IP addresses and appropriate security group rules to allow inbound traffic from the internet.
    - **NAT Gateway**: Instances in private subnets do not need public IP addresses. Security groups and Network ACLs can be used to control outbound traffic.
6. **Use Case**:
    
    - **Internet Gateway**: Used for instances that need to be publicly accessible, such as web servers.
    - **NAT Gateway**: Used for instances that need to access the internet for updates or other outbound connections but should not be directly accessible from the internet, such as database servers or application servers.

### Summary

- **Internet Gateway**: Enables both inbound and outbound internet access for instances with public IP addresses.
- **NAT Gateway**: Enables outbound internet access for instances in private subnets without exposing them to inbound internet traffic.

#### Differences between Security Groups and Network ACLs in AWS

1. **Level of Operation**:
    
    - **Security Group**: Operates at the instance level. It acts as a virtual firewall for controlling inbound and outbound traffic to and from AWS resources like EC2 instances.
    - **Network ACL (Access Control List)**: Operates at the subnet level. It controls traffic in and out of one or more subnets.
2. **Statefulness**:
    
    - **Security Group**: Stateful. This means that if you allow an incoming request from an IP, the response is automatically allowed, regardless of outbound rules.
    - **Network ACL**: Stateless. This means that you must explicitly allow both inbound and outbound traffic. Responses to allowed inbound traffic are not automatically allowed.
3. **Rules**:
    
    - **Security Group**: Supports only allow rules. You cannot create deny rules.
    - **Network ACL**: Supports both allow and deny rules. You can explicitly deny traffic.
4. **Default Behavior**:
    
    - **Security Group**: By default, all inbound traffic is denied, and all outbound traffic is allowed.
    - **Network ACL**: By default, all inbound and outbound traffic is allowed.
5. **Evaluation Order**:
    
    - **Security Group**: All rules are evaluated before deciding whether to allow traffic. There is no priority order.
    - **Network ACL**: Rules are evaluated in numerical order, starting with the lowest numbered rule. The first rule that matches the traffic determines whether it is allowed or denied.
6. **Application**:
    
    - **Security Group**: Applied to individual instances within a VPC. You can assign multiple security groups to an instance.
    - **Network ACL**: Applied to subnets within a VPC. All instances within a subnet are subject to the rules of the associated Network ACL.
7. **Use Case**:
    
    - **Security Group**: Used to control traffic to and from specific instances. Ideal for instance-level security.
    - **Network ACL**: Used to control traffic to and from subnets. Ideal for subnet-level security and additional layer of defense.

### Summary

- **Security Group**: Instance-level, stateful, supports only allow rules, default denies inbound and allows outbound, no rule order.
- **Network ACL**: Subnet-level, stateless, supports allow and deny rules, default allows both inbound and outbound, rules evaluated in order.

#### realtime scenarios where all these networking concepts can be used with examples
### 1. VPC (Virtual Private Cloud)

**Scenario**: Hosting a multi-tier web application. **Example**: You create a VPC to host your web application. The VPC isolates your application from other AWS customers. You can create subnets within the VPC to separate different parts of your application, such as web servers, application servers, and databases.

### 2. Subnet

**Scenario**: Segregating public and private resources. **Example**: You create a public subnet for your web servers that need to be accessible from the internet and a private subnet for your database servers that should not be accessible from the internet. This ensures that your database servers are secure and only accessible from the web servers.

### 3. Internet Gateway

**Scenario**: Allowing internet access to your web servers. **Example**: You attach an Internet Gateway to your VPC and update the route table for your public subnet to route internet-bound traffic to the Internet Gateway. This allows your web servers in the public subnet to communicate with the internet.

### 4. Route Table

**Scenario**: Directing traffic within your VPC. **Example**: You create a route table for your private subnet that routes internet-bound traffic to a NAT Gateway. This allows instances in the private subnet to access the internet for updates or other outbound connections while keeping them secure from inbound internet traffic.

### 5. Security Group

**Scenario**: Controlling access to your instances. **Example**: You create a security group for your web servers that allows inbound HTTP and HTTPS traffic from the internet and another security group for your database servers that only allows inbound traffic from the web servers. This ensures that only the web servers can communicate with the database servers.

### 6. NAT (Network Address Translation)

**Scenario**: Allowing private instances to access the internet. **Example**: You deploy a NAT Gateway in a public subnet and update the route table for your private subnet to route internet-bound traffic to the NAT Gateway. This allows instances in the private subnet to download updates or access other AWS services without exposing them to inbound internet traffic.

### 7. Network ACL (Access Control List)

**Scenario**: Adding an additional layer of security at the subnet level. **Example**: You create a Network ACL for your public subnet that allows inbound HTTP and HTTPS traffic and denies all other inbound traffic. You also create a Network ACL for your private subnet that allows inbound traffic only from the public subnet. This provides an additional layer of security by controlling traffic at the subnet level.

### Example Scenario: Hosting a Secure Web Application

1. **VPC**: Create a VPC to host your web application.
2. **Subnets**: Create a public subnet for web servers and a private subnet for database servers.
3. **Internet Gateway**: Attach an Internet Gateway to the VPC and update the route table for the public subnet to route internet-bound traffic to the Internet Gateway.
4. **Route Table**: Update the route table for the private subnet to route internet-bound traffic to a NAT Gateway.
5. **Security Groups**: Create security groups to allow inbound HTTP/HTTPS traffic to web servers and restrict database server access to only web servers.
6. **NAT Gateway**: Deploy a NAT Gateway in the public subnet to allow instances in the private subnet to access the internet.
7. **Network ACLs**: Create Network ACLs to add an additional layer of security by controlling traffic at the subnet level.

This setup ensures that your web servers are accessible from the internet, your database servers are secure, and your instances can access the internet for updates without being exposed to inbound internet traffic.

### Use Case: Hosting a Secure, Scalable Web Application

#### Requirements:

1. The web application should be accessible from the internet.
2. The application should have a multi-tier architecture with web servers in a public subnet and application/database servers in a private subnet.
3. The application servers should be able to access the internet for updates.
4. Security should be enforced at both the instance and subnet levels.

### Step-by-Step Design:

#### 1. Create a VPC

- **VPC**: Create a VPC with a CIDR block, e.g., `10.0.0.0/16`.

#### 2. Create Subnets

- **Public Subnet**: Create a public subnet within the VPC, e.g., `10.0.1.0/24`, for web servers.
- **Private Subnet**: Create a private subnet within the VPC, e.g., `10.0.2.0/24`, for application and database servers.

#### 3. Attach an Internet Gateway

- **Internet Gateway**: Attach an Internet Gateway to the VPC to allow internet access.

#### 4. Create Route Tables

- **Public Route Table**: Create a route table for the public subnet and add a route to the Internet Gateway for internet-bound traffic (`0.0.0.0/0`).
- **Private Route Table**: Create a route table for the private subnet and add a route to the NAT Gateway for internet-bound traffic (`0.0.0.0/0`).

#### 5. Deploy a NAT Gateway

- **NAT Gateway**: Deploy a NAT Gateway in the public subnet with an Elastic IP address to allow instances in the private subnet to access the internet.

#### 6. Configure Security Groups

- **Web Server Security Group**: Create a security group for web servers that allows inbound HTTP (port 80) and HTTPS (port 443) traffic from the internet and allows outbound traffic to any destination.
- **Application Server Security Group**: Create a security group for application servers that allows inbound traffic only from the web server security group and allows outbound traffic to any destination.
- **Database Server Security Group**: Create a security group for database servers that allows inbound traffic only from the application server security group and allows outbound traffic to any destination.

#### 7. Configure Network ACLs

- **Public Subnet NACL**: Create a Network ACL for the public subnet that allows inbound HTTP and HTTPS traffic and denies all other inbound traffic. Allow all outbound traffic.
- **Private Subnet NACL**: Create a Network ACL for the private subnet that allows inbound traffic only from the public subnet and allows all outbound traffic.

### Example Scenario Implementation

1. Create a VPC with CIDR block 10.0.0.0/16.
2. Create a public subnet with CIDR block 10.0.1.0/24.
3. Create a private subnet with CIDR block 10.0.2.0/24.
4. Attach an Internet Gateway to the VPC.
5. Create a route table for the public subnet:
   - Add a route to the Internet Gateway for 0.0.0.0/0.
6. Create a route table for the private subnet:
   - Add a route to the NAT Gateway for 0.0.0.0/0.
7. Deploy a NAT Gateway in the public subnet with an Elastic IP
8. Create security groups:
- Web Server Security Group: Allow inbound HTTP (80) and HTTPS (443) from 0.0.0.0/0, allow all outbound.
 - Application Server Security Group: Allow inbound from Web Server Security Group, allow all outbound.

- Database Server Security Group: Allow inbound from Application Server Security Group, allow all outbound.

9. Create Network ACLs:
- Public Subnet NACL: Allow inbound HTTP (80) and HTTPS (443), deny all other inbound, allow all outbound.

- Private Subnet NACL: Allow inbound from public subnet, allow all outbound.

### Summary

This setup ensures that:

- Web servers in the public subnet are accessible from the internet.
- Application and database servers in the private subnet are not directly accessible from the internet.
- Instances in the private subnet can access the internet for updates via the NAT Gateway.
- Security is enforced at both the instance level (using security groups) and the subnet level (using network ACLs).

This holistic approach provides a secure, scalable, and well-architected solution for hosting a web application on AWS.


#### `Prompt`: can we have a public subnet without nat gateway as natgate way is not free of cost

Yes, you can have a public subnet without a NAT Gateway. A NAT Gateway is typically used to allow instances in a private subnet to access the internet while keeping them inaccessible from the internet. However, if you only need a public subnet where instances can directly access the internet and be accessed from the internet, you don't need a NAT Gateway.

### Scenario: Public Subnet Without NAT Gateway

#### Requirements:

1. Instances in the public subnet should be accessible from the internet.
2. Instances in the public subnet should be able to access the internet.

### Step-by-Step Design:

#### 1. Create a VPC

- **VPC**: Create a VPC with a CIDR block, e.g., `10.0.0.0/16`.

#### 2. Create a Public Subnet

- **Public Subnet**: Create a public subnet within the VPC, e.g., `10.0.1.0/24`.

#### 3. Attach an Internet Gateway

- **Internet Gateway**: Attach an Internet Gateway to the VPC to allow internet access.

#### 4. Create a Route Table

- **Public Route Table**: Create a route table for the public subnet and add a route to the Internet Gateway for internet-bound traffic (`0.0.0.0/0`).

#### 5. Configure Security Groups

- **Public Subnet Security Group**: Create a security group for instances in the public subnet that allows inbound HTTP (port 80) and HTTPS (port 443) traffic from the internet and allows outbound traffic to any destination.

### Example Scenario Implementation

1. Create a VPC with CIDR block 10.0.0.0/16.
2. Create a public subnet with CIDR block 10.0.1.0/24.
3. Attach an Internet Gateway to the VPC.
4. Create a route table for the public subnet:
   - Add a route to the Internet Gateway for 0.0.0.0/0.
5. Create a security group:
   - Allow inbound HTTP (80) and HTTPS (443) from 0.0.0.0/0.
   - Allow all outbound traffic.
### Summary
This setup ensures that:

- Instances in the public subnet are accessible from the internet.
- Instances in the public subnet can access the internet.

By not using a NAT Gateway, you save on costs, but keep in mind that instances in the public subnet are directly exposed to the internet, so you should ensure they are properly secured.

### `Prompt` Security Groups and Network ACLs in AWS
#### Security Groups

Security Groups act as virtual firewalls for your instances to control inbound and outbound traffic. They operate at the instance level.

#### Network ACLs (NACLs)

Network ACLs act as a firewall for controlling traffic in and out of one or more subnets. They operate at the subnet level.

### Use Cases and Examples

#### Example Scenario

You have a VPC with a public subnet and a private subnet. You want to:

1. Allow HTTP and SSH traffic to instances in the public subnet.
2. Allow instances in the private subnet to access the internet for updates (e.g., via a NAT Gateway or other means).
3. Restrict all other traffic.

### Step-by-Step Configuration

#### 1. Create Security Groups

##### Public Subnet Security Group

- **Inbound Rules**:
    
    - Allow HTTP (port 80) from anywhere (`0.0.0.0/0`).
    - Allow HTTPS (port 443) from anywhere (`0.0.0.0/0`).
    - Allow SSH (port 22) from your IP (e.g., `203.0.113.0/24`).
- **Outbound Rules**:
    - Allow all outbound traffic.

Inbound Rules:

- Type: HTTP, Protocol: TCP, Port Range: 80, Source: 0.0.0.0/0
- Type: HTTPS, Protocol: TCP, Port Range: 443, Source: 0.0.0.0/0
- Type: SSH, Protocol: TCP, Port Range: 22, Source: 203.0.113.0/24

Outbound Rules:

- Type: All traffic, Protocol: All, Port Range: All, Destination: 0.0.0.0/0

##### Private Subnet Security Group

- **Inbound Rules**:
    - Allow all traffic from the public subnet security group.
- **Outbound Rules**:
    - Allow all outbound traffic.

Inbound Rules:

- Type: All traffic, Protocol: All, Port Range: All, Source: Public Subnet Security Group

Outbound Rules:

- Type: All traffic, Protocol: All, Port Range: All, Destination: 0.0.0.0/0

#### 2. Create Network ACLs

##### Public Subnet NACL

- **Inbound Rules**:
    - Allow HTTP (port 80) from anywhere (`0.0.0.0/0`).
    - Allow HTTPS (port 443) from anywhere (`0.0.0.0/0`).
    - Allow SSH (port 22) from your IP (e.g., `203.0.113.0/24`).
    - Allow ephemeral ports (1024-65535) for return traffic.
- **Outbound Rules**:
    
    - Allow all outbound traffic.

Inbound Rules:

- Rule #: 100, Type: HTTP, Protocol: TCP, Port Range: 80, Source: 0.0.0.0/0, Allow
- Rule #: 110, Type: HTTPS, Protocol: TCP, Port Range: 443, Source: 0.0.0.0/0, Allow
- Rule #: 120, Type: SSH, Protocol: TCP, Port Range: 22, Source: 203.0.113.0/24, Allow
- Rule #: 130, Type: Ephemeral, Protocol: TCP, Port Range: 1024-65535, Source: 0.0.0.0/0, Allow

Outbound Rules:
- Rule #: 100, Type: All traffic, Protocol: All, Port Range: All, Destination: 0.0.0.0/0, Allow
##### Private Subnet NACL

- **Inbound Rules**:
    - Allow all traffic from the public subnet.
    - Allow ephemeral ports (1024-65535) for return traffic.
- **Outbound Rules**:
    - Allow all outbound traffic.

Inbound Rules:

- Rule #: 100, Type: All traffic, Protocol: All, Port Range: All, Source: Public Subnet CIDR, Allow
- Rule #: 110, Type: Ephemeral, Protocol: TCP, Port Range: 1024-65535, Source: 0.0.0.0/0, Allow

Outbound Rules:
- Rule #: 100, Type: All traffic, Protocol: All, Port Range: All, Destination: 0.0.0.0/0, Allow
### Summary

- **Security Groups**: Control traffic at the instance level. Use them to define what traffic is allowed to and from your instances.
- **Network ACLs**: Control traffic at the subnet level. Use them to provide an additional layer of security for your subnets.

By configuring both Security Groups and Network ACLs, you can ensure a robust security posture for your AWS environment.

#### `Prompt`: How can I configure a NAT gateway/with instance port forwarding to expose an HTTP service in a private subnet?

To configure a NAT Gateway or NAT Instance with port forwarding to expose an HTTP service in a private subnet, follow these steps:

### Using a NAT Gateway

1. **Create a NAT Gateway**:
    
    - Go to the VPC Dashboard.
    - Select "NAT Gateways" and create a new NAT Gateway.
    - Choose a public subnet for the NAT Gateway.
    - Allocate an Elastic IP address to the NAT Gateway.
2. **Update Route Tables**:
    
    - Go to the "Route Tables" section in the VPC Dashboard.
    - Select the route table associated with your private subnet.
    - Add a route to direct all internet-bound traffic (0.0.0.0/0) to the NAT Gateway.
3. **Configure Security Groups**:
    
    - Ensure the security group associated with your private instances allows inbound HTTP/HTTPS traffic from the NAT Gateway.

### Using a NAT Instance with Port Forwarding

1. **Launch a NAT Instance**:
    
    - Launch an EC2 instance in a public subnet to act as the NAT Instance.
    - Choose an Amazon Linux AMI or any other suitable AMI.
    - Assign an Elastic IP to the NAT Instance.
2. **Configure the NAT Instance**:
    
    - Enable IP forwarding on the NAT Instance:
        
        sudo sysctl -w net.ipv4.ip_forward=1
        
    - Add the following to `/etc/sysctl.conf` to make the change persistent:
        
        net.ipv4.ip_forward = 1
        
    - Configure iptables to handle port forwarding:
    - ``` sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination <private-instance-ip>:80```
		```sudo iptables -t nat -A POSTROUTING -j MASQUERADE ```


1. **Update Route Tables**:
    
    - Go to the "Route Tables" section in the VPC Dashboard.
    - Select the route table associated with your private subnet.
    - Add a route to direct all internet-bound traffic (0.0.0.0/0) to the NAT Instance.
4. **Configure Security Groups**:
    
    - Ensure the security group associated with the NAT Instance allows inbound HTTP/HTTPS traffic from the internet.
    - Ensure the security group associated with your private instances allows inbound HTTP/HTTPS traffic from the NAT Instance.

### Example Commands for NAT Instance Configuration

1. **Enable IP Forwarding**:
    
    sudo sysctl -w net.ipv4.ip_forward=1
    
    echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
    
2. **Configure iptables for Port Forwarding**:
    
    sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination \<private-instance-ip\>:80
    
    sudo iptables -t nat -A POSTROUTING -j MASQUERADE
### Summary
- **NAT Gateway**: Create a NAT Gateway, update route tables, and configure security groups.
- **NAT Instance**: Launch a NAT Instance, enable IP forwarding, configure iptables for port forwarding, update route tables, and 

#### `Prompt` How can I configure a reverse proxy to expose an HTTP service in a private subnet of AWS?

To configure a reverse proxy to expose an HTTP service in a private subnet of AWS, you can use an EC2 instance in a public subnet running a reverse proxy server like Nginx or Apache. Here are the steps to achieve this:
### Step-by-Step Plan

1. **Create a VPC**:
    - Ensure you have a VPC with both public and private subnets.
2. **Launch EC2 Instances**:
    - Launch your HTTP service EC2 instances in the private subnet.
    - Launch a reverse proxy EC2 instance in the public subnet.
3. **Install and Configure Reverse Proxy**:
    - Install Nginx or Apache on the reverse proxy EC2 instance.
    - Configure the reverse proxy to forward traffic to the HTTP service instances in the private subnet.
4. **Configure Security Groups**:
    - Ensure the security group for the reverse proxy allows inbound traffic on the necessary ports (e.g., port 80 for HTTP).
    - Ensure the security group for the HTTP service instances allows inbound traffic from the reverse proxy.
5. **Route53 Configuration (Optional)**:
    - If you want to use a custom domain, configure Route53 to route traffic to the reverse proxy.

### Detailed Steps

1. **Create a VPC with Public and Private Subnets**:
    - Use the VPC wizard in the AWS Management Console to create a VPC with both public and private subnets.
2. **Launch EC2 Instances**:
    - Launch your HTTP service EC2 instances in the private subnet and ensure your HTTP service is running on these instances.
    - Launch a reverse proxy EC2 instance in the public subnet.
3. **Install and Configure Reverse Proxy**:
    - SSH into the reverse proxy EC2 instance.
    - Install Nginx or Apache. For example, to install Nginx:
     ```sh
	     sudo apt update
         sudo apt install nginx
		```
    - Configure Nginx to forward traffic to the HTTP service instances. Edit the Nginx configuration file (e.g., `/etc/nginx/sites-available/default`):
```
      server {
    listen 80;

    location / {
        proxy_pass http://<private-subnet-instance-private-ip>:<port>;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

    - Restart Nginx to apply the changes:
        
        sudo systemctl restart nginx
        
4. **Configure Security Groups**:
    
    - For the reverse proxy security group, allow inbound traffic on port 80 (HTTP) or port 443 (HTTPS).
    - For the HTTP service instances' security group, allow inbound traffic from the reverse proxy security group.
5. **Route53 Configuration (Optional)**:
    
    - If you have a custom domain, create an A record in Route53 pointing to the reverse proxy's public IP address.

### Example Configuration

#### Security Group for Reverse Proxy

```
Inbound Rules:
- Type: HTTP
  Protocol: TCP
  Port Range: 80
  Source: 0.0.0.0/0

- Type: HTTPS
  Protocol: TCP
  Port Range: 443
  Source: 0.0.0.0/0
```

#### Security Group for HTTP Service Instances

```
Inbound Rules:
- Type: Custom TCP
  Protocol: TCP
  Port Range: 80
  Source: sg-<Reverse-Proxy-Security-Group-ID>
```

### Summary

By following these steps, you can expose an HTTP service running in a private subnet of AWS using a reverse proxy in a public subnet. This setup ensures that your HTTP service instances remain private while the reverse proxy handles incoming traffic from the internet.