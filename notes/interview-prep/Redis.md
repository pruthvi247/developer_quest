**What are the main data structures Redis supports, and when would you use each?**
- For caching, use **String**.
- For queuing tasks, use **List**.
- For de-duplicating, use **Set**.
- For ranking, use **Sorted Set**.
- For object-like storage, use **Hash**.
- For tracking bits or unique element counters, use **Bitmap** or **HyperLogLog**.
- For logs or channels, use **Stream**.
- For location queries, use **Geospatial Indexes**.
- For advanced search, use **Vector Sets**.[](https://redis.io/docs/latest/develop/data-types/)

**How does Redis differ from traditional databases like MongoDB or Postgres? Why is it so fast?**
- **Redis:** In-memory key-value store. All data lives in RAM for super-fast access; it can optionally persist to disk for durability.
-  **MongoDB/Postgres:** Disk-based. Both store data primarily on disk (hard drive or SSD), which is much slower to read/write than RAM.
- **Redis:** Used for caching, session storage, leaderboards, queue systems, real-time analytics—where speed is critical and data sets are “hot” (frequently accessed).
- **Single-Threaded Event Loop:** Redis processes requests with a single-threaded event loop, avoiding concurrency overhead (no locks, no waits). This ensures consistently low latency and high throughput.[](https://blog.algomaster.io/p/why-is-redis-so-fast-and-efficient)

**Explain the difference between Redis persistence mechanisms — RDB and AOF. What are the trade-offs?**

**RDB (Redis Database) and backup**
- **How it works:**  
    RDB creates point-in-time snapshots of your Redis dataset at configurable intervals (e.g., every X minutes or after Y writes). Each snapshot is a compact binary file saved to disk.[](https://www.geeksforgeeks.org/system-design/does-redis-persist-data/)
    saves it to a binary dump file (`dump.rdb`)
**AOF (Append Only File)**
- **How it works:**  
    AOF logs every write operation performed by the server to a file in real-time (append-only). Upon restart, Redis replays all operations from the AOF log to reconstruct the dataset
    - Every write operation is **logged to a file** (`appendonly.aof`).
**How would you use Redis Pub/Sub, and what are common use cases?**

Redis Pub/Sub implements a real-time, fire-and-forget messaging system where messages are published to channels, and any clients subscribed to those channels immediately receive the messages.[](https://redis.io/docs/latest/develop/pubsub/)

`` How Redis Pub/Sub Works`

- **Publishing:**  
    Use the `PUBLISH` command to send a message to a named channel.
- **Subscribing:**  
    Clients use `SUBSCRIBE` to listen to messages on specified channels or `PSUBSCRIBE` for pattern-based subscriptions.
```bash
PUBLISH channel message
SUBSCRIBE channel [channel ...]
PSUBSCRIBE pattern [pattern ...]
UNSUBSCRIBE channel [channel ...]
PUNSUBSCRIBE pattern [pattern ...]

```
NOTE: 
> Rabitmq: Guaranteed delivery with acknowledgments (ACK/NACK). Supports retries and dead-letter queues.
> Redis : Fire-and-forget model without delivery guarantees; subscribers must be connected or messages are lost.

| Feature                         | RabbitMQ                                                                                           | Redis Pub/Sub                                                                                                 |
| ------------------------------- | -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| **Message Delivery Guarantees** | Guaranteed delivery with acknowledgments (ACK/NACK). Supports retries and dead-letter queues.      | Fire-and-forget model without delivery guarantees; subscribers must be connected or messages are lost.        |
| **Persistence**                 | Supports persistent messages; messages can be stored on disk to prevent loss.                      | No built-in message persistence by default; only in-memory with optional snapshots that are not real-time.    |
| **Routing**                     | Advanced routing capabilities with exchanges, queues, and routing keys. Supports complex patterns. | Simple publish/subscribe on named channels or pattern subscriptions; no routing rules.                        |
| **Message Size**                | Handles messages up to 128 MB efficiently, with paging for large messages.                         | No hard limit but performance degrades beyond ~1 MB per message. Typically used for small, frequent messages. |
**What is a Redis eviction policy? Can you name a few and explain when to use which?**

## Common Redis Eviction Policies and When to Use Them

1. **noeviction**
    - Redis returns an error on writes once memory is full; no data is evicted.
    - _Use case:_ When you want strict control and avoid losing data, though this can cause write failures.    
2. **allkeys-lru (Least Recently Used)**
    - Evicts the least recently accessed keys across all keys (regardless of expiration).
    - _Use case:_ Suitable for caching scenarios where recently used data should stay, and old unused data can be removed.
3. **volatile-lru**
    - Evicts the least recently used keys only among those with an expiration (TTL) set.
    - _Use case:_ When you want to evict keys that are meant to expire first, while preserving keys without TTL.
4. **allkeys-lfu (Least Frequently Used)**
    - Evicts keys that are accessed least frequently across the entire dataset.
    - _Use case:_ When popularity/frequency is a better indicator of key value than recency, such as in popularity-based caches.
5. **volatile-lfu**
    - Same as allkeys-lfu but only applies to keys with an expiration.
    - _Use case:_ Focus eviction on rarely accessed expiring keys.

6. **allkeys-random**
    - Randomly evicts any key to free memory.
    - _Use case:_ Simple and fast, but less precise; useful when uniform eviction is acceptable.
        
7. **volatile-random**
    - Randomly evicts keys with an expiration.
    - _Use case:_ Similar to allkeys-random but only for expiring data.
8. **volatile-ttl**
    - Evicts keys with the shortest time to live first (those about to expire).
    - _Use case:_ When you want to prioritize removing keys that will naturally expire soon.

**Provide use-cases where locking can be used in redis**
`Idempotency and de-duplication`
- Prevent duplicate order processing: Lock per orderId or paymentIntentId so retries or concurrent consumers don’t double-charge or ship twice.
`Data consistency around hot keys/entities`
- Inventory/stock decrements: Lock per skuId to prevent overselling under high concurrency.
`E-commerce/orderlifecycle`
- Coupon/one-time token usage: Lock on couponCode to ensure only one redemption wins.
AcquireLock:
```
SET resource_lock unique_token NX PX 30000

```

**Explain Redis Cluster vs Sentinel. How do they handle high availability and partitioning?**

` Redis Sentinel`
- **Purpose:** Provides high availability for Redis instances using a master-replica architecture without sharding.

 `Redis Cluster`
- **Purpose:** Provides both high availability **and** automatic data partitioning (sharding) across multiple nodes.

**Imagine your Redis cache hit ratio is low — how would you diagnose and improve it?**

If your Redis cache hit ratio is low, it means many requests are missing the cache and going to the underlying data store, reducing the cache effectiveness. Here’s how to diagnose and improve cache hit ratio:
- Use Redis commands like `INFO stats` to check `keyspace_hits` and `keyspace_misses`. (Cache metrics)

**If Redis is being used as a cache in front of MongoDB, how do you ensure cache consistency after a write/update?**




