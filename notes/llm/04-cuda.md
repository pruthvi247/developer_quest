[source-blog](https://read.theaimerge.com/p/the-mlai-engineers-starter-guide)

![[Pasted image 20260113192144.png]]



---

Good ask. I’ll do this **twice for every parameter**:

* **ELI5** → cartoon-simple, zero jargon
* **ELI25** → engineer-level, with small CUDA-style examples and *why you care*

I won’t skip any parameter you listed.

---

# 1. Compute Capability

## 👶 ELI5

Think of **Compute Capability** like a **phone model**.

* Old phone → fewer apps, slower
* New phone → more apps, faster, more memory

A newer GPU model can do **more tricks**.

---

## 🧑‍💻 ELI25

Compute Capability (CC) tells CUDA:

* How big memory can be
* How many blocks can run together
* Which features exist (Tensor Cores, async copy, larger shared memory)

### Example

```cpp
#if __CUDA_ARCH__ >= 900
    // use advanced shared memory
#else
    // fallback code
#endif
```

**Why you care:**
Code that works on CC 5.0 might **waste 40% performance** on CC 9.0 if you don’t adapt.

---

# 2. Warp Size (32 threads)

## 👶 ELI5

Workers always walk in **groups of 32**.
They must:

* Walk together
* Stop together
* Turn together

---

## 🧑‍💻 ELI25

A warp is the smallest execution unit.

* If 1 thread waits → all 32 wait
* If threads take different `if` paths → they run one path at a time

### Bad Example

```cpp
if (threadIdx.x % 2 == 0) {
    workA();
} else {
    workB();
}
```

### Good Example

```cpp
if (threadIdx.x < 16) {
    workA();
} else {
    workB();
}
```

**Why you care:**
Warp divergence = silent performance killer.

---

# 3. Grid Dimensions (x, y, z)

## 👶 ELI5

The whole job is split into:

* Rows
* Columns
* Layers

Like Lego boards stacked together.

---

## 🧑‍💻 ELI25

Grid dimensions define **problem size**.

### Example (2D image)

```cpp
dim3 grid(1024, 1024);
dim3 block(16, 16);
kernel<<<grid, block>>>();
```

* Grid.x max ≈ 2 billion
* Grid.y/z max = 65,535

**Why you care:**
Grid limits are huge → rarely your bottleneck.

---

# 4. Block Dimensions

## 👶 ELI5

A **block** is a team.
A team:

* Can’t be too big
* Must fit in one room

---

## 🧑‍💻 ELI25

Block limits:

* x or y ≤ 1024
* z ≤ 64
* total threads ≤ 1024

### Example

```cpp
dim3 block(256);     // good
dim3 block(1025);   // illegal
```

**Why you care:**
Blocks too large → don’t fit on SM → kernel won’t launch.

---

# 5. Threads per Block (1024 max)

## 👶 ELI5

One room can hold **at most 1024 kids**.

---

## 🧑‍💻 ELI25

Threads per block affect:

* Occupancy
* Register pressure
* Shared memory usage

### Typical Choices

| Threads | Use case   |
| ------- | ---------- |
| 128     | light work |
| 256     | default    |
| 512     | heavy math |

**Why you care:**
Bigger is not always faster.

---

# 6. Streaming Multiprocessor (SM)

## 👶 ELI5

An SM is a **floor in a building**.
Many floors work at the same time.

---

## 🧑‍💻 ELI25

Each SM contains:

* Warp schedulers
* Registers
* Shared memory

Blocks **never move** between SMs once assigned.

**Why you care:**
Performance depends on how well you fill each SM.

---

# 7. Maximum Resident Blocks per SM

## 👶 ELI5

Each floor can host only **some teams** at once.

---

## 🧑‍💻 ELI25

Limits:

* 16–32 blocks per SM

### Example

If:

* One block uses lots of shared memory
  → only 2 blocks fit
  → low occupancy

**Why you care:**
More blocks = better latency hiding.

---

# 8. Maximum Resident Warps / Threads per SM

## 👶 ELI5

Each floor can only have **so many workers walking at once**.

---

## 🧑‍💻 ELI25

Example (CC 9.0):

* 64 warps
* 2048 threads

### Occupancy Example

```text
Block size = 256 threads
2048 / 256 = 8 blocks per SM (max)
```

**Why you care:**
Too few warps → GPU waits on memory.

---

# 9. Registers (per thread, per SM)

## 👶 ELI5

Each worker has a **small backpack**.
Too many items → spill onto the floor (slow).

---

## 🧑‍💻 ELI25

Limits:

* 255 registers per thread
* 64K total per SM

### Example

```cpp
float a[64]; // may increase register usage
```

If registers exceed limit → **local memory spill**

**Why you care:**
Spills = slow global memory access.

---

# 10. Shared Memory (per block, per SM)

## 👶 ELI5

A team has **one whiteboard**.
Everyone in the team can see it.

---

## 🧑‍💻 ELI25

Shared memory:

* Fast
* Block-local
* Limited

### Example

```cpp
__shared__ float tile[16][16];
```

If a block uses 200 KB shared memory:

* Only 1 block fits per SM

**Why you care:**
Shared memory trades **space for speed**.

---

# 11. Maximum Resident Grids (Concurrent Kernels)

## 👶 ELI5

The building can run **many jobs at the same time**.

---

## 🧑‍💻 ELI25

New GPUs allow up to:

* 128 kernels concurrently

### Example

```cpp
kernelA<<<... , stream1>>>();
kernelB<<<... , stream2>>>();
```

**Why you care:**
Useful for:

* Pipelines
* Overlapping compute + memory

---

# FINAL BIG PICTURE (ELI5 + ELI25)

### 👶 ELI5

Don’t overcrowd rooms.
Don’t give workers too much luggage.
Make sure enough workers are busy.

---

### 🧑‍💻 ELI25

CUDA performance is **resource budgeting**:

* Registers
* Shared memory
* Warps
* Blocks

You win by **balance**, not maxing everything.

---
# GPU
[source-byte-byte-go]

The Graphics Processing Unit was originally designed to render video games. The mathematical requirements of rendering millions of pixels are remarkably similar to deep learning since both demand massive parallelism and high-throughput floating-point arithmetic.

NVIDIA’s GPU architecture uses SIMT (Single Instruction, Multiple Threads). The fundamental unit is a group of 32 threads called a warp. All threads in a warp share a single instruction decoder, executing the same instruction simultaneously. This shared control unit saves massive silicon area, which is filled with thousands of arithmetic units instead.

While modern CPUs have 16 to 64 complex cores, the NVIDIA H100 contains nearly 17,000 simpler cores. These run at lower clock speeds (1-2 GHz versus 3-6 GHz), but massive parallelism compensates for slower individual operations.

Standard GPU cores execute operations on single numbers, one at a time per thread. Recognizing that AI workloads are dominated by matrix operations, NVIDIA introduced Tensor Cores starting with their Volta architecture. A Tensor Core is a specialized hardware unit that performs an entire matrix multiply-accumulate operation in a single clock cycle. While a standard core completes one floating-point operation per cycle, a Tensor Core executes a 4×4 matrix multiplication involving 64 individual operations (16 multiplies and 16 additions in the multiply step, plus 16 accumulations) instantly. This represents a 64-fold improvement in throughput for matrix operations.

Tensor Cores also support mixed-precision arithmetic, which is crucial for practical AI deployment. They can accept inputs in lower precision formats like FP16 or BF16 (using half the memory of FP32) while accumulating results in higher precision FP32 to preserve numerical accuracy. This combination increases throughput and reduces memory requirements without sacrificing the precision needed for stable model training and accurate inference.

To feed these thousands of compute units, GPUs use High Bandwidth Memory (HBM). Unlike DDR memory that sits on separate modules plugged into the motherboard, HBM consists of DRAM dies stacked vertically on top of each other using through-silicon vias (microscopic vertical wires). These stacks are placed on a silicon interposer directly adjacent to the GPU die, minimizing the physical distance data must travel.

Such an architecture allows GPUs to achieve memory bandwidths exceeding 3,350 GB/s on the H100, more than 20 times faster than CPUs. With this bandwidth, an H100 can load a 140 GB model in roughly 0.04 seconds, enabling token generation speeds of 20 or more tokens per second. This is the difference between a stilted, frustrating interaction and a natural conversational pace.

The combination of massive parallel computing and extreme memory bandwidth makes GPUs the dominant platform for AI workloads.

## TPUs: Google’s Specialized Approach

In 2013, Google calculated that if every user utilized voice search for just three minutes daily, they would need to double their datacenter capacity using CPUs. This led to the Tensor Processing Unit.

![[Pasted image 20260120102106.png]]


The defining feature is the systolic array, a grid of interconnected arithmetic units (256 into 256, totaling 65,536 processors). Weights are loaded into the array and remain fixed while input data flows horizontally. Each unit multiplies its stored weight by incoming data, adds to a running sum flowing vertically, and passes both values to its neighbour.

![[Pasted image 20260120102239.png]]


This design means intermediate values never touch main memory. Reading from DRAM consumes roughly 200 times more energy than multiplication. By keeping results flowing between adjacent processors, systolic arrays eliminate most memory access overhead, achieving 30 to 80 times better performance per watt than CPUs.

Google’s TPU has no caches, branch prediction, out-of-order execution, or speculative prefetching. This extreme specialization means TPUs cannot run general code, but for matrix operations, the efficiency gains are substantial. Google also introduced bfloat16, which uses 8 bits for exponent (matching FP32 range) and 7 bits for mantissa. Neural networks tolerate low precision but require a wide range, making this format ideal.

![[Pasted image 20260120102439.png]]

