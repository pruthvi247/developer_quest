**MongoDB’s Aggregation Framework is a powerful tool for transforming and analyzing data within the database.**

- Instead of pulling raw data into the application and processing it there, the framework allows you to build a **pipeline** of stages (similar to Unix pipes).
- Each stage takes input, processes it, and passes the output to the next stage.
`Example`:
```json
{ "customerId": 1, "amount": 200, "status": "completed", "items": ["pen", "book"] }
```
**Task:** Get total revenue per customer for completed orders.
```js
db.orders.aggregate([
  { $match: { status: "completed" } },
  { $group: { _id: "$customerId", totalRevenue: { $sum: "$amount" } } },
  { $sort: { totalRevenue: -1 } }
])

```
**Pagination in mongoDB:**
**1. Offset-Based Pagination**
```js
db.collection.find().skip(20).limit(10);
```
**2. Cursor-Based Pagination (Range Queries Using `_id` or Index Fields)**
- Requires client to keep track of the last seen document ID or cursor.
```js
db.collection.find({ _id: { $gt: lastId } }).limit(10);
```
`Best Practice Recommendations`

- Prefer **cursor-based pagination** for better scalability and efficiency on large datasets.
- Use **offset-based pagination** for simple, small datasets or limited deep paging.

### **Q1: Can you explain what MongoDB is and how it differs from traditional relational databases?**

**Answer (interview-ready):**  
MongoDB is a **NoSQL, document-oriented database** designed to store, query, and manage data in a flexible, scalable way. Instead of tables and rows, MongoDB stores data as **BSON documents** (binary JSON), which allows for nested structures and arrays.

The key differences compared to relational databases (like MySQL, PostgreSQL, Oracle) are:

1. **Schema flexibility:**
    - RDBMS → Schema must be predefined; altering schema is costly.
    - MongoDB → Documents in the same collection can have different fields; schema evolves with business needs.
2. **Data model:**
    - RDBMS → Normalized data, relationships via joins.
    - MongoDB → Denormalized data; relationships often modeled through **embedding** or **referencing** instead of joins.
3. **Scalability:**
    - RDBMS → Vertical scaling (scale-up: bigger machines).
    - MongoDB → Horizontal scaling (sharding across multiple servers).
4. **Transactions:**
    - RDBMS → Strong ACID compliance. (Atomicity, Consistency, Isolation, and Durability)
    - MongoDB → Historically BASE (eventual consistency) but now supports **multi-document ACID transactions** (since v4.0+).
5. **Query Language:**
    - RDBMS → SQL.
    - MongoDB → Query documents using a JSON-like syntax (e.g., `{ age: { $gt: 30 } }`).


👉 **How to pitch it in interview:**  
“MongoDB trades rigid schemas and joins for flexibility and scalability. It’s particularly strong in use cases with rapidly evolving requirements, hierarchical/nested data, or when high write throughput and horizontal scaling are critical.”

### **Q2: How do you design data models in MongoDB? Could you describe the difference between embedding and referencing documents? When would you use each?**

**Answer (interview-ready):**  
Data modeling in MongoDB is about designing collections and documents to reflect how the application queries and updates data. Unlike RDBMS where normalization is the default, MongoDB encourages designing models based on **application access patterns** (read/write frequency, query needs, growth).

There are two main ways to model relationships:

#### **1. Embedding (denormalization)**

- Store related data in the same document.
- Example:
```json
{
  "_id": 1,
  "name": "John Doe",
  "orders": [
    { "orderId": 1001, "amount": 250 },
    { "orderId": 1002, "amount": 450 }
  ]
}
```
- **Pros:**
    - Fast reads (all related data is in one document).
    - Fewer queries and joins.
- **Cons:**
    - Document size limit (16MB).
    - Updates may be costly if sub-document grows frequently.

👉 **When to use embedding:**
- One-to-few or one-to-many with **bounded growth**.
- Data is mostly read together (e.g., user profile with addresses).
#### **2. Referencing (normalization)**

- Store related data in separate documents, linked by reference (IDs).
- Example:
```json
// User collection
{ "_id": 1, "name": "John Doe", "orderIds": [1001, 1002] }

// Orders collection
{ "_id": 1001, "amount": 250, "userId": 1 }
{ "_id": 1002, "amount": 450, "userId": 1 }

```
- **Pros:**
    - Smaller documents, avoids duplication.
    - Flexible for one-to-many relationships with unbounded growth.
- **Cons:**
    - Requires additional queries (or `$lookup` aggregation for joins).
    - Slightly slower reads.

👉 **When to use referencing:**
- One-to-many or many-to-many relationships with **unbounded growth**.
- Data is large, frequently updated independently (e.g., user and blog posts, product catalog).

🔑 **Key Interview Line:**  
“MongoDB modeling is about trade-offs: embedding favors read performance by co-locating related data, while referencing keeps data normalized and avoids unbounded document growth. In practice, we often use a **hybrid model** — embedding for frequently accessed, small sub-documents, and referencing for large or independent entities.”

### **Q3: How does `$lookup` in MongoDB compare to SQL joins?**

**Answer:**
- `$lookup` is the closest equivalent to SQL joins, but MongoDB was not originally designed for complex joins.
- It allows combining documents from two collections, similar to a **left outer join**.
- However:
    - Performance can degrade with large datasets because MongoDB joins are not as optimized as RDBMS joins.  
    - `$lookup` works best with smaller datasets or when indexes are properly created on the join keys.
- In practice:
    - MongoDB encourages embedding where possible to avoid `$lookup`.
    - `$lookup` is useful for reporting queries, but not as efficient as relational joins in transactional workloads.

👉 Interview highlight: _“MongoDB supports joins, but the philosophy is: design for queries so you don’t need them frequently.”_

### **Q4: How does MongoDB ensure high availability and scalability?**

**Answer:**

- **High Availability:**
    - Achieved via **Replica Sets** (multiple nodes with one primary, multiple secondaries).
    - Automatic failover if primary goes down.
- **Scalability:**
    - Achieved via **Sharding** (horizontal partitioning of data).
    - Data is distributed across shards using a shard key.
    - Enables linear scaling for write-heavy and large datasets.

👉 Interview highlight: _“MongoDB is built with distributed architecture in mind: replica sets for fault tolerance, and sharding for scale.”_

### **Q5: How would you optimize MongoDB queries?**

**Answer:**

- **Indexing:**
    - Use single-field, compound, and multikey indexes as needed.
    - Avoid over-indexing (slows down writes).
- **Aggregation pipeline:** Use stages efficiently, push filters early (`$match` before `$group`).
- **Schema design:** Model data according to access patterns.
- **Sharding:** Choose shard keys wisely to balance load.
- **Query analysis:** Use `explain()` to analyze query execution.

👉 Example: _“If a query is slow, first step is to check if the right indexes exist. Then, I analyze with `db.collection.find().explain("executionStats")` to see if collection scans are happening.”_

### Q6 Walk me through how you perform basic CRUD operations (Create, Read, Update, Delete) in MongoDB using your preferred programming language or MongoDB shell.

1. Create (Insert documents)
```js
// Insert a single document
db.users.insertOne({
  name: "Alice",
  age: 30,
  email: "alice@example.com"
})

// Insert multiple documents
db.users.insertMany([
  { name: "Bob", age: 28, email: "bob@example.com" },
  { name: "Charlie", age: 35, email: "charlie@example.com" }
])

```
2. Read (Query documents)
```js
// Find all documents
db.users.find()
// Find with condition
db.users.find({ age: { $gt: 30 } })
// Projection (return only specific fields)
db.users.find({ age: { $gte: 30 } }, { name: 1, email: 1, _id: 0 })
// Sort and limit
db.users.find().sort({ age: -1 }).limit(2)

```

3. Update (Modify documents)
```js
// Update one document
db.users.updateOne(
  { name: "Alice" }, 
  { $set: { age: 31, email: "alice_new@example.com" } }
)

// Update multiple documents
db.users.updateMany(
  { age: { $lt: 30 } }, 
  { $set: { status: "young" } }
)
```
4. Delete (Remove documents)

```js
// Delete one document
db.users.deleteOne({ name: "Charlie" })

// Delete multiple documents
db.users.deleteMany({ age: { $lt: 25 } })
```
🔑 Interview Highlights
- **Point out**: MongoDB supports powerful query operators (`$gt`, `$in`, `$regex`, etc.).
- **Indexing** is critical for efficient reads.
- **Updates are atomic** at the document

### **Q7 How to Update Multiple Documents in MongoDB**

### **1. Using `updateMany()`**
This is the most direct way:
```js
db.users.updateMany(
  { age: { $lt: 30 } },            // Filter condition
  { $set: { status: "young" } }    // Update operation
)

```
### 2. **Using `bulkWrite()` (for advanced / batched updates)**

If you want different updates for different documents in one request:
```js
db.users.bulkWrite([
  {
    updateMany: {
      filter: { status: "active" },
      update: { $set: { premium: true } }
    }
  },
  {
    updateMany: {
      filter: { age: { $gte: 50 } },
      update: { $set: { senior: true } }
    }
  }
])

```
When updating, you can pass options:

1. **`upsert: true`** → Insert document if no match is found.
2. **Array update operators** (for nested structures)
- `$push` → add element to array.
- `$addToSet` → add only if not already present
- `$pull` → remove matching elements.
- `$inc` → increment field.
- `$mul`, `$rename`, `$unset`, `$currentDate`, etc.
###  **Q8: What types of indexes are supported in MongoDB? How do indexes impact performance, and how do you decide which fields to index?**
MongoDB supports several types:

1. **Single-field Index**
    - Index on one field.
```js
db.users.createIndex({ name: 1 })   // 1 = ascending, -1 = descending

```
2. compound index
```js
db.users.createIndex({ lastName: 1, firstName: 1 })

```
3. **Hashed Index**
- Indexes the hash of a field’s value.
```js
db.users.createIndex({ userId: "hashed" })

```
4. **Wildcard Index**
- Indexes all fields or fields matching a pattern (for dynamic schema).
```js
db.collection.createIndex({ "$**": 1 })      // all fields
db.collection.createIndex({ "metadata.$**": 1 }) // nested fields
```
5. **Geospatial Indexes**

- For location-based queries.
- **2d index**: legacy, for flat maps.
- **2dsphere index**: for Earth-like spherical coordinates.
```js
db.places.createIndex({ location: "2dsphere" })

```
```js
db.places.find({
  location: {
    $near: {
      $geometry: { type: "Point", coordinates: [ 77.5946, 12.9716 ] },
      $maxDistance: 5000
    }
  }
})
```
### Q9 **Can you explain the MongoDB Aggregation Framework and describe some common use cases where you have used it?**

The MongoDB Aggregation Framework lets us process and transform data inside the database using a pipeline of stages, similar to SQL’s `GROUP BY` and analytic functions.
## **Common Aggregation Operators**

- **$match** → filter documents (like `WHERE` in SQL).
- **$group** → group docs by a field and apply accumulators (`$sum`, `$avg`, `$min`, `$max`, `$count`).
- **$project** → reshape documents, include/exclude fields, create computed fields.
- **$sort** → sort results.
- **$limit / $skip** → pagination.
- **$lookup** → perform joins across collections.
- **$unwind** → flatten arrays into multiple documents.
- **$addFields / $set** → add computed fields.
```js
db.users.aggregate([
  { $match: { status: "active" } },       // Stage 1: Filter
  { $group: { _id: "$city", avgAge: { $avg: "$age" } } }, // Stage 2: Group & aggregate
  { $sort: { avgAge: -1 } }               // Stage 3: Sort
])
```
### Q10: **What is replication in MongoDB? How does it help with availability and durability?**
“Replication in MongoDB means keeping multiple copies of the data across a replica set (a primary and secondaries). It improves **availability** by automatically failing over to a new primary if the current one fails, and improves **durability** by ensuring data is stored redundantly on multiple nodes. We can also tune replication with write concerns and read preferences depending on consistency vs performance needs.”

- **Replication** in MongoDB means keeping multiple copies of the same data across different servers.
- It’s implemented using a **Replica Set** — a group of `mongod` processes (nodes) that maintain the same dataset.
- Replica sets typically consist of:
    - **Primary** → handles all writes and reads (unless read preference is set differently).
    - **Secondaries** → replicate the primary’s data asynchronously. Can serve read queries if configured.
    - **Arbiter** (optional) → participates in elections but does not store data.

## **What is Sharding?**

- **Sharding** is MongoDB’s method of **horizontal scaling** — splitting large datasets across multiple servers (shards).
- Instead of storing all data on a single server (which has CPU/RAM/disk limits), MongoDB distributes documents across **shards** based on a **shard key**.
- A sharded cluster consists of:
    - **Shards** → Each shard holds a subset of data.
    - **Config Servers (CSRS)** → Store metadata about the cluster and sharding.
    - **Mongos Router** → The query router that directs client requests to the appropriate shard(s).
## 🔹 **Common MongoDB Performance Challenges & Resolutions**

### **Write Performance Bottlenecks**

- **Challenge:** In a write-heavy system (e.g., logs ingestion), writes were slowing down because too many indexes had to be updated on every insert.
- **Resolution:**
    - Reduced the number of indexes — kept only essential ones.
    - Batched writes using `bulkWrite()` to minimize overhead.
    - Tuned write concern (used `{ w: 1 }` instead of `{ w: "majority" }` where strict durability wasn’t needed).
- **Impact:** Write throughput improved significantly (up to 2–3x in some cases).

    - Optimized long-running queries on secondaries that were blocking replication.
    - Upgraded hardware/network for secondaries to handle replication load.
- **Impact:** Replication delay reduced from minutes to seconds.

### **Large Documents & Document Growth**

- **Challenge:** Documents were hitting the 16MB limit or frequently growing (causing internal reallocation and fragmentation).
- **Resolution:**
    - Redesign schema: moved large arrays into separate collections (referencing instead of embedding).
    - Used `$push` with `$slice` to limit array growth.
- **Impact:** Reduced storage overhead and improved update speed.

## 🔹 **Monitoring MongoDB Performance**

### 1. **Built-in MongoDB Tools**

- **`db.currentOp()`** → shows currently running operations (useful to spot long-running queries).
- **`db.serverStatus()`** → gives key metrics like memory usage, locks, connections.
- **`db.stats()` / `db.collection.stats()`** → helps track collection/document/index size, index usage.
- **Profiler** (`db.setProfilingLevel()`) → captures slow queries (e.g., queries > 100ms).
**MongoDB Atlas (Cloud Manager / Ops Manager):**
### **Key Metrics to Watch**

- **Slow query logs** (queries exceeding a threshold).
- **Replication lag** (impacting read consistency).
- **Cache hit ratio (WiredTiger cache)** → low ratio means too much disk I/O.
- **Number of open connections** → may indicate app connection pooling issues.
- **Disk I/O and page faults** → performance bottlenecks.

### Q10:**Authorization**
**Role-Based Access Control (RBAC):**

- Users are assigned roles like `read`, `readWrite`, `dbAdmin`, or **custom roles**.
- Principle of **least privilege** → give only what’s necessary.
- `keycloak`

### Q11 BAckup methods

```bash
mongodump --db=mydb --out=/backup/path
mongorestore --db=mydb /backup/path/mydb
```
```bash
mongodump --db=mydb --collection=users --out=/backup/path
```
