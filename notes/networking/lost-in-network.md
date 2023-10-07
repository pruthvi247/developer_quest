[source](https://deadlime.hu/en/2023/09/30/lost-in-the-network/?utm_source=changelog-news)

### Physical layer

Chances are that everyone has an Ethernet network at home, something like this:

![[Pasted image 20231006103158.png]]
>The modem, the router, and the switch may happen to live in the same box.

It's called the physical layer: a bunch of network devices, tied together with copper strings (or wireless devices tied together with magic). Each network device has a unique MAC address, assigned in the factory. There's a lot more interesting stuff to look into here (like how devices communicate with each other about which speeds they support), but personally, there's not much more I can tell you about it, so let's move on to the next layer, the data link layer.

### Data link layer

At this layer, the zeros and ones we know so well finally appear. We have what's called the Ethernet frame, which is a unit of data that we can send at a time. It looks something like this:

|   |   |
|---|---|
|6 bytes|MAC address of the recipient|
|6 bytes|MAC address of the sender|
|2 bytes|type of the data (`0x0800` for IP, `0x0806` for ARP)|
|46-1500 bytes|the data|
|4 bytes|checksum|

Interesting that the sender needs to tell who the sender is. What happens if someone else's MAC address is entered there? Is it possible to do something naughty with this?

Two interesting things to note here. One is MAC spoofing, where we are not happy with the MAC address assigned by the hardware vendor and we want to change it. Say because our ISP's device only works with a fixed MAC address. Or there are Android phones, which by default connect to a Wi-Fi network with a random MAC address so that the phone cannot be tracked between networks.

The other interesting thing is MAC flooding, where the attacker sets up a bunch of random MAC addresses as senders. This fills up the entire MAC address table of the switch, leaving no room for the real MAC addresses. This usually has the consequence that the recipient MAC address of an incoming real packet will not be found in the MAC address table, causing it to be sent out to everyone. This allows attackers to peek into the contents of packets that are not intended for them.

The observant reader may also notice that there is no mention of the so-called IP addresses that we normally use. For that, we need to move on to the next level, which is the network layer.

### Network layer

There are several interesting protocols to be mentioned here, all of which will be placed in the data part of the Ethernet frame. First, we need to know what MAC address is associated with a given IP address.

#### Address Resolution Protocol

ARP helps us with this, we can send a request to which the owner of the IP address can respond. The message structure:

|   |   |
|---|---|
|2 bytes|hardware type (`0x0001` for Ethernet)|
|2 bytes|protocol type (`0x0800` for IP)|
|1 byte|hardware length (`0x06` for Ethernet, because the MAC address is 6 bytes long)|
|1 byte|protocol length (`0x04` for IP, because an IP (v4) address is 4 bytes long)|
|2 bytes|operation (`0x0001` is the request, `0x0002` is the response)|
|6 bytes|sender's hardware address|
|4 bytes|sender's protocol address|
|6 bytes|recipient's hardware address|
|4 bytes|recipient's protocol address|

Let's add IP addresses to the above diagram and see a concrete example of a request and response.
![[Pasted image 20231006104059.png]]
Say Alice wants to ping Bob, so she asks which MAC address the IP address `192.168.1.103` belongs to. The request (the green part belongs to the Ethernet frame, the blue part to the ARP request):

|   |   |
|---|---|
|`0xFFFFFFFFFFFF`|recipient (everybody)|
|`0x0A0000000002`|sender (Alice)|
|`0x0806`|ARP type of data|
|`0x0001`|Ethernet hardware|
|`0x0800`|IP protocol|
|`0x06`|MAC address is 6 bytes long|
|`0x04`|IP address is 4 bytes long|
|`0x0001`|it's a request packet|
|`0x0A0000000002`|sender's (Alice) MAC address|
|`0xC0A80166`|sender's (Alice) IP address|
|`0x000000000000`|recipient's (Bob) MAC address|
|`0xC0A80167`|recipient's (Bob) IP address|
|`0x????????`|checksum|

The IP addresses are in hexadecimal format, [CyberChef is a nice tool for converting](https://gchq.github.io/CyberChef/#recipe=Change_IP_format('Dotted%20Decimal','Hex')&input=MTkyLjE2OC4xLjEwMw). In a request packet, the MAC address of the recipient can be anything, its value will be ignored.

Bob receives this request and since his IP address is `192.168.1.103`, he sends a reply:

|   |   |
|---|---|
|`0x0A0000000002`|recipient (Alice)|
|`0x0A0000000003`|sender (Bob)|
|`0x0806`|ARP type of data|
|`0x0001`|Ethernet hardware|
|`0x0800`|IP protocol|
|`0x06`|MAC address is 6 bytes long|
|`0x04`|IP address is 4 bytes long|
|`0x0002`|it's a response packet|
|`0x0A0000000003`|sender's (Bob) MAC address|
|`0xC0A80167`|sender's (Bob) IP address|
|`0x0A0000000002`|recipient's (Alice) MAC address|
|`0xC0A80166`|recipient's (Alice) IP address|
|`0x????????`|checksum|

Here again, the question arises, what happens if Bob is not the only one who replies to the request, but the evil Mallory as well? Could Alice be sending her messages for Bob to the wrong place?

The devices have something called an ARP cache, which holds the IP address - MAC address mappings so that you don't have to ask every time. For Alice, it might look something like this:
```sh

$ ip -br neigh
192.168.1.103                           eth0             0a:00:00:00:00:03
192.168.1.104                           eth0             0a:00:00:00:00:04
192.168.1.1                             eth0             0a:00:00:00:00:01
```
This cache is also updated when an ARP response is received without being requested, which means that if Mallory starts flooding the network with fake ARP responses (telling Alice that he is the router, telling the router that he is Alice), and forwards packets passing through it to the original recipients, he can intercept (or even alter) Alice's Internet traffic without Alice noticing anything.

#### Internet Protocol

The following protocol is IP, which finally gives us IP addresses and the ability to exchange data between two IP addresses. The IP packet structure:

|   |   |
|---|---|
|4 bits|version (`0b0100` for IPv4)|
|4 bits|header size (usually `0b0101`)|
|8 bits|various settings I don't quite understand, we can send `0b00000000`, that wouldn't hurt :)|
|2 bytes|size of the whole packet|
|2 bytes|identification (for grouping message fragments)|
|2 bytes|data related to fragments (an IP packet we want to send may be too big for an Ethernet frame so we need to split it into multiple packets), by default it's `0x00`|
|1 byte|TTL (Time-to-live), it decreases by one when a packet goes through a network device, if it reaches zero, the device drops the packet|
|1 byte|protocol used in the data (`0x01` for ICMP, `0x06` for TCP, `0x11` for UDP)|
|2 bytes|checksum|
|4 bytes|sender's IP address|
|4 bytes|recipient's IP address|
||data|

#### Internet Control Message Protocol

Since we mentioned ping earlier, we should mention ICMP. It's a strange beast, it belongs to the network layer, but it feels like it should be in the transport layer. It's wrapped into an IP packet in the same way as UDP or TCP, only it's not for data transport. In the case of ping, the message is structured somewhat like this:

|   |   |
|---|---|
|1 byte|type (`0x08` is ping request, `0x00` is ping response)|
|1 byte|code (not used in case of ping)|
|2 bytes|checksum|
|2 bytes|identifier (to pair a request with a response)|
|2 bytes|sequence number (to pair a request with a response)|
||optional data|


Alice already knows Bob's MAC address, so she can finally send the ping she originally wanted, which Bob can then reply to. The request looks something like this (the green part is for the Ethernet frame, the blue part is the IP packet, the red part is ICMP):

|   |   |
|---|---|
|`0x0A0000000003`|recipient's MAC address (Bob)|
|`0x0A0000000002`|sender's MAC address (Alice)|
|`0x0800`|IP type data|
|`0b01000101`|version and header size|
|`0b00000000`|settings we don't care about|
|`0x????`|the size of the full packet|
|`0x????`|identifier|
|`0x00`|splitting related data|
|`0xFF`|TTL|
|`0x01`|ICMP packet|
|`0x????`|checksum|
|`0xC0A80166`|sender's IP address (Alice)|
|`0xC0A80167`|recipient's IP address (Bob)|
|`0x08`|ping request type|
|`0x00`|unused data|
|`0x????`|checksum|
|`0x????`|identifier|
|`0x????`|serial number|
|`0x????????`|checksum|

To which Bob sends the following reply:

|   |   |
|---|---|
|`0x0A0000000002`|recipient's MAC address (Alice)|
|`0x0A0000000003`|sender's MAC address (Bob)|
|`0x0800`|IP type data|
|`0b01000101`|version and header size|
|`0b00000000`|settings we don't care about|
|`0x????`|the size of the full packet|
|`0x????`|identifier|
|`0x00`|splitting related data|
|`0xFF`|TTL|
|`0x01`|ICMP packet|
|`0x????`|checksum|
|`0xC0A80167`|sender's IP address (Bob)|
|`0xC0A80166`|recipient's IP address (Alice)|
|`0x00`|ping response type|
|`0x00`|unused data|
|`0x????`|checksum|
|`0x????`|identifier (what Alice sent)|
|`0x????`|serial number (what Alice sent)|
|`0x????????`|checksum|
It's getting complicated, and we are far from the end. Did you notice that there was no mention of ports? It wasn't by mistake, at this point the concept of a port does not exist, it is time for us to move up yet another level.

### Transport layer

If you've ever opened sockets in any programming language, you'll be familiar with the protocols found here. Let's start with the easy one.
#### User Datagram Protocol

As mentioned above, UDP is the easier one. There's no guarantee that the packet will arrive, no retransmission for lost packets, you just yell into one end of the pipe and hope that the other end will hear it. A packet looks like this:

|   |   |
|---|---|
|2 bytes|sender's port|
|2 bytes|recipient's port|
|2 bytes|the full size of the packet|
|2 bytes|checksum|
||optional data|

The sender port is also optional, if it is not set to zero, then the response packets are expected on that port.

#### Transmission Control Protocol

And this brings us to the famous and popular TCP. The cornerstone of the pack-everything-in-your-browser-and-serve-it-over-HTTP-based Internet. Until the wide adoption of HTTP/3, which uses UDP. A packet looks like this:

|   |   |
| ---| --- |
|2 bytes| sender's port|
|2 bytes|recipient's port|
|4 bytes|sequence number|
|4 bytes|acknowledgment number|
|4 bits|header size (the number of 4 byte blocks)|
|4 bits|reserved, unused bits|
|8 bits|flags (`SYN`, `FIN`, `ACK`, `URG` and the others)|
|2 bytes|window size|
|2 bytes|checksum|
|2 bytes|offset for the last urgent data byte (if the packet is `URG`)|
||optional settings|
||optional data|

It's not just the structure of the packet that is important, but the little dance that the client and server do to exchange data. The connection must be established and closed, and both parties have to acknowledge that they have received the data sent by the other.

##### Establishing a connection

1. the client sends a `SYN` packet  
    (the sequence number is 0, as this is the first packet from the client)
2. the server replies with a `SYN`, `ACK` packet  
    (the sequence number is 0, as this is the first packet to the server, the acknowledgment number is 1, as the sequence number received before was 0 and no data was included, so the next packet will be expected to have the sequence number of 1)
3. the client responds with an `ACK` packet  
    (the sequence number is 1, the acknowledgment number is 1)
##### Data exchange

1. the client sends 10 bytes of data  
    (the serial number is 1)
2. the server replies with an `ACK` packet  
    (the sequence number is 1, and the acknowledgment number is 11 since the previous sequence number was 1 and 10 bytes of data were received)
3. the server sends 100 bytes of data  
    (the sequence number is 1)
4. the client replies with an `ACK` packet  
    (the sequence number is 11, the acknowledgment number is 101)
##### Closing the connection

1. the client sends a `FIN` packet  
    (the sequence number 11)
2. the server replies with a `FIN`, `ACK` packet  
    (sequence number 101, acknowledgment number is 12)
3. the client replies with an `ACK` packet  
    (the sequence number is 12, and the acknowledgment number is 102)
### Application layer

We elegantly skip two layers, the session layer and the presentation layer. The session layer contains the SOCKS (Socket)protocol for example, and the scope of the presentation layer often merges with the application layer.

The application layer can be, for example, HTTP. Using the knowledge gained above, let's see what happens when Alice runs a simple `curl www.example.org` command.
To be able to tell this, we need to know Alice's network settings. Suppose something like this is configured:

```
auto eth0
iface eth0 inet static
      address 192.168.1.102
      netmask 255.255.255.0
      gateway 192.168.1.1
      dns-nameservers 1.1.1.1
```

- we can do nothing with the `www.example.org` domain, we need an IP address
- the configured DNS IP address is not on the local network, so the request has to be sent to the router (gateway)
- send an ARP request to find out the MAC address of the router
- send a UDP packet to the MAC address of the router with the DNS IP address in the IP packet
- the router sees that it is not the recipient, so it forwards the packet to the Internet (NAT and connection tracking are also involved here so that the router's public IP address is visible in the packet on the way out and it knows who to forward the reply to)
- a reply UDP packet arrives from the Internet, the router sees that it is not the recipient
- because of connection tracking, the router knows where to forward the packet
- forward UDP packet to Alice
- IP address of `www.example.org` is `X.X.X.X`
- establish a TCP connection, make an HTTP request
- the address `X.X.X.X` is not on the local network, so TCP packets are sent to the MAC address of the router with the corresponding destination IP address
- reply packets are forwarded by the router to Alice
- closing the TCP connection
- ARP requests are probably not needed at this point because they are cached

Another question that may arise is how to know that an IP address is not on the local network. From the `address`/`netmask`/`gateway` settings above, a routing table is generated that looks something like this:

```sh
$ sudo route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.1.1     0.0.0.0         UG    0      0        0 eth0
192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 eth0
```

I don't say I know exactly how this works, but I would guess that it will pick the narrowest match or start from the end and work backward and pick the first match, but the point is, if something is in the range `192.168.1.0`-`192.168.1.255` it will just simply send it out to the appropriate MAC address, for all other IP addresses it will send the packet to the MAC address associated with the IP address `192.168.1.1`. The router has a similar routing table to decide what to do with the incoming packets.

### Summary

I hope I have managed to get a glimpse of what happens "underneath" us when we use the Internet. There are a lot of things going on through many layers and we have only managed to scratch the surface a little bit.

We didn't even get very far, just ventured as far as the router. What's beyond that... is a world of its own, with things like DSL, SDH, PPP, MPLS, BGP, OSPF, and a bunch of other acronyms I don't even know about. And yet, in most cases, our packets get to the right recipients. What is this if not magic?























