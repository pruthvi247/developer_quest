[Source : https://www.udemy.com/course/introduction-to-computer-networks/]
OSI Layer:
layer 3 = Router -> uses ip address
layer 2 = switch -> uses mac address
layer 1 = Hub -> 		

 > modem: Modems modulate one signal to another,such as analog to digital.(lan -> wifi)

Two types of firewalls
> Networkbase (hardware)
> host-based (software)

types of firewalls

Packet filtering firewalls:
> Basic filtering rules -> black listing and white listing based on ip address

Circuit-level firewalls:
> monitor valid/invalid TCP sessions

Application Layer 7 (NGFW next generation fire wall)


DHCP Dynamic Host Configuration Protocol:
> Automatically assigns IP address to hosts
> An alternative is Static IP addressing


> Base band means digital signals

Example application layer protocols

E-Mail - IDAP4,POP3, SMTP
Web Browser - HTTP,HTTPS
Remote Access - SSH,Telnet

application layer - Data
presentation layer - Data
session layer - Data
transport Layer - Segment

Network layer - packet
Data layer - Frame
Physical layer - bit


layer 6 - presentation layer

Web browser - xml ,html,javascript
graphics Files - jpeg,gif,png
Audio/video - MPEG,mp3
Encryption: TLS,ssl
Text/Data : ASCII,EBCDIC

Layer 5 - session layer:
> Responsible for setting up, managing and then tearing down sessions between network devices.
> Ensure data from different application session are kept separate
> Coordinates communication between system

Layer 4 - transport layer

> ensures data is delivered error free and in sequence
> segments data and reassembles correctly
> TCP and UDP

> Application layer can use tcp or udp protocols for communication

Layer 3 - Network layer
> Routing layer
> Provides logical addressing (ip addressing)
> places two ip addresses into a packet
	>source address and destination address
> Types of packets at network layer:
	Data Packets - ipv4,ipv6
	Rout-update packets(path determinaion) - RIP,ospf,eigrp etc..
Layer 3 devices : Routers and multilayer switches,ipv4,ipv6

Layer 2 - Data link layer:

> The switching layer
> Ensures that messages are delivered to the proper device on a LAN using hardware addresses
	> mac address
	> only concerned with local delivery of frames on the same network
> Responsible for packaging the data into frames for the physical layer

Datalink layer has two layers
	> logical link control - llc layer
	> Media Access Control - MAC layer

Layer 1 - Physical layer
> Defines the physical and electrical medium for network communication

ARP - Address resolution Protocol

> ip address to MAC address
> vise versa to ARP is RARP

properties of IP:
> its connection less and there fore unreliable
	> no continued connection
> Each packet sent is independent of each other packet
	> TCPP AND OTHER protocols provide a means to reassemble them properly
> Packets dont always follow the sam path to thier destination
	> they are sent via most efficient route
> Doesnt provide any error recovery or sequencing funtionality

Internet control message protocol - commonly used by IT adminstrators to trouble shoot network connections with command line utilities, including ping, traceroute...

Section 11:

understanding protocols,ports and sockets
Management Protocols:
---------------------
Sockets: sockets are a combination of an ip address and port number.

TCP Reliability:

TCP utilizes the following features to ensure reliable delivery of data.

3-way handshake: Creates a virtual connection between the source and destination before data is sent
Acknowledgement: is required before the next segment is sent
Checksum : that detects corrupted data
Sequence Numbers: That detects missing data and reassembles them in correct order.
Retransmission : That will retransmits lost of corrupt data

Note: TCP header is 20 bytes in size, where as the udp header is only 8 bytes


Domain name system protocol - DNS

port: 53 Transport layer protocol : UDP

> protocol is used to resolve a domain name to its corresponding IP address
	> hoop.com -> 55.77.45.78
> Uses TCP port 53 by default
> 

Dynamic host configuration protocol
port : 67,68 Transport layer protocol : UDP

> protocol that automatically assigns ip address configuration to devices on a network
	- ip address
	- subnet mask
	- Default Gateway
	- DNS server

Network Time Protocol - NTP
port: 123 Transport Layer Protocol : TCP

> This protocol automatically synchronizes a system's time with a network time server
	- Important for time-dependent network applications and protocols
	- Authentication will oftern fail if time isn't properly synchronized between devices

Simple Network Management Protocol -SNMP
port: 161 Transport Layer Protocol: TCP
>Protocol used to monitor and manage network devices
>Allows admins to monitor and manage network devices and traffic
>Allows network devices to communicate information about their state
	> memory
	> CPU
	> Bandwidth
Light Weight Directory Acess Protocol - LDAP
port 389 Transport Layer Protocol: TCP
LDAPS - Ldap secure
> Protocol that provides a means to acces and query directory service systems:
	> Usernames,Passwords,Computer Accounts,etc..
> A secure version of LDAP that utilizes SSL to encrypt LDAP network traffic
> uses port 636

Remote communicaton Protocols:
-----------------------------
Application layer remote communication protocols:
	Telnet
	SecureShell-ssh
	Remote Desktop protocol

Telnet:
port: 23 Transport layer protocol: TCP
> legacy protocol is insecure and is legacy, it sends data in plain text
> Today it's primarily used to access managed network devices, such as router via a serial connection, We dont use it over the network

SecureShell -ssh:
port: 22 Trnasport layer Protocol: TCP
> A cryptographic protocol that's used to securely connect to a remote host
> Encrypts data with public key infrastructure (PKI), making it secure

Remote Desktop Protocol:
Port: 3389 Transport Layer Protocol: TCP
> A microsoft protocol to control remote desktop graphically.

File Transfer Protocols: 
----------------------
Application layer file transfer protocols
	File transfer protocol - FTP
	Secure Rile Transfer Protocol - SFTP
	Trivial File Transfer Protocol - TFTP

File Transfer Protocol - FTP
port: 20,21 Transport Layer Protocol: TCP

> Legacy protocol user to transfer files between systems
> Data transfered in clear text, so its considered insecure
> port 20 for data transfer
> port 21 for control commands

Secure file transfer protocol - SFTP
port:22 Transport Layer Protocol: TCP
> Cyptographic version of FTP that uses SSh to provide encryption services

Trivial File Transfer Protocol - TFTP
Port: 69 Transport Layer Protocol: UDP

> A bare-bones version of FTP user for simple downloads
	-  Doesnt support authentication
	- Doesnt support directory navigation
> often used to transfer software images for routers and switches during upgrades

Email Protocols:
--------------
> Simple mail transfer protocol - smtp
> Post Office protocol version 3 - POP3
> Internet message access protocol -IMAP


Simple Mail Transfer Protocol - SMTP
port: 25 Transfer Layer Protocol: TCP

> Can be configure to use encyption or plain text
> this is used to deliver emails from an email client (outlook)to a destination email server,This protocol will not deliver to end user.

Post Office Protocol V3
port: 110 Transport Layer Protocol: TCP

> This is used to retrieve mails form an email server, That is end user receives emails from server
> can be used to encrypt or plain text

Iternaet Message Access Protocol:
port:143 Transport Layer Protocol: TCP

> Popular when a user access email form multiple different devices
> Allows users to ascess mail on servers and either read the email on the server or download the email to client machine
> Web-based email clients,such as gmail, use IMAP


Web Browser Application Protocols:
	Http
	Https
	
Hpertext Transfer Protocol - Http:
port: 80 Transport layer protocol: TCP

> Requests are made in hypertext markup language(html) and returned to your browser in that format
> Data is sent in plain text

HTTPS:
port: 443 Transport Layer Protocol: TCP

> http over secure layer(SSL) or Transport layer security (TLS)
> utilizes public key infrastructure(PKI)

Section 13 - understanding ipv4

ipv4 - 32 bits -> 4*8

> Each device on a network is assigned an ip address, subnetmask and default gateway

	ipaddress: unique logical address assigned to each device on a network
	subnet mask: used by the device to determine what subnet it's on,specifically the network and host portions of the ip
	default gateway: The ip address of a network's router that allows devices on the local network to communicate with 				other networks 

ipv4 address classes :

Class		Networks bits 			Host bits 			Address RAnge
 
A		   8				 24 				1.0.0.0 - 126.255.255.255
B		   16   			 16 				128.0.0.0 - 191.255.255.255
C 		   24 				 8 				192.0.0.0 - 223.255.255.255

Subnet mask:
> The subnet mask tells you which portion of the ip address identifies the network and which portion identifies the host.

Class 
A 		11111111 (255-network)      00000000(HOST)        	00000000(HOST)       		0000000(HOST)
ip 		  10						      0.						0.						15

B		11111111 (255-network)     11111111 (255-network)	 00000000(HOST) 			00000000(HOST) 
ip 			172.						16.						0.							110

c		11111111 (255-network)     11111111 (255-network)	 11111111 (255-network) 	00000000(HOST) 
ip 			192.						168.						1.							50
CIDR Notation:

A methodology for subnettng
> Slash - notation tells you how many bits are associated with the subnet mask


A short way of telling us what the subnet mask is 
 	/8 = 11111111.00000000.00000000.00000000
	/8 = 255.0.0.0
> x.x.x.x/24 = 255.255.255.0
> x.x.x.x/16 = 255.255.0.0
> x.x.x.x/25 = 255.255.255.x

Public vs private ip addresss:


ipv4 and ipv6:

> when both ipv4 and ipv6 protocols co exist with in an operating system

Tunneling:

> Tunneling is when we encapsulate ipv4 into ipv6 data and vice versa:

	4to6 - encapsulates ipv4 data into an ipv6 tunnel
	6in4 - encapsulates ipv6 data into an ipv4 tunnel and can traverse ipv4 NAT
	teredo - microsoft windows ipv6 tunneling protocol similar to 6in4 that supports NAT
	miredo - A Linux and Unix based open source version of teredo

Sec 17 - static and dynamic address:

Static :
> ip address is manually configured
> commonly used :
	DNS Server
	Web server
	Network Printers
	Default GateWay (Router)

Dynamic :
> ip Address is dynamically confgured
	DHCP Server
	APIPA - Automatic private ip addressing
	Stateless Auto-configuration
> commonly used for end user devices that don't require a static IP address


DHCP - DORA process
> D - Discover,O- offer, R- Request, A- Acknowledgement

Section 18 - DNS fundamentals:

> DNS provides tcp/IP name resolution services, which is the process of translating host and domain names into their corresponding ip address and vice versa


Section 20
----------
Layer 3 = Router
Layer 2 = switch
Layer 3 = Hub

Routers:
> Used to connect different networks togther
> Routes traffic between networks using IP Addresses
> Uses routing protocols to find the best way to get a packet of information from one Network to another.


Dynamic routing protocols:

> Distance-vercor, Link-state, Hybrid

Section 21:Network segmentation

NAT: NAT translates private IP address to public IP addresses,allowing us to map private ip address to public ip addresses,it helps in network security

Three forms of NAT:
	Static NAT
	Dynamic NAT
	Port Address Translation
 ACL - Access Control List

SSID - service set identifier
	

OSI Model:
[byebytego](https://www.youtube.com/watch?v=0y6FtKsg6J4)


![[Screenshot 2022-12-26 at 2.28.10 PM.png]]


![[Screenshot 2022-12-26 at 2.28.28 PM.png]]

![[Screenshot 2022-12-26 at 2.27.20 PM.png]]


![[Screenshot 2022-12-26 at 2.28.52 PM.png]]

 
![[Screenshot 2022-12-26 at 2.29.02 PM.png]]


[source- css tricks](https://css-tricks.com/computer-science-unleashed-chapter-1-connections/)

link layer enables directly connected computers to exchange messages inside frames. The **internet layer**, also known as the **network layer**, specifies how to transmit these messages between computers that are _not_ directly connected. The trick is to equip some computers, called **routers**, with multiple network interfaces. All computers in a network are then linked to at least one router, and all routers are linked to at least one other router. When a router receives a message at one of its network interfaces, it can forward it to another router through a different network interface.

The Internet Protocol sets the rules on how location addresses work–that’s why they’re called **IP addresses**. Computers can only send or receive IP packets after they get an IP address. Permission to use a group of IP addresses is first granted to an organization. These addresses are then assigned to computers which are directly or indirectly associated with the organization.

computers on the Internet can exchange information—such as ICMP messages—in IP packet payloads. However, the true power of the Internet is unleashed when applications, not computers, start using IP packet payloads to send each other data. This requires extra information to be included in the IP packets so that a computer can handle multiple streams of data for the different applications it runs. This extra information is described by the **transport layer**, which includes the famous TCP and UDP protocols.


![[Pasted image 20230816094302.png]]

![[Pasted image 20240422101831.png]]
![[Pasted image 20240422102001.png]]
![[Pasted image 20240422102059.png]]
![[Pasted image 20240502103104.png]]


## DHCP
**Static vs Dynamic

Every network attached device (computer, printer, switch, etc) needs to have an address on the network, much like your home has an address.

If you want to mail a letter to your cousin in another state, you write their address on the envelope, and the postal system knows how to deliver the letter based on the information provided. Without this address, the post office has no idea where to deliver the letter. A home address is a static IP address. It doesn't change. It's something that was given to that house when it was built and meant to be permanent and non changing forever. This is like a static IP address. (For the purposes of this explanation, I'm saying static IP addresses can't change, but they really can and it's a manual process.)

Now, what if you weren't given a permanent address forever. How would you mail letters without an address? You can't. This is where DHCP comes in. DHCP is technically a protocol, but for this explanation that doesn't matter. It exists/is setup as a service on a server or as built in functionality of a router.

DHCP is dynamic, it can change, and does change. Computers and other network devices constantly connect and disconnect. You take your laptop from work, and you bring it home. This is why your laptop can't have a static address (like your home). If everything was static, we would run out of IP Addresses because every time a device connects to a network, that would be it's IP address forever. Also, every network has the potential to have a different subnet. Your work subnet may be 192.168.1.x, and your home may be 192.168.0.x -- we need your laptop IP address to be able to change based on where it is, and the subnet used at that location. IP addresses are finite. So we need a way to release this address after some time as well. If the device is still connected, it will get that IP Address again, if it's not connected, the address will be released so another computer can take it.

The server or router not only issues these addresses, but keeps track of all the IP addresses it gives to all the connected devices. It maintains that time frame where it will release the IP address, and if the computer still needs it, it will give it again.**
- DHCP takes a pool of IPs and assigns them upon request. Could be public or private
    
- NAT (typically) takes routable IP data and sends it through to a non-routable IP (like the ubiquitous 192.168.0.0 block)
DHCP and NAT serve distinct purposes in network management. **DHCP focuses on dynamic IP address allocation.** It automatically assigns IP addresses, gateways, and DNS settings to devices on a network, simplifying network management and ensuring unique device identifiers.

In contrast, **NAT operates at the network gateway or [router](https://www.baeldung.com/cs/routers-vs-switches-vs-access-points) level.** It acts as an intermediary between a local network and the Internet, concealing the internal IP addresses of local devices. As a result, they share a single public IP address when communicating with external servers. So, **NAT’s primary role is to manage the interaction between a local network and the Internet by mapping internal addresses to a single public address.**

### Subnetting
![[Pasted image 20250220230449.png]]
### [How Subnet Masks Work](https://www.freecodecamp.org/news/subnet-cheat-sheet-24-subnet-mask-30-26-27-29-and-other-ip-address-cidr-network-references/)

Subnet masks function as a sort of filter for an IP address. With a subnet mask, devices can look at an IP address, and figure out which parts are the network bits and which are the host bits.

Then using those things, it can figure out the best way for those devices to communicate.

If you've poked around the network settings on your router or computer, you've likely seen this number: `255.255.255.0`.

If so, you've seen a very common subnet mask for simple home networks.

Like IPv4 addresses, subnet masks are 32 bits. And just like converting an IP address into binary, you can do the same thing with a subnet mask.

For example, here's our chart from earlier:

|128|64|32|16|8|4|2|1|
|---|---|---|---|---|---|---|---|
|x|x|x|x|x|x|x|x|

Now let's convert the first octet, 255:

|128|64|32|16|8|4|2|1|
|---|---|---|---|---|---|---|---|
|1|1|1|1|1|1|1|1|

Pretty simple, right? So any octet that's `255` is just `11111111` in binary. This means that `255.255.255.0` is really `11111111.11111111.11111111.00000000` in binary.

Now let's look at a subnet mask and IP address together and calculate which parts of the IP address are the network bits and host bits.

Here are the two in both decimal and binary:

| Type        | Decimal       | Binary                              |
| ----------- | ------------- | ----------------------------------- |
| IP address  | 192.168.0.101 | 11000000.10101000.00000000.01100101 |
| Subnet mask | 255.255.255.0 | 11111111.11111111.11111111.00000000 |

With the two laid out like this, it's easy to separate `192.168.0.101` into network bits and host bits.

Whenever a bit in a binary subnet mask is 1, then the same bit in a binary IP address is part of the network, not the host.

Since the octet `255` is `11111111` in binary, that whole octet in the IP address is part of the network. So the first three octets, `192.168.0`, is the network portion of the IP address, and `101` is the host portion.

In other words, if the device at `192.168.0.101` wants to communicate with another device, using the subnet mask it knows that anything with the IP address `192.168.0.xxx` is on the same local network.

Another way to express this is with a network ID, which is just the network portion of the IP address. So the network ID of the address `192.168.0.101` with a subnet mask of `255.255.255.0` is `192.168.0.0`.

And it's the same for the other devices on the local network (`192.168.0.102`, `192.168.0.103`, and so on).
## What is a subnet mask?
[source](https://community.spiceworks.com/t/subnetting-for-dummies/970210/1)

A subnet mask defines which chunk of an IP address is the host ID and which portion is the subnet network ID.

IP subnetting is a method for dividing a single, physical network into smaller subnetworks, or subnets for short. This is accomplished by manipulating the 32-bits available in an IPv4 address, which can be divided into two parts: a network ID and a host ID. The number of bits you assign to the network ID allows for either a greater number of total subnetworks or more hosts (devices that can be part of each subnet).

## How does subnetting work?

When you subnet a network, how does traffic find its way to its destination? Let’s imagine a network, with a gateway IP address of 139.12.0.0. Now imagine we split this network into two smaller subnets. The following diagram describes how the network looks with these two subnets.

If you’re wondering about how to actually subnet an IPv4 network, check out [How to calculate a subnet mask](https://community.spiceworks.com/networking/articles/2491-how-to-calculate-a-subnet-mask) . You might also be interested in [Advanced subnetting](https://community.spiceworks.com/networking/articles/2487-advanced-subnetting) . And if you’re just looking for tips on how to keep subnetting concepts straight, check our our [Subnet Cheat Sheet](https://static.spiceworks.com/attachments/cms/0000/1873/subnet-cheat-sheet.pdf) .

So the outside world considers the device at 139.12.16.15 to be a part of the 139.12.0.0 network. Any packet sent to this device will be delivered to the router at 139.12.0.0. The router then does the work of figuring out the subnet portion of the host ID to decide whether the packet goes to subnet 16 or subnet 28.


### What Does CIDR Mean and What is CIDR Notation?

**CIDR** stands for Classless Inter-Domain Routing, and is used in IPv4, and more recently, IPv6 routing.
### **Classless addresses**

Classless or Classless Inter-Domain Routing (CIDR) addresses use variable length subnet masking (VLSM) to alter the ratio between the network and host address bits in an IP address. A subnet mask is a set of identifiers that returns the network address’s value from the IP address by turning the host address into zeroes. 

A VLSM sequence allows network administrators to break down an IP address space into subnets of various sizes. Each subnet can have a flexible host count and a limited number of IP addresses. A CIDR IP address appends a suffix value stating the number of network address prefix bits to a normal IP address.

For example, 192.0.2.0/24 is an IPv4 CIDR address where the first 24 bits, or 192.0.2, is the network address.

Classless Inter-Domain Routing (CIDR) is a method of IP address allocation and IP routing that allows for more efficient use of IP addresses. CIDR is based on the idea that IP addresses can be allocated and routed based on their network prefix rather than their class, which was the traditional way of IP address allocation.

CIDR addresses are represented using a slash notation, which specifies the number of bits in the network prefix. For example, an IP address of 192.168.1.0 with a prefix length of 24 would be represented as 192.168.1.0/24. This notation indicates that the first 24 bits of the IP address are the network prefix and the remaining 8 bits are the host identifier.

Source : https://www.youtube.com/watch?v=vv4y_uOneC0

![[Pasted image 20250221001608.png]]
![[Pasted image 20250221001748.png]]
![[Pasted image 20250221002007.png]]
![[Pasted image 20250221002320.png]]
![[Pasted image 20250221002342.png]]
![[Pasted image 20250221002635.png]]
![[Pasted image 20250221002659.png]]
![[Pasted image 20250221003240.png]]
![[Pasted image 20250221003409.png]]
![[Pasted image 20250221003518.png]]








## Topics
DHCP
DNS
OSI Model
NAT - Network address translation



































