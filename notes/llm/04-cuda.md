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

If you want next:

* I can analyze a **real CUDA kernel**
* Or show **how one bad parameter kills performance**
* Or teach you **how Nsight Compute maps exactly to these limits**

Just say the word.
