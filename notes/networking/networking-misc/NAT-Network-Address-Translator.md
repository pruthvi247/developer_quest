![[Pasted image 20260202142136.png]]
That magic is handled by NAT (Network Address Translation), one of the silent workhorses of modern networking. It’s the reason IPv4 hasn’t run out completely, and why your router can hide dozens of devices behind a single public IP.

- The Core Idea: Inside your local network, devices use private IP addresses that never leave your home or office. Your router, however, uses a single public IP address when talking to the outside world.
    

NAT rewrites each outbound request so it appears to come from that public IP address, assigning a unique port mapping for every internal connection.

Outbound NAT (Local to Internet)

When a device sends a request:

- NAT replaces the private IP address with the public one
- Assigns a unique port so it can track the connection
- Sends the packet out to the internet as if it originated from the router
    

Reverse NAT (Internet to Local)

When the response returns:

- NAT checks its translation table
- Restores the original private IP address and port
- Delivers the packet to the correct device on the local network