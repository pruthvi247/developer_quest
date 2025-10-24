[Open Systems Interconnection](https://blog.bytebytego.com/p/network-protocols-run-the-internet?utm_source=post-email-title&publication_id=817132&post_id=128408371&isFreemail=true&utm_medium=email)

The diagram below shows what each layer does in the OSI model. Each intermediate layer serves a class of functionality to the layer above it and is served by the layer below it. Let’s review them.


Mnemonic: Please Do Not Throw Sausage Pizza Away

![[Pasted image 20230616100225.png]]
1. Application Layer
    

The application layer is the closest to the end users. Most applications reside in this layer. We request data from a backend server without needing to understand data transmission specifics. Protocols in this layer include HTTP, SMTP, FTP, DNS, etc. We will cover them later.

2. Presentation Layer
    

This layer handles data encoding, encryption, and compression, preparing data for the application layer. For example, HTTPS leverages TLS (Transport Layer Security) for secure communications between clients and servers. 

3. Session Layer
    

This layer opens and closes the communications between two devices. If the data size is large, the session layer sets a checkpoint to avoid resending from the beginning.
- The system recognizes packets as belonging to the same session by leveraging **session IDs, tokens, and context information** established and managed at the session layer during session setup.
-  These session identifiers combined with transport layer information help the receiver assemble packets correctly and maintain secure, synchronized communication.
-  Session validation ensures that only data from authenticated and authorized communication sessions is accepted and processed further up the stack.[](https://networkwalks.com/session-layer-of-osi-model-layer-5/)
Thus, even if authentication happens at higher layers, the session layer’s management mechanisms provide the structural framework to know which packets belong together as part of the same ongoing session.

4. Transport Layer
    
![[Pasted image 20250903192110.png]]
This layer handles end-to-end communication between the two devices. It breaks data into segments at the sender’s side and reassembles them at the receiver’s. There is flow control in this layer to prevent congestion. Key protocols in this layer are TCP and UDP, which we’ll discuss later.

5. Network Layer
    
![[Pasted image 20250903192244.png]]
This layer enables data transfer between different networks. It further breaks down segments or datagrams into smaller packets and finds the optimal route to the final destination using IP addresses. This process is known as routing.

6. Data Link Layer
![[Pasted image 20250903192444.png]]
![[Pasted image 20250903192545.png]]
This layer allows data transfer between devices on the same network. Packets are broken down into frames, which are confined to a local area network. 

7. Physical Layer
    

This layer sends bitstreams over cables and switches, making it closely associated with the physical connection between devices.

Now that we understand the responsibilities of each layer, let’s summarize the data transfer process using the following diagram. This is called encapsulation and decapsulation. Encapsulation involves adding headers to the data as it travels towards its destination. Decapsulation removes these headers to retrieve the original data.

![[Pasted image 20230616100715.png]]
Step 1: When Device A sends data to Device B over the network using HTTP, an HTTP header is initially added at the application layer.
Step 2: A TCP or a UDP header is added to the data. It is encapsulated into TCP segments at the transport layer. The header contains the source port, destination port, and sequence number.
Step 3: The segments are then encapsulated with an IP header at the network layer. The IP header contains the source and destination IP addresses.
Step 4: An MAC header is added to the IP datagram at the data link layer, containing the source and destination MAC addresses.
Step 5: The encapsulated frames are sent to the physical layer and sent over the network as bitstreams.
Steps 6-10: When Device B receives the bits from the network, it initiates the de-encapsulation process, which is the reverse of the encapsulation process. Headers are removed layer by layer, until Device B can access the original data.
>Note that each layer uses the headers for processing instructions and does not need to unpack the data from the previous layer.


How do the OSI model layers map to a Linux server implementation? The diagram below provides more detail. The Linux network protocol stack aligns closely with the 4-layer TCP/IP model. The application sends data to the socket via system calls. The socket serves an abstraction for the communication endpoint. The socket layer accepts the data and passes it to the transport and network layer. The data eventually reaches the Network Interface Card (NIC) and is sent over the network.

![[Pasted image 20230616105135.png]]

OSI model [redit](https://www.reddit.com/r/explainlikeimfive/comments/jmg1x/eli5_can_someone_explain_the_osi_model_like_i_am_5/)
I'll give it a shot. I'm pretty sure that if I mess this up someone will be along to correct me. :)

Layer 1 - Physical: The wires connecting all the telephones together in your neighbourhood.

Layer 2 - Data Link: The phone numbers for everyone in your neighbourhood

Layer 3 - Network: The address book your mom has with your neighbours names and their phone numbers.

Layer 4 - Transport: The telephone company.

Layer 5 - Session: The telephone company's equipment that makes the phone ring when someone calls and ends the call when everyone hangs up the phone.

Layer 6 - Presentation: The telephone in your house.

Layer 7 - Application: The microphone and speaker on the telephone that let you hear the other person and let them hear you talking.





![[protocols-8-in-1.gif]]

![[Pasted image 20250320105615.png]]
Transport layer -> Segments
Network Layer -> Packets
Datat Link Layer -> Frames

![[Pasted image 20250320112842.png]]


Data link layer address  -> MAC address (Network address of each device) -> Router will transfer frames to particular device based on mac address

## Scenario: Send message "Hello" from System A to System B using TCP with authentication in a session

## 1. Application Layer (Sender)

- **Data to send**: "Hello"
- Protocol: HTTP POST (example)
- Application layer adds HTTP headers (e.g., Host, Content-Type) and may include authentication tokens (e.g., JWT or cookie).
- Example HTTP message:
- ```sh
  POST /api/message HTTP/1.1
Host: systemb.com
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Length: 5

Hello
  ```
## 2. Transport Layer (Sender) - TCP Segment

- Data received from Application Layer: HTTP message above.
- TCP divides data into segments; adds TCP header:
    - Source port: 54321 (random client port)
    - Destination port: 80 (HTTP server port)
    - Sequence number: 1001 (helps ordering)
    - Ack number: 0 (initial)
    - Flags: SYN, ACK (if connection setup) or PSH, ACK for data
    - Window size, checksum, etc.
- Segment example (header fields with sample values):
```sh
TCP Header {
  Src Port: 54321,
  Dst Port: 80,
  Seq: 1001,
  Ack: 0,
  Flags: PSH, ACK,
  Window: 65535,
  Checksum: 0x1a2b
}
Data: HTTP message ("Hello" content included)

```
## 3. Internet Layer (Sender) - IP Packet

- TCP segment encapsulated inside IP packet.
- IP header fields:
    - Version: 4 (IPv4)
    - Source IP: 192.168.1.10
    - Destination IP: 203.0.113.5
    - Protocol: 6 (TCP)
    - TTL: 64 (time to live)
    - Checksum, Fragment offset, etc.
- Packet looks like:
  ```sh
  IP Header {
  Version: 4,
  Src IP: 192.168.1.10,
  Dst IP: 203.0.113.5,
  Protocol: TCP (6),
  TTL: 64,
  Checksum: 0x1234
}
Payload: TCP Segment

  ```
## 4. Link Layer (Sender) - Ethernet Frame

- IP packet encapsulated in Ethernet Frame.
- Ethernet header fields:
    - Destination MAC: 00:1A:2B:3C:4D:5E (System B MAC)
    - Source MAC: 00:1A:2B:3C:4D:5F (System A MAC)
    - EtherType: 0x0800 (IPv4)
- Frame structure:

```sh
Ethernet Header {
  Dst MAC: 00:1A:2B:3C:4D:5E,
  Src MAC: 00:1A:2B:3C:4D:5F,
  EtherType: IPv4
}
Payload: IP Packet

```
## Transmission
- The frame bits are sent physically across the network medium.
## On Receiver Side (System B)

## 1. Physical Layer
- Receives bits, interprets electrical/optical signals.
## 2. Link Layer (Ethernet Frame)
- Extracts Ethernet header to verify MAC addresses.
- Removes Ethernet header.
- Forwards payload (IP packet) to Network layer.
## 3. Internet Layer (IP Packet)
- Reads IP header.
- Validates destination IP and checksum.
- Removes IP header and forwards payload (TCP segment).
## 4. Transport Layer (TCP Segment)
- Uses TCP header (source/destination port, seq/ack numbers).
- Performs error checking via checksum.
- Reassembles segments in order based on sequence numbers.
- Removes TCP header, forwards payload (HTTP message).
## 5. Application Layer (HTTP)
- Reads HTTP headers.
- Validates Authorization header (token).
- Processes HTTP body ("Hello").
- Translates content for app use.
## Session and Authentication Header Handling

- **Session Layer Concept (above TCP/IP model layer 4):**  
    Typically implemented at higher layers or by application protocols (e.g., session cookies, tokens in HTTP headers).
- **Authentication in Application Layer:**  
    Auth token included in HTTP headers ("Authorization: Bearer ...") enables server to identify and validate client session.
- **Session Tracking:**  
    Server uses token or cookie to store session state; TCP itself does not include this but relies on ports/sequence numbers for connection state.
- For example, the session ID or token travels _inside_ the HTTP header payload, not as part of TCP/IP headers.
## Summary Table Example

| Layer           | Header Fields (example)                                  | Data/Function                                 |
| --------------- | -------------------------------------------------------- | --------------------------------------------- |
| Application     | HTTP headers: Host, Authorization, Content-Length        | Actual message "Hello", authentication tokens |
| Transport (TCP) | Src Port: 54321, Dst Port: 80, Seq: 1001, Flags          | Segmentation, ordering, reliability info      |
| Internet (IP)   | Src IP: 192.168.1.10, Dst IP: 203.0.113.5, Protocol: TCP | Routing, addressing                           |
| Link (Ethernet) | Src MAC: 00:1A:2B..., Dst MAC: 00:1A:2B..., EtherType    | Local network delivery                        |
| Physical        | Bits on cable/wire                                       | Electrical/optical signals                    |
 it is possible to **interpret and analyze network packets** as they travel through the network, including examining contents like authentication information, but with some important considerations:

## Packet Visibility and Authentication Data

- **Packet Capture Tools** like Wireshark or tcpdump can intercept and display packets on the network, showing headers and payload data up to the application layer.
- Since **authentication information is usually part of the application layer payload** (e.g., HTTP headers like "Authorization: Bearer ...", cookies, or tokens), these are inside the packet payload encapsulated by lower layers (TCP/IP).
- To see and interpret these, the capture tool must decode the packet fully up to the application layer.
## Challenges with Authentication Data Interpretation

- **Encryption**: Most modern protocols use encryption (HTTPS/TLS), so authentication tokens and messages are encrypted inside the payload. Without the encryption keys, the packet capture tools cannot interpret this data; it appears as cipher-text.
- **Unencrypted Protocols**: For protocols without encryption (e.g., HTTP, FTP), authentication headers (like basic auth, tokens) are transmitted in plain text and can be seen directly in packet captures.
- **Session Context**: Authentication state (tokens, cookies) is typically part of the application payload, verified by the receiver after reassembly across multiple packets.
## Practical Use in Troubleshooting and Analysis

- Capture and analyze packets at client or server: you can view communication setups and session establishment attempts.
- Inspect header fields for source/destination IP, ports, TCP flags, sequence numbers to verify if the session/conversation is aligned.
- For encrypted traffic, capture tools and logs on endpoints are needed to interpret the decrypted data.
- Application-layer logs confirm authentication success or failure since the network packets alone may not provide decrypted authentication info.
## Detailed Explanation of TCP Handshake in TCP/IP Model

## Role in TCP/IP Model

- TCP operates at the **Transport Layer** (Layer 4 in OSI and TCP/IP stack), providing reliable, ordered, and error-checked delivery of data.
- The handshake establishes synchronization between the two endpoints, agreeing on initial sequence numbers and confirming readiness, ensuring that both sides can manage the data transfer reliably.
- This handshake is crucial because TCP is connection-oriented — unlike UDP — requiring connection setup before data transmission.
## The Three Steps in TCP Handshake

1. **SYN (Synchronize)**
    
    - The client initiates the connection by sending a TCP segment with the SYN flag set.
    - It picks an initial sequence number (ISN), say 1000, indicating where byte counting will begin for data sent by the client.
    - This message tells the server: “I want to start a connection and here is my sequence number.”
        
2. **SYN-ACK (Synchronize-Acknowledge)**

    - The server receives the SYN segment from the client.
    - The server responds with a TCP segment having both SYN and ACK flags set.
        
    - It acknowledges the client’s ISN by setting ACK number to client’s ISN + 1 (i.e., 1001).
    - It picks its own ISN (e.g., 2000) for the server-to-client byte stream.
    - This means: “I acknowledge your request and sequence number, here is mine. Let’s sync.”
        
3. **ACK (Acknowledge)**
    
    - The client receives the SYN-ACK from the server.
    - It sends back an ACK segment, acknowledging the server’s ISN with ACK number = server’s ISN + 1 (i.e., 2001).
    - This finalizes synchronization: “I acknowledge your sequence number, connection established.”
## Visual Timeline Example

|Step|Host|Packet Type|Flags|Sequence Number|Acknowledgment Number|Meaning|
|---|---|---|---|---|---|---|
|1|Client|SYN|SYN=1|1000|—|Start connection, ISN=1000|
|2|Server|SYN-ACK|SYN=1, ACK=1|2000|1001|Ack client's ISN, send own ISN=2000|
|3|Client|ACK|ACK=1|1001|2001|Ack server's ISN|
## Real-Time Example

- When a browser connects to a web server over HTTP or HTTPS, the client (browser) initiates the TCP handshake first.
- DNS resolves the server IP, then the browser sends a SYN packet to the server on port 80 (HTTP) or 443 (HTTPS).
- The server responds with SYN-ACK.
- The browser completes with an ACK.
- After this handshake, the HTTP request (GET, POST) is sent over the established connection.
- This handshake ensures reliable, ordered delivery and sets up sequence numbers used to track data segments and retransmit lost packets.

## Packet Flow Recap with Handshake Context (simplified)

 The **checksum** and **packet identifiers** are indeed part of the TCP header in the packets transferred between systems. They play critical roles in ensuring the integrity and proper sequencing of data.

| Step | Packet Type      | Payload | Seq Number | Implication                                        |
| ---- | ---------------- | ------- | ---------- | -------------------------------------------------- |
| 1    | SYN              | None    | 1000       | Start connection, no data                          |
| 2    | SYN-ACK          | None    | 2000       | Server ready, no data                              |
| 3    | ACK              | None    | 1001       | Client confirms connection                         |
| 4    | Data (HTTP POST) | "Hello" | 1001       | Actual data transfer starts; sequence synchronized |
## What Does the Checksum Cover?

- The **checksum** is calculated over:
    1. The entire TCP header.
    2. The TCP payload (in this case, "Hello").
    3. A **pseudo-header** containing essential IP-layer info (Source IP, Destination IP, Protocol, TCP segment length).
        
- This combined checksum helps detect errors during transmission across layers.
## Example: TCP Segment Carrying "Hello"

Assuming this is the first data segment sent after handshake with:

- Sequence Number: 1001
- Source Port: 54321
- Destination Port: 80
- Pseudo-header from IP addresses: Source 192.168.1.10, Dest 203.0.113.5
The TCP packet looks like:
```text
TCP Header {
  Src Port: 54321,
  Dst Port: 80,
  Seq Number: 1001,
  Ack Number: (depends on handshake/flow),
  Flags: PSH, ACK,
  Window Size: 65535,
  Checksum: 0x1a2b   <- calculated over header+pdu+pseudo-header
}
Payload: "Hello"

```
## Purpose and Workflow

- When the sender prepares this segment, it calculates the checksum by summing all 16-bit words in the TCP header, the payload ("Hello"), and the pseudo-header, using one’s complement arithmetic.
- This checksum field is inserted into the TCP header before transmission.
- Upon receipt, the receiver performs the **same checksum calculation** over the received segment, including header and data.
- If the calculated checksum matches the checksum value in the header, the data is considered **valid and intact**.
- If not, the segment is discarded or a retransmission is requested, ensuring **reliability**.