`Quick Refs`
- https://colin-scott.github.io/personal_website/research/interactive_latency.html

|                                                                                     |
| ----------------------------------------------------------------------------------- |
| Latency Comparison Numbers (~2012)                                                  |
| L1 cache reference 0.5 ns                                                           |
| Branch mispredict 5 ns                                                              |
| L2 cache reference 7 ns 14x L1 cache                                                |
| Mutex lock/unlock 25 ns                                                             |
| Main memory reference 100 ns 20x L2 cache, 200x L1 cache                            |
| Compress 1K bytes with Zippy 3,000 ns 3 us                                          |
| Send 1K bytes over 1 Gbps network 10,000 ns 10 us                                   |
| Read 4K randomly from SSD* 150,000 ns 150 us ~1GB/sec SSD                           |
| Read 1 MB sequentially from memory 250,000 ns 250 us                                |
| Round trip within same datacenter 500,000 ns 500 us                                 |
| Read 1 MB sequentially from SSD* 1,000,000 ns 1,000 us 1 ms ~1GB/sec SSD, 4X memory |
| Disk seek 10,000,000 ns 10,000 us 10 ms 20x datacenter roundtrip                    |
| Read 1 MB sequentially from disk 20,000,000 ns 20,000 us 20 ms 80x memory, 20X SSD  |
| Send packet CA->Netherlands->CA 150,000,000 ns 150,000 us 150 ms                    |

**Key Relationships**
- **1 second** = 1,000 milliseconds (ms)
- **1 millisecond** (ms) = 1,000 microseconds (μs)
- **1 microsecond** (μs) = 1,000 nanoseconds (ns)
- **1 millisecond** (ms) = 1,000,000 nanoseconds (ns)
- **1 second** = 1,000,000 microseconds (μs) = 1,000,000,000 nanoseconds (ns)
# L1 cache reference
`0.5ns`
**What it means:**
An "L1 cache reference" refers to the time (latency) required for the CPU to access (read or load) data that is already present in the **Level 1 (L1) cache** — the smallest, fastest, and closest cache memory to the CPU core.

A "reference" here specifically means a successful hit: retrieving the data directly from L1 without needing to go to slower levels like L2 cache, L3 cache, or main memory (RAM).

- L1 cache is a tiny, per-core memory (tens of KB)
- Sits _inside_ the CPU core
- Accessed in a few CPU cycles
**Why it’s fast**
- Physically close to execution units
- No contention
- Simple lookup logic
**Real-world impact**
- Tight loops over arrays are insanely fast **if data fits in L1**
- Algorithms with good locality can be **10–100× faster**

**Engineering takeaway**

- Favour **contiguous memory** (arrays, structs over pointers)
- Avoid pointer-chasing
- Data-oriented design beats “clean OOP” in hot paths

# Branch Mispredict — ~5 ns

Branch Mispredict (or branch misprediction) refers to the performance penalty incurred when a CPU's branch predictor incorrectly guesses the outcome of a conditional branch instruction (e.g., an if statement, loop, or switch in code).

**What it is**
- CPU guesses which branch (`if/else`) will execute
- If wrong → pipeline flushed → re-execution

**Why it’s expensive**
- Modern CPUs are deeply pipelined
- Mispredict throws away work already done

**Real-world impact**
- `if` inside tight loops can be costly
- Data-dependent branches hurt performance

**Engineering takeaway**
- Use predictable branches
- Replace conditionals with:
    - Lookup tables
    - Bitwise operations
    - Polymorphism carefully (virtual calls can also mispredict)
A single mispredict can cost more than dozens of L1 hits, making it a key bottleneck in branch-heavy or unpredictable code.

### Why It Matters for Programmers

- **Optimization tip**: Write code with predictable branches (e.g., sorted data, loop patterns) to help the predictor.
    - Bad: Branches on random/unpredictable data (50% mispredict rate → huge slowdown).
    - Good: Branches that are mostly taken/not-taken, or use branchless techniques (e.g., bitwise ops, CMOV).
- Tools like perf stat (Linux) can measure branch-misses to identify hotspots.
- In tight loops or performance-critical code (games, HFT, ML inference), minimizing mispredicts is crucial

**usecase example**
#### The Scenario

Consider this task: Sum all elements in a large array that are less than a threshold (e.g., 128).

**Branchy Version** (with if statement – prone to mispredictions):
```
long sum = 0;
for (int i = 0; i < N; i++) {
    if (data[i] < 128) {
        sum += data[i];
    }
}
```

If data is filled with random values (0–255), the condition data[i] < 128 is true ~50% of the time in a completely unpredictable pattern. Modern branch predictors excel at patterns (e.g., loops or mostly-true/false), but fail on true randomness → ~50% misprediction rate.

- **Performance impact**: Each misprediction costs 10–30 cycles. In a loop with millions/billions of iterations, this can slow the code by **5–10x** or more compared to predictable cases.
- Real benchmark observations (from sources like Algorithmica and Igor Ostrovsky's experiments):
    - Unpredictable branch: ~14–20 cycles per iteration.
    - Predictable (e.g., sorted data where condition is always true/false): ~3–5 cycles per iteration.

#### Making It Predictable (Fixing the Misprediction)

Sort the array first:
```
std::sort(data, data + N);  // Now low values first
```
- If threshold is 128 and data is 0–255 random, after sorting: first half <128 (always true), second half >=128 (always false).
- Predictor quickly learns the pattern → near-0% mispredictions.
- Performance jumps to ~4 cycles per iteration (3–5x faster).

#### Branchless Version (Eliminating the Branch Entirely)

Rewrite without if using arithmetic/bit tricks:
```
long sum = 0;
for (int i = 0; i < N; i++) {
    int mask = -(data[i] < 128);  // -1 (all bits 1) if true, 0 if false
    sum += data[i] & mask;
}
```

#### Why This Is "Real-Time" and Common

- Seen in parsing (e.g., checking char ranges), filtering data, games (entity updates on random conditions), and sorting partitions (Quicksort suffers heavily from mispredictions on random pivots).
- Tools to measure: Linux perf stat -e branch-misses shows high misses in unpredictable cases.
- On modern CPUs (Intel/AMD/Apple M-series), unpredictable branches can multiply loop time by 3–7x in hot code.

# L2 cache reference-7ns

Still on‑chip but farther; roughly an order of magnitude slower than L1,
an L1 cache miss that hits in L2.

- The CPU tried to load data → missed in L1 → had to go to L2 → found it there (L2 hit).
- If it misses in L2 too, it goes to L3 or DRAM (even slower).

**What it is**
- Larger than L1, slower
- Still per-core or shared by few cores
- It is larger than L1 (typically 256 KB to 1–2 MB per core on modern CPUs).
- Private to each core (not shared across cores like L3 often is).

**Why slower**
- Bigger, farther away
- More complex coherence logic

**Real-world impact**
- Performance drops sharply when working set exceeds L1
- Still “fast” compared to RAM, but noticeable

**Engineering takeaway**
- Keep hot data small
- Structure objects so frequently accessed fields are close together

### A Real-World Example: Traversing an Array vs. a Linked List (Pointer Chasing)

A classic demonstration of **L2 cache references** (L1 misses that hit in L2) occurs when traversing data structures with different locality patterns. The key difference is between **sequential access** (good spatial locality, mostly L1 hits) and **random/pointer-chasing access** (poor locality, frequent L1 misses leading to L2 references).

#### The Scenario: Summing Values in a Large Data Structure
`Task: Sum the values stored in a collection of 10–100 million nodes/elements.`
**Array Version** (contiguous memory – excellent cache locality):
```c
long sum = 0;
for (int i = 0; i < N; i++) {
    sum += array[i].value;
}
```
- Data is stored sequentially in memory.
- Modern CPUs have **hardware prefetchers** that detect sequential access and preload upcoming cache lines into L1/L2 ahead of time.
- Most accesses hit in L1 (3–5 cycles).
- Occasional L1 misses are serviced quickly from L2 (10–30 cycles), but prefetching minimizes even these.
- Result: Very fast – often limited by CPU throughput, not memory latency.

Linked List Version (pointer chasing – poor cache locality):
```c
long sum = 0;
Node* current = head;
while (current != NULL) {
    sum += current->value;
    current = current->next;
}
```
- Each node's next pointer points to a potentially random memory location (nodes allocated separately via malloc/new).
- To access the next node's value, the CPU must:
    1. Load the next pointer (likely L1 miss if not recently used).
    2. Jump to that address and load the value.
- This creates a **dependency chain**: Each iteration waits for the previous load to resolve before knowing the next address.
- No predictable pattern → prefetchers can't help effectively.
- Frequent L1 misses → many **L2 cache references** (or worse, L3/RAM if the working set exceeds L2).
#### Performance Impact
- On modern CPUs (Intel/AMD, ~2025 era):
    - Array traversal: ~1–3 cycles per element (mostly L1 hits).
    - Linked list traversal: ~10–50+ cycles per element (dominated by L1 misses → L2 hits; can go to L3/RAM for very large lists).

> **Optimization:** Use array-of-structures to structure-of-arrays refactoring, or contiguous containers (e.g., std::vector over std::list) to favor L1 hits and reduce L2 references.

# **Main Memory Reference — ~100 ns**

**What it is**
- DRAM access
- Shared across cores and sockets

**Why it’s slow**
- Orders of magnitude farther from CPU
- Requires memory controllers, row activation, etc.

**Real-world impact**
- A single cache miss can cost **hundreds of CPU instructions**
- Memory-bound systems feel “slow” even at low CPU %

**Engineering takeaway**
- Cache misses dominate performance
- Reduce:
    - Random access
    - Large object graphs
- Increase:
    - Batching
    - Sequential access

# Mutex Lock/Unlock — ~100 ns

Mutex Lock/Unlock refers to the time required to acquire (lock) and release (unlock) a mutual exclusion lock (mutex) in multithreaded programming. A mutex ensures only one thread accesses a shared resource (critical section) at a time, preventing race conditions.

**What it is**
- Coordination between threads
- Involves cache line ownership + memory fences

**Why it’s expensive**
- Cache line bouncing between cores
- Potential kernel involvement
- Pipeline stalls

**Real-world impact**
- High contention = catastrophic slowdown
- Throughput collapses before CPU hits 100%

**Engineering takeaway**
- Minimize shared mutable state
- Prefer:
    - Lock-free structures
    - Sharding
    - Thread confinement
- One global lock can kill scalability

### **Compress 1KB with Zippy — ~10,000 ns**

**What it is**
- CPU-bound work
- Trade CPU for I/O savings

**Why it costs**
- Multiple passes over data
- Branch-heavy code
**Real-world impact**
- Compression often **worth it** before network/disk
- Not worth it inside ultra-hot loops

**Engineering takeaway**
- Compress at boundaries (network, disk)
- Don’t compress tiny objects repeatedly

**The Latency Breakdown**:

- ~10,000 ns = 10 µs = ~40,000 CPU cycles on a ~4 GHz processor.
- This is for the **compression operation** on 1KB; decompression is typically 2–5x faster.

`Throughput equivalent: ~100 MB/s for compression (1KB / 10 µs = 100 KB/ms = 100 MB/s)`

Math breakdown:

- 1 KB = 1,024 bytes ≈ 1,000 bytes for approximation.
- Time per block: 10 µs = 10 × 10⁻⁶ seconds = 0.00001 seconds.
- Throughput = data size / time = 1,024 bytes / 0.00001 s = 102,400,000 bytes/second.
- Convert to MB/s: 102,400,000 / 1,000,000 ≈ **102 MB/s** (often rounded to ~100 MB/s).
- Alternative view: 1 KB per 10 µs = 100 KB per millisecond (ms) = 100,000 KB per second = 100 MB/s.

================
# Real world example of image reading

This single example compresses **half of systems performance engineering** into two lines of math. 

---

# Problem Context (Real-World Framing)

You are building an **image search / gallery page** (Google Images–style):

- Page shows **30 thumbnails**
- Original images are stored on disk
- Each image ≈ **256 KB**
- Thumbnails are **generated at request time**
- Disk throughput ≈ **30 MB/s**
- Disk seek latency ≈ **10 ms** (HDD-like assumption)

The question is:

> **How long does the user wait before the page loads?**

This is **user-perceived latency**, not backend throughput.

---

# Fundamental Concepts Involved

Before math, understand the **physics** you are paying for:
1. **Disk seek latency (positioning cost)**
2. **Disk bandwidth (streaming cost)**
3. **Serialization vs parallelism**
4. **Critical path latency**
5. **Tail latency & variance**
6. **Human perception thresholds**

---

# Design 1 — Serial Reads (Worst-Case Design)

## What “Read serially” means

Real-world scenario:

- Single-threaded server
- Blocking I/O
- Code like:

```pseudo
for image in images:
    read image from disk
    generate thumbnail
```

Nothing overlaps.  
Every step waits for the previous one to finish.

---

## Disk Access = Two Separate Costs

### 1️⃣ Seek Time (Latency)

A **seek** means:

- Disk head moves to the file location
- Rotational delay
- Controller overhead

> **Cost is fixed**, regardless of file size.

Given:
- 10 ms per seek
- 30 images

```
30 × 10 ms = 300 ms
```

🔑 **Key concept**

> Random access cost is dominated by _latency_, not size.

---

### 2️⃣ Transfer Time (Bandwidth)

Once the disk head is positioned:
- Data streams sequentially

Total data:
```
30 × 256 KB ≈ 7.5 MB
```

Disk bandwidth:
```
30 MB/s
```

Transfer time:

```
7.5 MB / 30 MB/s = 0.25 s = 250 ms
```

🔑 **Key concept**

> Bandwidth determines _how fast large data moves_, not how fast it starts.

---

## Final Serial Latency

```
300 ms (seeks)
+250 ms (transfer)
=550 ms ≈ 560 ms
```

### What the user experiences

- Page feels sluggish
- Thumbnails pop in late
- Total page time likely >1 second once CPU work is added
---

## Why This Design Is So Bad
- Seeks are paid **30 times**
- Disk head thrashes
- CPU sits idle waiting for I/O
- No overlap between independent work

This is why **naive implementations fall over in production**.

---

# Design 2 — Parallel Reads (Smarter Design)

Now we change **one thing**:

> Issue all reads **at the same time**

---

## What “Issue reads in parallel” means

Real-world scenario:
- Async I/O
- Thread pool
- Kernel read-ahead
- Code like:

```pseudo
start read(image1)
start read(image2)
...
wait for all reads
```

Important:

- Requests are independent
- Disk can queue multiple requests

---

## Critical Path Thinking (Most Important Concept)

When operations are parallel:

> **Total latency = time of the slowest operation**

Not the sum.
---
## Seek Cost in Parallel

Disk still needs to:
- Move head
- Service requests

But:
- Seeks are overlapped
- Elevator algorithm (SCAN) reorders requests
- You pay **one dominant seek**, not 30

So:

```
~10 ms
```

🔑 **Key concept**

> Parallelism turns repeated latency costs into a single critical-path cost.

---

## Transfer Cost in Parallel

Each image:

```
256 KB / 30 MB/s ≈ 8.5 ms
```

Since reads overlap:

- Disk streams continuously
- Throughput is shared
- Effective time ≈ longest single read

So:

```
~8 ms
```

---
## Final Parallel Latency

```
10 ms (seek)
+ 8 ms (transfer)
= 18 ms
```
### This is a **30× improvement**

Same hardware.  
Same data.  
Different design.

---
## Why the Note Says “Really 30–60 ms”

Because real systems have:
### Variance Sources

- Disk scheduling contention
- Cache misses
- OS jitter
- File fragmentation
- Other workloads
So:
> **Tail latency dominates user experience**

That’s why engineers quote **ranges**, not exact numbers.

---

# Real-World Analogy (Very Important)

## Serial Design
Imagine:
- One cashier
- 30 customers
- Each customer:
    - Walks to storeroom (seek)
    - Brings item (transfer)
Total time = **sum of all trips**

---

## Parallel Design

Now:
- 30 employees
- All walk at once
- Manager waits for the slowest one

Total time = **one trip**

---

# Why This Matters in Real Systems

You’ve seen this pattern if you’ve worked with:
- Microservices calling each other in loops
- N+1 database queries
- REST calls inside for-loops
- Sequential S3 reads
- Serial Kafka fetches

Same mistake. Same math.

---

# The Big Mental Models You Should Keep

### 1️⃣ Latency stacks, throughput overlaps

### 2️⃣ Serialization multiplies pain

### 3️⃣ Parallelism collapses latency

### 4️⃣ Disk seeks are poison

### 5️⃣ Always think in **critical paths**

---

# One Sentence to Remember Forever

> **If independent work is done serially, latency is additive; if done in parallel, latency is bounded by the slowest operation.**

---

 next we can:

- Add **CPU thumbnail generation cost**
- Compare HDD vs SSD vs object storage
- Show how **pre-generated thumbnails = ~0 ms**
- Tie this directly to **Java async I/O or Go goroutines**
