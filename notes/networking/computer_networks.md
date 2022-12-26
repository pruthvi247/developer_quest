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

Layer 4 - Data link layer:

> The switching layer
> Ensures that messages are delivered to the proper deviec on a LAN using hardware addresses
	> mac address
	> only concerened with local delivery of frames on the same network
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
	> ip address
	> subnet mask
	> Default Gateway
	> DNS server

Network Time Protocol - NTP
port: 123 Transport Layer Protocol : TCP

> This protocol automatically synchronizes a system's time with a network time server
	>Important for time-dependent network applications and protocols
	>Authentication will oftern fail if time isn't properly synchronized between devices

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
	>Doesnt support authentication
	>Doesnt support directory navigation
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














































