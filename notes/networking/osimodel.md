[Open Systems Interconnection](https://blog.bytebytego.com/p/network-protocols-run-the-internet?utm_source=post-email-title&publication_id=817132&post_id=128408371&isFreemail=true&utm_medium=email)

The diagram below shows what each layer does in the OSI model. Each intermediate layer serves a class of functionality to the layer above it and is served by the layer below it. Let’s review them.


![[Pasted image 20230616100225.png]]
1. Application Layer
    

The application layer is the closest to the end users. Most applications reside in this layer. We request data from a backend server without needing to understand data transmission specifics. Protocols in this layer include HTTP, SMTP, FTP, DNS, etc. We will cover them later.

2. Presentation Layer
    

This layer handles data encoding, encryption, and compression, preparing data for the application layer. For example, HTTPS leverages TLS (Transport Layer Security) for secure communications between clients and servers. 

3. Session Layer
    

This layer opens and closes the communications between two devices. If the data size is large, the session layer sets a checkpoint to avoid resending from the beginning.

4. Transport Layer
    

This layer handles end-to-end communication between the two devices. It breaks data into segments at the sender’s side and reassembles them at the receiver’s. There is flow control in this layer to prevent congestion. Key protocols in this layer are TCP and UDP, which we’ll discuss later.

5. Network Layer
    

This layer enables data transfer between different networks. It further breaks down segments or datagrams into smaller packets and finds the optimal route to the final destination using IP addresses. This process is known as routing.

6. Data Link Layer
    

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




