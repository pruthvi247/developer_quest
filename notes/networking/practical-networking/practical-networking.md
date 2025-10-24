![[Pasted image 20250908125127.png]]
![[Pasted image 20250908125309.png]]
Source : [TLS handshake-practical networking](https://www.youtube.com/watch?v=ZkL10eoG1PY&list=PLIFyRwBY_4bTwRX__Zn4-letrtpSj1mzY&index=19)

## Everything that happens when you visit an https
## 1. ClientHello

- The browser (client) initiates the handshake.
- It sends a **ClientHello** message to the server, which includes:
    - Supported TLS protocol versions (e.g., TLS 1.2, 1.3)
    - Supported cipher suites (encryption algorithms)
    - Supported compression methods
    - A random number (Client Random)
    - Optional: SNI (Server Name Indication), extensions
        
- This step tells the server what security features the client supports.[](https://auth0.com/blog/the-tls-handshake-explained/)

![[Pasted image 20250908155014.png]]
## 2. ServerHello

- The server receives the ClientHello and replies with a **ServerHello** message, which contains
    - Chosen TLS version and cipher suite
    - A random number (Server Random)
    - Session ID
    - Server certificate (with the server’s public key, signed by a trusted CA)
    - Optional: request for client certificate (for mutual TLS)
- Now both client and server know which encryption methods they will use.[](https://www.globalsign.com/en/blog/all-about-tls-handshakes)
![[Pasted image 20250908155321.png]]
![[Pasted image 20250908155510.png]]
## 3. Certificate Validation

- The client checks the server’s certificate:
    - Verifies the certificate is signed by a trusted Certificate Authority (CA)
    - Validates the server’s domain matches the certificate
    - Ensures the certificate is not expired or revoked
- Only if all checks pass does the handshake proceed.[](https://auth0.com/blog/the-tls-handshake-explained/)
![[Pasted image 20250908155753.png]]
## 4. Key Exchange and Pre-Master Secret

- The client generates a **pre-master secret** (a random number).
- The client encrypts this pre-master secret using the server’s **public key** (from the certificate) and sends it to the server.
- The server decrypts the pre-master secret using its **private key**.
- Both client and server now have: Client Random, Server Random, and Pre-Master Secret.
- Using these, both derive the **master secret** and then derive session keys for encryption and MAC (Message Authentication Code).[](https://www.geeksforgeeks.org/computer-networks/what-is-ssl-tls-handshake/)

![[Pasted image 20250908161506.png]]


At this point, both parties have identical session keys
But client/server don't know whether the other has the same keys
- Rest of the handshake will prove to both parties that the other party has the correct session keys
## 5. ChangeCipherSpec and Finished Messages

- The client sends a **ChangeCipherSpec** message—"Let’s switch to encrypted mode using our negotiated session keys."
- The client then sends a **Finished** message, encrypted with the session key, as proof that encryption is working and keys are correct.
- The server responds with its own **ChangeCipherSpec** and **Finished** messages.
- Both parties verify the finished messages to confirm they share the same encryption keys and hash of previous messages.
- 
![[Pasted image 20250908163242.png]]

## 6. Secure Communication Begins

- The handshake is complete!
- From this point, all data between browser and server travels encrypted using symmetric session keys (fast, efficient).
- Session keys are temporary (ephemeral)—discarded after the session closes, supporting forward secrecy in modern TLS versions.[](https://www.globalsign.com/en/blog/all-about-tls-handshakes)
![[Pasted image 20250908163622.png]]
![[Pasted image 20251007115740.png]]