[source-bytebytego]()
![[Pasted image 20240603103643.png]]
- Linear Backoff  
    Linear backoff involves waiting for a progressively increasing fixed interval between retry attempts.    
    Advantages: Simple to implement and understand.    
    Disadvantages: May not be ideal under high load or in high-concurrency environments as it could lead to resource contention or "retry storms".  
- Linear Jitter Backoff  
    Linear jitter backoff modifies the linear backoff strategy by introducing randomness to the retry intervals. This strategy still increases the delay linearly but adds a random "jitter" to each interval.    
    Advantages: The randomness helps spread out the retry attempts over time, reducing the chance of synchronized retries across instances.    
    Disadvantages: Although better than simple linear backoff, this strategy might still lead to potential issues with synchronized retries as the base interval increases only linearly.  
- Exponential Backoff  
    Exponential backoff involves increasing the delay between retries exponentially. The interval might start at 1 second, then increase to 2 seconds, 4 seconds, 8 seconds, and so on, typically up to a maximum delay. This approach is more aggressive in spacing out retries than linear backoff.    
    Advantages: Significantly reduces the load on the system and the likelihood of collision or overlap in retry attempts, making it suitable for high-load environments.    
    Disadvantages: In situations where a quick retry might resolve the issue, this approach can unnecessarily delay the resolution.  
- Exponential Jitter Backoff  
    Exponential jitter backoff combines exponential backoff with randomness. After each retry, the backoff interval is exponentially increased, and then a random jitter is applied. The jitter can be either additive (adding a random amount to the exponential delay) or multiplicative (multiplying the exponential delay by a random factor).  
    Advantages: Offers all the benefits of exponential backoff, with the added advantage of reducing retry collisions even further due to the introduction of jitter.  
    Disadvantages: The randomness can sometimes result in longer than necessary delays, especially if the jitter is significant.

**Cross-site scripting (XSS)** is an attack in which an attacker injects malicious executable scripts into the code of a trusted application or website. Attackers often initiate an XSS attack by sending a malicious link to a user and enticing the user to click it. If the app or website lacks proper data sanitization, the malicious link executes the attacker’s chosen code on the user’s system. As a result, the attacker can steal the user’s active session cookie.

![[Pasted image 20250120101300.png]]

1. First up, you type the website address in the browser’s address bar.
    
2. The browser checks its cache first. If there’s a cache miss, it must find the IP address.
    
3. DNS lookup begins (think of it as looking up a phone number). The request goes through different DNS servers (root, TLD, and authoritative). Finally, the IP address is retrieved.
    
4. Next, your browser initiates a TCP connection like a handshake. For example, in the case of HTTP 1.1, the client and server perform a TCP three-way handshake with SYN, SYN-ACK, and ACK messages.
    
5. Once the handshake is successful, the browser makes an HTTP request to the server and the server responds with HTML, CSS, and JS files.
    
6. Finally, the browser processes everything. It parses the HTML document and creates DOM and CSSOM trees.
    
7. The browser executes the JavaScript and renders the page through various steps (tokenizer, parser, render tree, layout, and painting).
    
8. Finally, the webpage appears on your screen.

![[Pasted image 20260101123552.png]]
![[Pasted image 20260101123618.png]]