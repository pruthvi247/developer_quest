
![[Pasted image 20250821164752.png]]
### How do you manage environment variables in Node.js?

**Model Answer:**

- Use `process.env`.
- For local dev → use `dotenv` package.
- Never commit `.env` to git.
- Use secrets manager (Vault, AWS Secrets Manager) in prod.

### What is clustering in Node.js and when would you use it?

Node.js clustering is a built-in solution to overcome the **single-threaded limitation** of Node.js by creating multiple worker processes that share the same server port. Let's dive deep into when, why, and how to use it effectively.

## 1. The Problem: Why Do We Need Clustering?

## **Single Process Problem**

```js
// app.js - Single process (Normal Node.js app)
const express = require('express');
const app = express();

console.log(`Process ID: ${process.pid}`);
console.log(`Available CPU cores: ${require('os').cpus().length}`);

// This blocks EVERYTHING for 5 seconds
app.get('/slow', (req, res) => {
    console.log('Starting slow task...');
    
    // Simulate heavy work (like image processing)
    const start = Date.now();
    while (Date.now() - start < 5000) {
        // Busy waiting for 5 seconds
    }
    
    res.json({ message: 'Slow task done!', pid: process.pid });
});

// This should be fast, but gets blocked by /slow
app.get('/fast', (req, res) => {
    res.json({ message: 'Fast response!', pid: process.pid });
});

app.listen(3000, () => {
    console.log('Server running on port 3000');
});

```

**Test this:**

1. Start the server: `node app.js`
2. Open two browser tabs
3. Go to `http://localhost:3000/slow` in first tab
4. Quickly go to `http://localhost:3000/fast` in second tab
5. **Problem**: The "fast" request waits until "slow" is done!
## 2. Simple Clustering Solution

## **Basic Cluster Example**

```js
// cluster-app.js - Multiple processes
const cluster = require('cluster');
const express = require('express');
const os = require('os');

// Check if this is the main process
if (cluster.isMaster) {
    // Main process - creates worker processes
    console.log(`Main process ${process.pid} starting...`);
    
    const numWorkers = os.cpus().length; // Number of CPU cores
    console.log(`Creating ${numWorkers} workers`);
    
    // Create one worker for each CPU core
    for (let i = 0; i < numWorkers; i++) {
        cluster.fork();
    }
    
    // If a worker crashes, create a new one
    cluster.on('exit', (worker) => {
        console.log(`Worker ${worker.process.pid} died, creating new worker`);
        cluster.fork();
    });
    
} else {
    // Worker process - runs the actual app
    const app = express();
    
    app.get('/slow', (req, res) => {
        console.log(`Worker ${process.pid} handling slow request`);
        
        // Same 5-second task
        const start = Date.now();
        while (Date.now() - start < 5000) {
            // Busy work
        }
        
        res.json({ 
            message: 'Slow task done!', 
            worker: process.pid 
        });
    });
    
    app.get('/fast', (req, res) => {
        console.log(`Worker ${process.pid} handling fast request`);
        res.json({ 
            message: 'Fast response!', 
            worker: process.pid 
        });
    });
    
    app.listen(3000, () => {
        console.log(`Worker ${process.pid} listening on port 3000`);
    });
}

```

-------

### Step by step code walk through
```js
 // When you run: node cluster-app.js

console.log('🚀 Starting application...');

// STEP 1: Node.js checks - "Am I the master process?"
if (cluster.isMaster) {
    // ✅ YES - This is the FIRST time running, so this IS the master
    
    console.log(`Main process ${process.pid} starting...`);
    // Output: "Main process 1234 starting..."
    
    const numWorkers = os.cpus().length; // Let's say you have 4 CPU cores
    console.log(`Creating ${numWorkers} workers`);
    // Output: "Creating 4 workers"
    
    // STEP 2: Master creates 4 separate Node.js processes
    for (let i = 0; i < numWorkers; i++) {
        cluster.fork(); // This creates a NEW Node.js process
    }
    
    // What happens during cluster.fork():
    // - Node.js starts a NEW process
    // - Runs the SAME file (cluster-app.js) again
    // - But in the new process, cluster.isMaster = FALSE
}

```
```text
Time 0ms:  Master Process (PID: 1234) starts
Time 10ms: Master calls cluster.fork() → Worker 1 (PID: 5678) starts
Time 20ms: Master calls cluster.fork() → Worker 2 (PID: 9012) starts  
Time 30ms: Master calls cluster.fork() → Worker 3 (PID: 3456) starts
Time 40ms: Master calls cluster.fork() → Worker 4 (PID: 7890) starts

```

## 2. What Happens in Each Worker Process

### **Worker Process Execution**
👉 Worker = parallel computation, Child Process = running separate apps/scripts.

```ts
// Each worker runs the SAME code, but cluster.isMaster = false

if (cluster.isMaster) {
    // ❌ SKIPPED - because this is a worker, not master
    
} else {
    // ✅ WORKER CODE RUNS HERE
    
    console.log('Worker process starting...');
    const app = express();
    
    // Each worker creates its OWN Express server
    app.get('/slow', (req, res) => {
        // This code exists in ALL 4 workers
    });
    
    app.get('/fast', (req, res) => {
        // This code exists in ALL 4 workers
    });
    
    // IMPORTANT: All 4 workers listen on the SAME port (3000)
    app.listen(3000, () => {
        console.log(`Worker ${process.pid} listening on port 3000`);
    });
    // Output from each worker:
    // "Worker 5678 listening on port 3000"
    // "Worker 9012 listening on port 3000" 
    // "Worker 3456 listening on port 3000"
    // "Worker 7890 listening on port 3000"
}

```

complete console output when starting
```text
Main process 1234 starting...
Creating 4 workers
Worker 5678 listening on port 3000
Worker 9012 listening on port 3000
Worker 3456 listening on port 3000
Worker 7890 listening on port 3000
```
## 3. How Node.js Routes Requests to Workers

## **The Magic: Built-in Load Balancer**

```js
// When a request comes to http://localhost:3000/slow

// Node.js has a BUILT-IN load balancer that decides which worker handles the request
// This happens AUTOMATICALLY - you don't need to write any code for it!

/*
REQUEST ROUTING ALGORITHM (Round Robin by default):

Request 1 → Worker 5678
Request 2 → Worker 9012  
Request 3 → Worker 3456
Request 4 → Worker 7890
Request 5 → Worker 5678 (back to first worker)
Request 6 → Worker 9012
...and so on
*/
```

```js
// Scenario: 3 requests come in quickly

// 🌐 Request 1: GET /slow
// Node.js internal load balancer: "Send to Worker 5678"
// Worker 5678 executes:
app.get('/slow', (req, res) => {
    console.log(`Worker ${process.pid} handling slow request`);
    // Output: "Worker 5678 handling slow request"
    
    const start = Date.now();
    while (Date.now() - start < 5000) {
        // Worker 5678 is now BUSY for 5 seconds
    }
    
    res.json({ message: 'Slow task done!', worker: process.pid });
});

// 🌐 Request 2: GET /fast (comes in 1 second later)
// Node.js: "Worker 5678 is busy, send to Worker 9012"
// Worker 9012 executes:
app.get('/fast', (req, res) => {
    console.log(`Worker ${process.pid} handling fast request`);
    // Output: "Worker 9012 handling fast request"
    
    res.json({ message: 'Fast response!', worker: process.pid });
    // This responds immediately!
});

// 🌐 Request 3: GET /slow (comes in 2 seconds later)
// Node.js: "Worker 5678 still busy, Worker 9012 free, send to Worker 9012"
// OR it might choose Worker 3456 or 7890 - depends on the algorithm

```
## 4. How Node.js Knows Which Worker to Pick

## **Internal Load Balancing Mechanism**

```js
// Node.js keeps track of each worker's status internally

/*
SIMPLIFIED INTERNAL STATE (not real code, just for understanding):

workers = {
    5678: { status: 'busy', activeRequests: 1 },
    9012: { status: 'free', activeRequests: 0 },
    3456: { status: 'free', activeRequests: 0 },
    7890: { status: 'free', activeRequests: 0 }
}

When new request comes:
1. Check which workers are available
2. Use round-robin algorithm to pick next worker
3. Send request to that worker
*/

// The algorithm (simplified):
function pickWorker(availableWorkers) {
    // Round-robin: pick next worker in sequence
    currentWorkerIndex = (currentWorkerIndex + 1) % availableWorkers.length;
    return availableWorkers[currentWorkerIndex];
}
```
## 5. When New Workers Are Created

## **Worker Crash Scenario**
```js
// This part of the master process watches for worker crashes
cluster.on('exit', (worker) => {
    console.log(`Worker ${worker.process.pid} died, creating new worker`);
    cluster.fork(); // Create replacement worker
});

// Example scenario:
// Worker 5678 crashes (maybe due to an unhandled error)

/*
WHAT HAPPENS:
1. Worker 5678 process dies
2. Master process detects the 'exit' event  
3. Master immediately creates a new worker (maybe PID 1111)
4. New worker starts listening on port 3000
5. Load balancer now has workers: 9012, 3456, 7890, 1111
*/

```
## Simplified internal flow
```text
Internet Request → Port 3000 (Master listens here)
                      ↓
               Master Load Balancer  
                      ↓
          Picks available worker (Round Robin)
                      ↓  
              Sends request to chosen worker
                      ↓
               Worker processes request
                      ↓
               Worker sends response back
                      ↓
              Response goes to client

```

> Note:   
When a worker process crashes in a Node.js cluster, the ongoing request that was being handled by that worker does not automatically resume in a new worker; instead, the user has to send a new request, as the crash terminates the worker's process and any in-progress request without server-side session or request persistence.



## The Event Loop Explained Simply

## **How Node.js Handles Multiple Things**
```js
// event-loop-demo.js
console.log('🚀 Program starts');

// 1. Immediate operations (run first)
console.log('⚡ This runs immediately');

// 2. Timer operations (scheduled)
setTimeout(() => {
    console.log('⏰ Timer 1: 0ms timeout');
}, 0);

setTimeout(() => {
    console.log('⏰ Timer 2: 1000ms timeout'); 
}, 1000);

// 3. I/O operations (file/network)
require('fs').readFile('./package.json', () => {
    console.log('📁 File read completed');
});

// 4. Immediate callback (higher priority than timers)
setImmediate(() => {
    console.log('🔥 setImmediate callback');
});

// 5. Process next tick (highest priority)
process.nextTick(() => {
    console.log('⚡ process.nextTick callback');
});

console.log('🏁 Program end (but not really!)');

```

`output`
```text
🚀 Program starts
⚡ This runs immediately  
🏁 Program end (but not really!)
⚡ process.nextTick callback     ← Highest priority
🔥 setImmediate callback         ← Next priority
⏰ Timer 1: 0ms timeout         ← Timers
📁 File read completed          ← I/O operations
⏰ Timer 2: 1000ms timeout      ← After 1 second

```
### Explain the Node.js event-driven architecture.
```js
// Traditional (blocking) approach - like a bad chef
function badChef() {
    console.log("Order 1: Making pasta...");
    cookPasta(); // Takes 10 minutes, chef does NOTHING else
    
    console.log("Order 2: Making salad...");  
    makeSalad(); // Takes 5 minutes, chef waits again
    
    console.log("Order 3: Making pizza...");
    makePizza(); // Takes 15 minutes, more waiting
}

// Event-driven approach - like a smart chef  
function smartChef() {
    console.log("Order 1: Starting pasta, will notify when done");
    startPasta(() => console.log("Pasta ready!"));
    
    console.log("Order 2: Starting salad, will notify when done");
    startSalad(() => console.log("Salad ready!"));
    
    console.log("Order 3: Starting pizza, will notify when done");
    startPizza(() => console.log("Pizza ready!"));
    
    // Chef can do other things while food cooks
    console.log("Cleaning kitchen while waiting...");
}

```
**Blocking vs Non-Blocking File Reading**
```js
// file-example.js
const fs = require('fs');

console.log('=== BLOCKING APPROACH (BAD) ===');
console.log('1. Starting to read file...');

// ❌ This blocks everything until file is read
const data1 = fs.readFileSync('large-file.txt', 'utf8');
console.log('2. File read complete, length:', data1.length);

console.log('3. This runs AFTER file reading');
console.log('4. Everything else waits');

console.log('\n=== NON-BLOCKING APPROACH (GOOD) ===');
console.log('1. Starting to read file...');

// ✅ This doesn't block - continues immediately
fs.readFile('large-file.txt', 'utf8', (err, data2) => {
    if (err) {
        console.log('❌ Error reading file:', err.message);
        return;
    }
    console.log('📁 File read complete, length:', data2.length);
});

console.log('2. This runs IMMEDIATELY (doesn\'t wait for file)');
console.log('3. Program continues while file loads in background');

// This also runs immediately
setTimeout(() => {
    console.log('⏰ Timer finished while file was still loading');
}, 1000);

```
`output`
```text
=== BLOCKING APPROACH (BAD) ===
1. Starting to read file...
2. File read complete, length: 50000          (waits here)
3. This runs AFTER file reading
4. Everything else waits

=== NON-BLOCKING APPROACH (GOOD) ===
1. Starting to read file...
2. This runs IMMEDIATELY (doesn't wait for file)
3. Program continues while file loads in background  
⏰ Timer finished while file was still loading      (1 second later)
📁 File read complete, length: 50000               (whenever file finishes)

```
# Event Loop vs Async/Await vs Callbacks: The Complete Difference

```text
┌─────────────────────────────────────────┐
│            YOUR CODE                    │
│  ┌─────────────┐  ┌─────────────────┐   │
│  │ Async/Await │  │   Callbacks     │   │ ← Programming Patterns
│  └─────────────┘  └─────────────────┘   │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│           EVENT LOOP                    │ ← Underlying Engine
│    (The engine that makes it all work)  │
└─────────────────────────────────────────┘

```

**Simple Analogy:**

- **Event Loop** = The restaurant's kitchen system that manages all orders
- **Callbacks** = Old way of telling the kitchen "call me when food is ready"
- **Async/Await** = Modern way of saying "I'll wait here until food is ready"
### What are Streams in Node.js? How are they different from reading a file into memory at once?

**Model Answer:**

- Streams allow **processing data chunk by chunk** instead of loading the entire file/data into memory.
- Types: `Readable`, `Writable`, `Duplex`, `Transform`.
- Example: reading a **1GB file** with `fs.readFile()` would block memory; with streams, you process chunks → efficient and non-blocking.  
    👉 Used in file I/O, HTTP requests/responses, and real-time data processing.


# websockets

  
 In Node.js, real-time communication is typically handled using WebSockets, which enable persistent, bi-directional data flow between client and server. This is ideal for chat apps, live dashboards, multiplayer games, and collaborative tools. Let's walk through a simple example using the popular `socket.io` library, explaining how it works step by step.
**Real-time communication is like:**

- **Traditional**: Knocking on door every minute asking "any mail?"
- **Real-time**: Mailman rings doorbell when mail 

**simple, interview-friendly examples** that you can easily explain and code during an interview.
## **Server Code (websocket-chat.js)**

```js
const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 8080 });

console.log('💬 Chat server running on ws://localhost:8080');

// Store connected clients
const clients = new Set();

wss.on('connection', (ws) => {
    console.log('👋 New user connected');
    clients.add(ws);
    
    // Send welcome message
    ws.send(JSON.stringify({
        type: 'system',
        message: 'Welcome to the chat!'
    }));
    
    // Handle incoming messages
    ws.on('message', (data) => {
        const message = JSON.parse(data);
        console.log('📨 Received:', message);
        
        // Broadcast to all clients
        clients.forEach(client => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(JSON.stringify({
                    type: 'chat',
                    username: message.username,
                    text: message.text,
                    timestamp: new Date().toISOString()
                }));
            }
        });
    });
    
    // Handle disconnect
    ws.on('close', () => {
        console.log('👋 User disconnected');
        clients.delete(ws);
    });
});

```
## **Client Code (index.html)**
```html
<!DOCTYPE html>
<html>
<head>
    <title>Simple Chat</title>
    <style>
        #messages { height: 300px; border: 1px solid #ccc; overflow-y: scroll; padding: 10px; }
        .message { margin: 5px 0; }
        .system { color: blue; font-style: italic; }
        .chat { color: black; }
    </style>
</head>
<body>
    <div id="messages"></div>
    
    <input type="text" id="username" placeholder="Your name" />
    <input type="text" id="messageInput" placeholder="Type message..." />
    <button onclick="sendMessage()">Send</button>

    <script>
        const ws = new WebSocket('ws://localhost:8080');
        
        // Connection opened
        ws.onopen = () => console.log('✅ Connected to chat');
        
        // Receive messages
        ws.onmessage = (event) => {
            const data = JSON.parse(event.data);
            const messages = document.getElementById('messages');
            
            const div = document.createElement('div');
            div.className = `message ${data.type}`;
            
            if (data.type === 'chat') {
                div.textContent = `${data.username}: ${data.text}`;
            } else {
                div.textContent = data.message;
            }
            
            messages.appendChild(div);
            messages.scrollTop = messages.scrollHeight;
        };
        
        // Send message function
        function sendMessage() {
            const username = document.getElementById('username').value;
            const messageInput = document.getElementById('messageInput');
            const text = messageInput.value;
            
            if (username && text) {
                ws.send(JSON.stringify({
                    username: username,
                    text: text
                }));
                messageInput.value = '';
            }
        }
        
        // Send on Enter key
        document.getElementById('messageInput').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') sendMessage();
        });
    </script>
</body>
</html>

```

**Python web socket example**
```python
import asyncio
import websockets

async def echo(websocket, path):
    # 1. TCP connection is already established by the OS networking stack
    # 2. WebSocket handshake happened over HTTP Upgrade request (OSI Layer 7)
    print("🔄 WebSocket connection established")
    async for message in websocket:
        print(f"Client says: {message}")
        
        # 3. Application Layer: sending back framed message over TCP
        await websocket.send(f"Echo: {message}")

async def main():
    # Server listens on port 8765 (TCP Layer)
    async with websockets.serve(echo, "localhost", 8765):
        print("🚀 WebSocket server running on ws://localhost:8765")
        await asyncio.Future()  # run forever

asyncio.run(main())

```
## Important Points to Remember

- **WebSocket runs over TCP** → inherits TCP's reliability and ordered delivery.
- The **initial handshake uses HTTP port 80 or 443**, making it compatible with proxies/firewalls.
- The **WebSocket protocol is application-layer**, providing full-duplex communication.
- It’s a **persistent connection**, unlike HTTP which is stateless and short-lived.
- WebSocket frames are smaller, efficient structures layered on top of TCP bytes stream.
