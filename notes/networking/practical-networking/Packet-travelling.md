
[source-youtube](https://www.youtube.com/watch?v=rYodcvhh7b8)

### The Journey of a Packet: From Host to Host Across Networks

This article explains the intricate process of how a data packet travels from one host to another across a network, involving switches and a router, by combining the functionalities of Layer 2 (switching) and Layer 3 (routing) devices. Understanding this journey is crucial for anyone looking to grasp the fundamentals of computer networking.

![[Pasted image 20250903204643.png]]
#### Network Topology Overview

The scenario involves a sample network topology designed to illustrate packet movement. This topology consists of:

- **Four hosts**: Host A, Host B, Host C, and Host D.
- **Two switches**: Switch X and Switch Y.
- **One router**: This router acts as the default gateway, connecting two distinct IP networks.

Each device in the topology has specific identifiers:

- **IP Addresses**: Host A (11.11.11.10), Host B (11.11.11.20), Host C (22.22.22.30), Host D (22.22.22.40). The router's left interface (Ethernet 1/ETH1) is 11.11.11.1, and its right interface (Ethernet 2/ETH2) is 22.22.22.1.
- **MAC Addresses**: Each host and router interface also possesses a unique MAC address, represented by a four-digit prefix (e.g., Host A: AAA, Router ETH1: E01, Router ETH2: E02, Host D: DDD).
- **Switch Ports**: Switch X has ports 1, 2, and 3. Switch Y has ports 4, 5, and 6.

The router facilitates communication between two IP networks: the **11.11.11.0/24 network** connected via ETH1, and the **22.22.22.0/24 network** connected via ETH2.
#### Key Network Tables
Network devices maintain various tables to process traffic effectively. These tables are dynamically populated as traffic flows, with the exception of the routing table, which is pre-configured.

- **ARP Table (Address Resolution Protocol Table)**:
    
    - **Purpose**: This table maps **IP addresses to MAC addresses**.
    - **Devices**: All Layer 3 devices, such as hosts and routers, maintain an ARP table.
    - **Population**: It is populated dynamically when a device needs to communicate with another device on the same local network and resolves its MAC address using an ARP request.
- **MAC Address Table**:
    
    - **Purpose**: This table maps **switch ports to MAC addresses**.
    - **Devices**: Switches use this table to know which device (identified by its MAC address) is connected to which specific port.
    - **Population**: As traffic passes through a switch, it inspects the source MAC address of incoming frames and records it along with the ingress port.
- **Routing Table**:
    
    - **Purpose**: This table maps **IP networks to egress (outgoing) interfaces**.
    - **Devices**: Routers utilize routing tables to determine the best path to forward packets to different networks.
    - **Population**: Unlike the other tables, the routing table is typically populated _prior_ to traffic flow through configuration or dynamic routing protocols. In our example, the router knows about the 11.11.11.0/24 network via ETH1 and the 22.22.22.0/24 network via ETH2 because of its interface IP configurations.

#### Packet Travel: From Host A to Host D (Forward Path)

Let's trace the journey of a packet originating from **Host A (11.11.11.10)** destined for **Host D (22.22.22.40)**.

1. **Host A Prepares the Layer 3 Header**: Host A has data for Host D and already knows Host D's IP address (22.22.22.40). It constructs a Layer 3 (IP) header with:
    - **Source IP**: 11.11.11.10 (Host A).
    - **Destination IP**: 22.22.22.40 (Host D).
2. **Host A Determines Destination Network**: Host A compares Host D's IP address with its own network (11.11.11.0/24). It determines that Host D is on a **foreign network**, meaning the packet must be sent to the **default gateway (the router)**.
    
3. **Host A Needs Router's MAC Address**: To create the Layer 2 (Ethernet) header, Host A needs the MAC address of its default gateway. Host A checks its ARP table, which is initially empty for the router's IP address.
    
4. **Host A Sends an ARP Request**: Host A sends a **broadcast ARP request** onto its local network, asking "Who has 11.11.11.1 (the router's ETH1 IP)? Tell 11.11.11.10".
    
    - The Layer 2 header of this ARP request has: **Source MAC**: AAA (Host A); **Destination MAC**: FFFF (broadcast).
5. **Switch X Processes the ARP Request**:
    
    - Switch X receives the broadcast ARP request on port 2 (connected to Host A).
    - It **learns Host A's MAC address (AAA)** and records it in its MAC address table: **Port 2 -> AAA**.
    - Since the destination MAC is broadcast, Switch X **floods the ARP request out all other ports** (port 1 and port 3).
6. **Router Processes the ARP Request**:
    
    - The router's ETH1 interface (11.11.11.1) receives the ARP request from Switch X.
    - The router **learns Host A's MAC address (AAA)** and records it in its ARP table: **11.11.11.10 -> AAA**.
    - Recognizing its own IP address in the request, the router prepares an **ARP response**. This response is unicast directly to Host A's MAC address.
7. **Switch X Processes the ARP Response**:
    
    - Switch X receives the ARP response on port 3 (connected to the router's ETH1).
    - It **learns the router's ETH1 MAC address (E01)** and adds it to its MAC address table: **Port 3 -> E01**.
    - Since the destination MAC (AAA) is known to be on port 2, Switch X **forwards the ARP response specifically to port 2**.
8. **Host A Receives the ARP Response**: Host A receives the ARP response and **updates its ARP table**: **11.11.11.1 -> E01** (Router ETH1 MAC). Now Host A knows how to reach its default gateway at Layer 2.
    
9. **Host A Sends the Data Packet**: Host A now creates the full Layer 2 header for the original data packet:
    
    - **Source MAC**: AAA (Host A).
    - **Destination MAC**: E01 (Router ETH1).
    - The packet (with L3 header and data) is encapsulated in this Layer 2 frame and sent to Switch X.
10. **Switch X Forwards the Data Packet**:
    
    - Switch X receives the frame on port 2. The MAC table entry for port 2 (AAA) is **refreshed**.
    - Since the destination MAC (E01) is known to be on port 3, Switch X **forwards the frame out port 3** to the router.
11. **Router Receives the Data Packet (ETH1)**:
    
    - The router's ETH1 interface receives the frame. It **strips off the Layer 2 header**, as its purpose was to get the packet to the router.
    - The router examines the Layer 3 destination IP address: 22.22.22.40 (Host D).
12. **Router Consults its Routing Table**: The router looks up 22.22.22.40 in its routing table. It finds that the **22.22.22.0/24 network is directly connected via its ETH2 interface**.
    
13. **Router Needs Host D's MAC Address**: To send the packet to Host D on its local network (22.22.22.0/24), the router needs Host D's MAC address. It checks its ARP table, which is currently empty for Host D's IP address.
    
14. **Router Sends an ARP Request (ETH2)**: The router sends a **broadcast ARP request** from its ETH2 interface, asking "Who has 22.22.22.40 (Host D's IP)? Tell 22.22.22.1".
    
    - The Layer 2 header has: **Source MAC**: E02 (Router ETH2); **Destination MAC**: FFFF (broadcast).
15. **Switch Y Processes the ARP Request**:
    
    - Switch Y receives the broadcast ARP request on port 4 (connected to Router ETH2).
    - It **learns Router ETH2's MAC address (E02)** and records it in its MAC address table: **Port 4 -> E02**.
    - Switch Y **floods the ARP request out all other ports** (port 5 and port 6).
16. **Host C Discards ARP Request**: Host C (22.22.22.30) receives the ARP request but realizes the IP address (22.22.22.40) is not its own, so it **discards the frame**.
    
17. **Host D Processes the ARP Request**:
    
    - Host D receives the ARP request. It **learns Router ETH2's MAC address (E02)** and updates its ARP table: **22.22.22.1 -> E02**.
    - Recognizing its own IP address, Host D prepares an **ARP response**, unicast directly to the router's ETH2 MAC address.
18. **Switch Y Processes the ARP Response**:
    
    - Switch Y receives the ARP response on port 5 (connected to Host D).
    - It **learns Host D's MAC address (DDD)** and adds it to its MAC address table: **Port 5 -> DDD**.
    - Since the destination MAC (E02) is known to be on port 4, Switch Y **forwards the ARP response specifically to port 4**.
19. **Router Receives the ARP Response (ETH2)**: The router's ETH2 interface receives the ARP response and **updates its ARP table**: **22.22.22.40 -> DDD** (Host D's MAC). Now the router knows how to reach Host D at Layer 2.
    
20. **Router Sends the Data Packet (ETH2)**: The router now creates the full Layer 2 header for the original data packet:
    
    - **Source MAC**: E02 (Router ETH2).
    - **Destination MAC**: DDD (Host D).
    - The packet is encapsulated in this Layer 2 frame and sent from ETH2 to Switch Y.
21. **Switch Y Forwards the Data Packet**:
    
    - Switch Y receives the frame on port 4. The MAC table entry for port 4 (E02) is **refreshed**.
    - Since the destination MAC (DDD) is known to be on port 5, Switch Y **forwards the frame out port 5** to Host D.
22. **Host D Receives and Processes Data**:
    
    - Host D receives the frame. It **strips the Layer 2 header**, as its purpose was to deliver the packet from the router.
    - It then **strips the Layer 3 header**, as its purpose was to deliver the packet from Host A to Host D.
    - Finally, Host D receives and **processes the original data**.
#### Packet Travel: From Host D to Host A (Return Path)

The return journey is significantly quicker because all the necessary ARP and MAC address tables have already been populated.

1. **Host D Prepares Response Data and Layer 3 Header**: Host D creates response data for Host A. It builds a Layer 3 header with:
    
    - **Source IP**: 22.22.22.40 (Host D).
    - **Destination IP**: 11.11.11.10 (Host A).
2. **Host D Determines Destination Network**: Host D compares Host A's IP address with its own network. It determines Host A is on a foreign network, so the packet must be sent to the **default gateway (the router)**.
    
3. **Host D Builds Layer 2 Header**: Host D already has the router's ETH2 MAC address (E02) in its ARP table. It builds the Layer 2 header:
    
    - **Source MAC**: DDD (Host D).
    - **Destination MAC**: E02 (Router ETH2).
    - The frame is sent to Switch Y.
4. **Switch Y Forwards the Frame**:
    
    - Switch Y receives the frame on port 5. Its MAC table entry for port 5 (DDD) is **refreshed**.
    - Since the destination MAC (E02) is known to be on port 4, Switch Y **forwards the frame out port 4** to the router's ETH2 interface.
5. **Router Receives the Packet (ETH2)**:
    
    - The router's ETH2 interface receives the frame and **strips the Layer 2 header**.
    - It examines the Layer 3 destination IP address: 11.11.11.10 (Host A).
6. **Router Consults its Routing Table**: The router looks up 11.11.11.10 in its routing table. It finds that the **11.11.11.0/24 network is directly connected via its ETH1 interface**.
    
7. **Router Builds Layer 2 Header**: The router already has Host A's MAC address (AAA) in its ARP table. It builds the Layer 2 header:
    
    - **Source MAC**: E01 (Router ETH1).
    - **Destination MAC**: AAA (Host A).
    - The packet is encapsulated and sent from ETH1 to Switch X.
8. **Switch X Forwards the Frame**:
    
    - Switch X receives the frame on port 3. Its MAC table entry for port 3 (E01) is **refreshed**.
    - Since the destination MAC (AAA) is known to be on port 2, Switch X **forwards the frame out port 2** to Host A.
9. **Host A Receives and Processes Data**:
    
    - Host A receives the frame. It **strips the Layer 2 header**.
    - It then **strips the Layer 3 header**.
    - Finally, Host A receives and **processes the response data**.
#### Conclusion

This detailed walkthrough illustrates the fundamental mechanisms by which packets traverse a network, highlighting the critical roles of ARP, MAC address tables, and routing tables. From the initial ARP requests to discover MAC addresses, to the router's decision-making based on its routing table, and finally to the seamless forwarding by switches, each step ensures that data reaches its intended destination. The efficiency of the return path, due to pre-populated tables, underscores how network devices learn and optimize communication over time.

