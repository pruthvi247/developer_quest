![[Pasted image 20260429120152.png]]


- Polling: The client sends a request every few seconds asking "anything new?" The server responds immediately, whether or not there's new data. Most of those requests come back empty, wasting client and server resources. For use cases like an order status page where a small delay is acceptable, polling is the simplest option to implement.
    
- Long Polling: The client sends a request, and the server keeps the HTTP connection open until new data is available or a timeout occurs. This means fewer empty responses compared to regular polling. Some chat applications used this pattern to deliver messages closer to real-time communication.
    
- Server-Sent Events (SSE): The client opens a persistent HTTP connection, and the server streams events through it as they're generated. It is one-way, lightweight, and built on plain HTTP. Many AI responses that appear token by token are delivered through SSE, streaming each chunk over a single open connection.  
    
- Webhooks: Instead of the client asking for updates, the service sends an HTTP POST to a pre-registered callback URL whenever a specific event occurs. Stripe uses this for payment confirmations. GitHub uses it for push events. The client never polls or holds a connection open, it just waits for the server to call.
    

Many systems don't rely on a single pattern. You may use polling for order status, SSE for streaming AI responses, and webhooks for payment confirmations.

![[Pasted image 20260429120309.png]]

- SLI (Service Level Indicator): This is the metric you're measuring. For a login service, it could be the ratio of successful login requests to total valid requests. It tells you how your service is performing right now.
    
- SLO (Service Level Objective): You take that SLI and define a target around it. Something like "login availability should stay above 99.9% over a rolling 28-day window." When you're missing your SLO, it’s a signal to find out what's failing before customers notice.
    
- SLA (Service Level Agreement): This is what you promise your customers in a contract. It's usually set lower than the SLO, say 99.5% monthly availability. If you breach it, you owe service credits.
    

If your SLO and SLA are both set to 99.9%, then the moment your availability drops below 99.9%, you've already breached the agreement.

The SLI tells you where you stand. The SLO tells you where you should be. The SLA tells your customers what they can expect.

Over to you: How do you decide what the right SLO target is when you're launching a new service?
