![[Pasted image 20251202110852.png]]

### Know Your Basic Building Blocks

 >Core language libraries, basic data structures, SSTables, protocol buffers, GFS, BigTable, indexing systems, MySQL, MapReduce, … 
 
 Not just their interfaces, but understand their implementations (at least at a high level) If you don’t know what’s going on, you can’t do decent back-of-the-envelope calculations!
## How long to generate image results page (30 thumbnails)?


Start from the given assumptions and turn each line into explicit arithmetic and units.

## 1. Disk: 30 image thumbnails

Assumptions:
- Average disk seek (including rotation etc.): \(10\text{ ms}\).[1][2][3]
- Disk transfer rate: \(30\text{ MB/s}\).[4]
- Each image to thumbnail from: \(256\text{ KB}\).  
- Need 30 thumbnails.

### Design 1: serial reads

Each image read cost = seek time + transfer time.

1. Convert throughput units  
   - \(30\text{ MB/s} = 30 \times 10^6\text{ bytes/s}\) (using MB as \(10^6\) here, but the exact base is not critical; we stay consistent).[5]
   - Image size \(= 256\text{ KB} \approx 256 \times 10^3\text{ bytes}\).

2. Transfer time for 1 image  
\[
T_{\text{transfer,1}} = \frac{256\text{ KB}}{30\text{ MB/s}}
= \frac{256}{30}\text{ ms}
\]
Explanation of the last step:  
- \(\frac{256\text{ KB}}{30\text{ MB/s}} = \frac{256}{30} \times \frac{\text{KB}}{\text{MB}} \text{ s}\).  
- \(1\text{ MB} = 1024\text{ KB} \approx 10^3\text{ KB}\), so \(\frac{\text{KB}}{\text{MB}} \approx 10^{-3}\).  
- That gives \(\frac{256}{30} \times 10^{-3}\text{ s} \approx 8.53 \times 10^{-3}\text{ s} = 8.53\text{ ms}\).

So per image:
- Seek: \(10\text{ ms}\)  
- Transfer: \(\approx 8.5\text{ ms}\)  
- Total per image: \(10 + 8.5 = 18.5\text{ ms}\).

3. For 30 images serially  
\[
T_{\text{total,serial}} = 30 \times 10\text{ ms} + 30 \times 8.5\text{ ms}
= 300\text{ ms} + 255\text{ ms}
= 555\text{ ms} \approx 560\text{ ms}
\]
This matches “\(30\text{ seeks} \times 10\text{ ms} + 30 \times 256\text{K}/30\text{ MB/s} \approx 560\text{ ms}\)”.[4]

### Design 2: fully parallel reads

Assume the disk command queue allows 30 outstanding I/Os so the head seeks once to the region and then streams them.

1. Seek: still pay about \(10\text{ ms}\) once.  
2. Transfer: latency dominated by the slowest single 256 KB read, so same 8.5 ms as above.  

\[
T_{\text{total,parallel}} \approx 10\text{ ms} + 8.5\text{ ms} = 18.5\text{ ms} \approx 18\text{ ms}
\]

Reality is noisier: queueing, OS overhead, non-ideal layout → you might see something like 30–60 ms instead of the ideal 18 ms. This is a qualitative adjustment acknowledging variance.[6][7]

## 2. Comparisons and branch mispredictions

Assumptions:
- Data size: \(2^{28}\) numbers.  
- Algorithm does \(\log_2(2^{28})\) passes over the whole array.  
- Each pass: one comparison per number.  
- About half of the comparisons mispredict the branch.  
- Branch misprediction penalty: \(5\text{ ns}\) each (≈ 10–20 cycles on a multi‑GHz CPU, which is realistic).[8][9][10]

### 2.1 Number of comparisons

Passes:
\[
\log_2(2^{28}) = 28
\]

Per pass: \(2^{28}\) comparisons.  
Total comparisons:
\[
N_{\text{cmp}} = 28 \times 2^{28}
\]

Note that \(28 \approx 2^{4.8}\), so:
\[
N_{\text{cmp}} \approx 2^{4.8} \times 2^{28} = 2^{32.8} \approx 2^{33}
\]
So “\(\sim 2^{33}\) comparisons” is just rounding \(28 \cdot 2^{28}\) to the nearest power of two.

### 2.2 Number of mispredictions

If about half of the branches mispredict:
\[
N_{\text{mispredict}} \approx \frac{1}{2} \times N_{\text{cmp}} \approx \frac{1}{2} \times 2^{33} = 2^{32}
\]

### 2.3 Time from mispredictions

Penalty per misprediction: \(5\text{ ns} = 5 \times 10^{-9}\text{ s}\).[10][8]

Total misprediction time:
\[
T_{\text{mispredict}} = N_{\text{mispredict}} \times 5\text{ ns}
= 2^{32} \times 5 \times 10^{-9}\text{ s}
\]

Compute \(2^{32} \approx 4.29 \times 10^9\).  
So:
\[
T_{\text{mispredict}} \approx 4.29 \times 10^9 \times 5 \times 10^{-9}\text{ s}
= 4.29 \times 5 \times 10^{0}\text{ s}
\approx 21.45\text{ s}
\]

Rounded: about 21 seconds of time purely from mispredicted branches.

## 3. Memory bandwidth (streaming)

Assumptions:
- Each pass touches the full data: \(2^{30}\) bytes (1 GiB).  
- There are 28 passes → \(28\) GiB of traffic.  
- Sustained memory bandwidth: \(4\text{ GB/s}\).[11][12][5]

### 3.1 Total data moved

Per pass:  
\[
V_{\text{per pass}} = 2^{30}\text{ bytes} \approx 1\text{ GiB}
\]

Total over 28 passes:
$$\[
V_{\text{total}} = 28 \times 2^{30}\text{ bytes}
\]$$

If you treat \(2^{30}\text{ bytes}\) as “1 GB” for napkin math, that is:
\[
V_{\text{total}} \approx 28\text{ GB}
\]
$$



### 3.2 Time from DRAM bandwidth

Bandwidth:
\[
B = 4\text{ GB/s}
\]

Time:
\[
T_{\text{DRAM}} = \frac{V_{\text{total}}}{B} \approx \frac{28\text{ GB}}{4\text{ GB/s}} = 7\text{ s}
\]

This assumes:
- Access is predominantly sequential (streaming), which allows DRAM and caches to run close to peak bandwidth.[12][5]
- No major stalls from page faults or interference.

## 4. Putting the magnitudes side by side

Using the above math:

- Disk, 30 thumbnails, serial: \(\approx 0.56\text{ s}\).  
- Disk, 30 thumbnails, parallel: ideal \(\approx 0.018\text{ s}\), realistic ballpark \(\approx 0.03–0.06\text{ s}\).  
- Branch mispredicts over the comparison workload: \(\approx 21\text{ s}\).  
- DRAM bandwidth for 28 streaming passes: \(\approx 7\text{ s}\).

So:
- Disk seeks dominate naive serial thumbnail generation.  
- With good I/O scheduling and parallelism, disk becomes much cheaper in latency.  
- For a branchy, multi‑pass algorithm over 1 GiB, CPU pipeline effects (mispredictions) and DRAM bandwidth become the real bottlenecks