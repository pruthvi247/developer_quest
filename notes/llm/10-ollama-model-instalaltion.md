
# Choosing Ollama Models on Linux: A Hardware and Performance Guide

This guide explains how to:

1.     Inspect your CPU, GPU, RAM, VRAM, and storage on Linux.

2.     Determine whether Ollama is using the CPU or GPU.

3.     Estimate which model sizes your laptop can run.

4.     Understand parameters, quantization, context windows, and multimodal models.

5.     Evaluate model quality, speed, memory usage, and suitability.

6.     Select practical Google, Meta, coding, vision, and embedding models.

The examples work on most Linux distributions, including **Kali Linux**, Debian, Ubuntu, Fedora, Arch, and related systems. Package-installation commands may differ by distribution.

## 1. How local LLM inference uses your hardware

When you run a model using Ollama, the main hardware resources are:

·      **GPU memory/VRAM:** Holds model weights, the context/KV cache, and runtime buffers when GPU acceleration is available.

·      **System RAM:** Holds model data when running on the CPU or when part of the model does not fit in VRAM.

·      **GPU compute:** Usually provides much faster token generation than CPU-only inference.

·      **CPU:** Handles tokenization, orchestration, and potentially some or all model layers.

·      **Storage:** Stores downloaded model files.

·      **Memory bandwidth:** Often more important than raw CPU clock speed for CPU-based inference.

·      **Cooling and power:** Laptop performance may decline under sustained thermal load.

The best model is therefore not simply the largest one you can download. It is the largest model that:

·      fits comfortably in available memory;

·      provides acceptable generation speed;

·      leaves memory for the operating system and applications;

·      supports the capabilities you need;

·      remains stable at the desired context length.

## 1. How local LLM inference uses your hardware

When you run a model using Ollama, the main hardware resources are:

·      **GPU memory/VRAM:** Holds model weights, the context/KV cache, and runtime buffers when GPU acceleration is available.

·      **System RAM:** Holds model data when running on the CPU or when part of the model does not fit in VRAM.

·      **GPU compute:** Usually provides much faster token generation than CPU-only inference.

·      **CPU:** Handles tokenization, orchestration, and potentially some or all model layers.

·      **Storage:** Stores downloaded model files.

·      **Memory bandwidth:** Often more important than raw CPU clock speed for CPU-based inference.

·      **Cooling and power:** Laptop performance may decline under sustained thermal load.

The best model is therefore not simply the largest one you can download. It is the largest model that:

·      fits comfortably in available memory;

·      provides acceptable generation speed;

·      leaves memory for the operating system and applications;

·      supports the capabilities you need;

·      remains stable at the desired context length.
```sh
1     cat /etc/os-release

2     uname -a

3     uname -r
```
On Kali Linux, you should normally see identifiers such as:

```sh
1     ID=kali

2     ID_LIKE=debian
```
The kernel version matters when installing GPU drivers and matching kernel headers.

## 2.2 Check CPU details

Use:
```sh
lscpu
```
For a concise output:
```sh
1     lscpu | grep -E \

2     'Architecture|CPU\(s\)|Model name|Thread|Core|Socket|CPU max MHz|CPU min MHz'
```
You can also inspect the processor directly:
```sh
1     grep -m1 'model name' /proc/cpuinfo

2     nproc
```
### Important CPU fields

·      **Model name:** Exact processor generation.

·      **CPU(s):** Total logical threads.

·      **Core(s) per socket:** Number of physical CPU cores.

·      **Thread(s) per core:** Whether simultaneous multithreading is available.

·      **Architecture:** Usually x86_64 on Intel/AMD laptops or aarch64 on ARM systems.

·      **Flags:** Instruction-set capabilities such as AVX, AVX2, and AVX-512.

Check relevant CPU instructions:

```sh
1     lscpu | grep -oE 'avx512[^ ]*|avx2|avx|fma' | sort -u
```
### How CPU specifications affect inference

·      More cores can improve CPU inference, but scaling is not perfectly linear.

·      Recent CPUs with AVX2 or AVX-512 generally perform better.

·      Higher memory bandwidth can matter more than another small increase in clock speed.

·      More cores do not compensate for insufficient RAM.

·      Laptop CPUs may throttle when temperatures become high.

Monitor CPU frequency and load while running a model:

```sh
1     watch -n 1 \

2     "grep -E 'cpu MHz' /proc/cpuinfo | head; echo; uptime"
```
A better interactive monitor is:
```sh
htop
```
```sh
1     sudo apt update

2     sudo apt install -y htop
```
## 2.3 Check system RAM
```sh
free -h
```
more detail info:
```sh
1     grep -E 'MemTotal|MemAvailable|SwapTotal|SwapFree' /proc/meminfo
```
monitor RAM continiously
```sh
  watch -n 1 free -h
```
### Use available, not only free

Linux uses otherwise unused RAM for filesystem caching. Therefore, the available value is a more realistic estimate of how much memory applications can obtain.

Example:
1                    total        used        free      shared  buff/cache   available

2     Mem:            31Gi        8Gi         4Gi        1Gi         19Gi        21Gi

In this example, approximately 21 GiB is realistically available—not just the 4 GiB shown under free.

### Leave memory for the system

A practical safety margin is:

·      **8 GB machine:** Keep at least 2–3 GB available for Linux.

·      **16 GB machine:** Keep at least 3–5 GB available.

·      **32 GB machine:** Keep at least 5–8 GB available.

·      **64 GB machine:** Keep at least 8–12 GB available.

Browsers, development environments, containers, and security tools can consume substantial RAM. On Kali, Burp Suite, browsers, Docker, IDEs, and virtual machines can significantly reduce the memory left for Ollama.

## 2.4 Identify every GPU

Run:
```sh
lspci -nnk | grep -A4 -Ei 'VGA|3D|Display'
```
This shows:

·      integrated Intel or AMD graphics;

·      a discrete NVIDIA or AMD GPU;

·      the kernel driver currently in use;

·      available kernel modules.

Example hybrid laptop:

```txt
1     Intel Corporation Integrated Graphics

2     Kernel driver in use: i915

3    

4     NVIDIA Corporation GeForce RTX ...

5     Kernel driver in use: nvidia
```
A laptop with both integrated graphics and NVIDIA graphics is normally a hybrid/Optimus system.

For a simple list:
```sh
lspci | grep -Ei 'VGA|3D|Display'
```
# 3. Inspect NVIDIA GPUs

## 3.1 Check the driver and VRAM
```sh
nvidia-smi
```
This is the most useful NVIDIA command. It normally displays:

·      GPU model;

·      driver version;

·      total and used VRAM;

·      GPU utilization;

·      temperature;

·      power usage;

·      processes currently using the GPU.

For a concise hardware report:

```sh
1     nvidia-smi \

2       --query-gpu=name,driver_version,memory.total,memory.used,memory.free,temperature.gpu,power.draw \

3       --format=csv
```
Continuously monitor the GPU:
```sh
watch -n 1 nvidia-smi
```
monitor compute process
```sh
nvidia-smi pmon -s um
```
user gpu identifiers:
```sh
nvidia-smi -L
```

Ollama’s current hardware documentation supports numerous NVIDIA GPU generations, subject to compute-capability and driver requirements. The documentation states support for compute capability 5.0 or newer, with newer drivers required for some older GPU generations. [[docs.ollama.com]](https://docs.ollama.com/gpu)

## 3.2 If nvidia-smi fails

### Command not found

The NVIDIA utilities are not installed or are not in your path:
```sh
command -v nvidia-smi
```

### Could not communicate with the NVIDIA driver
Inspect loaded modules:
```sh
lsmod | grep -E 'nvidia|nouveau'
```
inspect kernel messages:
```sh
sudo dmesg | grep -Ei 'nvidia|nouveau|NVRM' | tail -n 100
```
On Kali, install drivers through Kali’s repositories—do not mix Ubuntu PPAs or ordinary Debian repositories into Kali.

# 4. Inspect AMD GPUs

Identify the GPU and driver:
```sh
lspci -nnk | grep -A4 -Ei 'AMD|ATI|VGA|3D|Display'
```

check if the AMD kernel module is loaded:
```sh
lsmod | grep amdgpu
```

If ROCM tolls are installed:
```sh
 rocminfo
```

and
```
rocm-smi
```

Ollama’s Linux documentation provides an additional ROCm package for AMD GPU support. Its hardware documentation currently specifies ROCm v7 for supported AMD GPUs on Linux, while additional GPU support may be available through Vulkan. Exact support depends on the GPU generation and driver stack. [[docs.ollama.com]](https://docs.ollama.com/gpu), [[docs.ollama.com]](https://docs.ollama.com/linux)

Do not assume that every AMD integrated GPU supports full ROCm acceleration. Check the exact GPU model against the current Ollama and AMD compatibility documentation.

# 5. Inspect Intel GPUs

Identify Intel graphics:
```sh
1     lspci -nnk | grep -A4 -Ei 'Intel.*(VGA|Display|Graphics)|VGA|3D|Display'
```

check kernel driver
```sh
lsmod | grep -E 'i915|xe'
```

install and use intel GPU monitoring tools and Debian/Kali:
```sh
sudo apt update
sudo apt install -y intel-gpu-tools
```
then monitor
```sh
sudo intel_gpu_top
```

Intel integrated graphics generally use **shared system memory**, not separate dedicated VRAM. The amount displayed by a generic hardware utility is therefore not necessarily the amount practically available to Ollama.

GPU support varies by Intel generation and Ollama backend. If GPU acceleration is unavailable, Ollama can still run models on the CPU.

# 6. Create a reusable hardware-report command

Save the following as ollama-hardware-check.sh:
```sh
#!/usr/bin/env bash

echo "========================================"
echo " OS"
echo "========================================"
cat /etc/os-release 2>/dev/null
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"

echo
echo "========================================"
echo " CPU"
echo "========================================"
lscpu | grep -E \
'Architecture|CPU\(s\)|Model name|Thread|Core|Socket|CPU max MHz|CPU min MHz'

echo
echo "Relevant CPU instruction sets:"
lscpu | grep -oE 'avx512[^ ]*|avx2|avx|fma' | sort -u

echo
echo "========================================"
echo " MEMORY"
echo "========================================"
free -h

echo
echo "========================================"
echo " GPU"
echo "========================================"
lspci -nnk | grep -A4 -Ei 'VGA|3D|Display'

echo
echo "========================================"
echo " NVIDIA"
echo "========================================"
if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi \
      --query-gpu=name,driver_version,memory.total,memory.used,memory.free \
      --format=csv
else
    echo "nvidia-smi is not installed or no NVIDIA driver is available."
fi

echo
echo "========================================"
echo " AMD ROCm"
echo "========================================"
if command -v rocm-smi >/dev/null 2>&1; then
    rocm-smi --showproductname --showmeminfo vram
else
    echo "rocm-smi is not installed."
fi

echo
echo "========================================"
echo " STORAGE"
echo "========================================"
df -h /

echo
echo "========================================"
echo " OLLAMA"
echo "========================================"
if command -v ollama >/dev/null 2>&1; then
    ollama --version
    echo
    echo "Installed models:"
    ollama list
    echo
    echo "Loaded models:"
    ollama ps
else
    echo "Ollama is not installed or is not in PATH."
fi

```

Make it executable and run it:
```sh
chmod +x ollama-hardware-check.sh
./ollama-hardware-check.sh
```

# 7. Understanding model parameters

Model names frequently include sizes such as:
·      1b
·      3b
·      7b
·      8b
·      12b
·      14b
·      27b
·      32b
·      70b
The B means **billions of parameters**.

Generally:

·      Larger models have greater capacity.
·      They usually require more memory.
·      They usually generate more slowly.
·      They are not automatically better at every task.
·      A smaller specialized coding model can outperform a larger general model on coding.
·      Training quality, architecture, data quality, and instruction tuning matter considerably.

Parameter count alone is therefore not a sufficient selection criterion.
# 8. Understanding model quantization

Models are commonly stored using reduced numerical precision so that they consume less memory.

Typical GGUF/Ollama quantization names include:

·      Q2_K
·      Q3_K_M
·      Q4_0
·      Q4_K_M
·      Q5_K_M
·      Q6_K
·      Q8_0
·      F16 or BF16

## General interpretation

|   |   |   |   |
|---|---|---|---|
|**Quantization**|**Memory use**|**Quality**|**Practical use**|
|**Q2**|Very low|Noticeably reduced|Only when memory is extremely limited|
|**Q3**|Low|Some degradation|Constrained hardware|
|**Q4_K_M**|Moderate|Good|Best general starting point|
|**Q5_K_M**|Higher|Better preservation|When adequate memory is available|
|**Q6_K**|High|Very good|Quality-focused local use|
|**Q8_0**|Very high|Near full precision|High-memory systems|
|**F16/BF16**|Extremely high|Full/near-full|Workstations and servers|

### Recommended starting point

For most laptops, choose:

```
Q4_K_M
```
It normally offers a good balance among:

·      file size;
·      runtime memory;
·      generation speed;
·      output quality.

For example, Ollama’s llama3.2:3b listing identifies the model as approximately 2 GB with Q4_K_M quantization. [[ollama.com]](https://ollama.com/library/llama3.2:3b)

When you have extra memory and care more about output consistency than speed, try a Q5 or Q6 variant. Avoid Q2 unless the model otherwise cannot run.
# 9. Estimate model memory requirements

A rough weight-only estimate is:
```sh
Model weight memory ≈ parameter count × bits per weight ÷ 8
```
For a 7-billion-parameter model at theoretical 4-bit precision:
```sh
 7 billion × 4 ÷ 8 ≈ 3.5 GB
```
However, actual runtime memory is higher because it also includes:

·      quantization metadata;
·      model architecture overhead;
·      the KV/context cache;
·      compute buffers;
·      vision components;
·      Ollama runtime overhead;
·      GPU-driver allocations.
Therefore:
```
Runtime memory > downloaded model size
```
## Practical safety estimate

For initial planning:
```txt
Required memory ≈ model file size + 20% to 50% overhead + context cache
```
This is only a planning estimate. Actual memory depends on architecture, quantization, context, parallelism, and backend.
### Examples
·      A 2 GB model may need roughly 3–4 GB of usable memory.
·      A 5 GB model may need roughly 7–9 GB.
·      A 9 GB model may need roughly 12–16 GB.
·      A 19 GB model may need considerably more than 24 GB, particularly at long context lengths.

Always verify actual use with ollama ps, free -h, and the appropriate GPU-monitoring tool.
# 10. Choose a model based on system RAM
The following is a conservative laptop-oriented guide.

|   |   |   |
|---|---|---|
|**Total system RAM**|**CPU-only model range**|**Recommended target**|
|**8 GB**|1B–3B|1B or 3B Q4|
|**12 GB**|1B–4B|3B or 4B Q4|
|**16 GB**|3B–8B|4B or 7B/8B Q4|
|**24 GB**|7B–14B|8B or 12B Q4|
|**32 GB**|8B–20B|12B or 14B Q4|
|**48 GB**|14B–32B|14B, 27B, or selected 30B Q4|
|**64 GB**|27B–40B|27B or 32B Q4|
|**96–128 GB**|Up to selected 70B models|70B Q4, if speed is acceptable|

This table assumes you are not simultaneously running several memory-heavy applications.
## CPU-only recommendations

·      **8 GB RAM:** Llama 3.2 1B or 3B.
·      **16 GB RAM:** Gemma 3 4B or a 7B/8B Q4 model.
·      **32 GB RAM:** Gemma 3 12B or a 14B Q4 model.
·      **64 GB RAM:** Gemma 3 27B or a 32B Q4 model.
·      **70B models:** Usually too slow for an ordinary laptop, even when they technically fit in system RAM.

CPU-only inference is useful for learning, batch processing, embeddings, and occasional chat. For interactive coding assistants, a smaller model that responds quickly is often more productive than a stronger model that generates very slowly.

# 11. Choose a model based on dedicated GPU VRAM

The following is a practical target range rather than a hard guarantee.

|   |   |   |
|---|---|---|
|**Dedicated VRAM**|**Comfortable model target**|**Notes**|
|**2 GB**|1B–3B|Limited GPU offload|
|**4 GB**|3B–4B|Small Q4 models|
|**6 GB**|4B–7B|7B may be tight with context|
|**8 GB**|7B–8B|Excellent laptop baseline|
|**12 GB**|8B–14B|12B/14B Q4 often practical|
|**16 GB**|12B–20B|Some 20B-class models|
|**24 GB**|27B–32B|Strong local inference setup|
|**48 GB**|32B–70B|Depends heavily on context|
|**80 GB**|Many 70B variants|Workstation/server-class|

### Full GPU versus partial offload

The model does not always need to fit entirely in VRAM. Ollama can place some data on the GPU and the remainder in system RAM.

However:

·      Full GPU placement is normally fastest.
·      CPU/GPU splitting can still be useful.
·      More splitting usually lowers token generation speed.
·      A model barely fitting in VRAM may fail when context length increases.
·      The display server and desktop environment also consume VRAM.

Do not plan around the GPU’s total VRAM. Plan around **free VRAM before loading the model**.

Check it with:
```sh
nvidia-smi --query gpu=memory.total,memory.used,memory.free --format=csv
```

# 12. Verify whether Ollama uses the CPU or GPU

Start a model:
```sh
ollama run gemma3:4b
```
Enter a long enough prompt to keep it active.

In another terminal:
```sh
ollama ps
```
The PROCESSOR field is the important value:

·      100% GPU: fully loaded on the GPU.

·      100% CPU: loaded in system memory and using CPU inference.

·      Mixed percentages: split between CPU and GPU.

Ollama officially documents ollama ps as the way to inspect whether a loaded model is on the GPU, CPU, or split between them. [[docs.ollama.com]](https://docs.ollama.com/faq)

Remember that ollama ps shows **loaded models**, not Linux process IDs.

To obtain Linux PIDs:
```sh
pgrep -a ollama
# or
ps aux | grep '[o]llama'
# check ollama service pid:
systemctl show ollama -p MainPID
# check server port
sudo ss -lntp | grep 11434
```
# 13. Context windows and their memory cost

The context window controls how much text a model can consider at once.
Common advertised capacities include:
·      4K tokens
·      8K tokens
·      32K tokens
·      128K tokens
·      256K tokens

A large advertised context does **not** mean you should always use the maximum.

Longer contexts:
·      use more RAM or VRAM;
·      increase prompt-processing time;
·      can reduce generation speed;
·      may make a model that previously fit in VRAM spill into system RAM;
·      may provide diminishing quality after a certain point.

Ollama uses a default context length of 4,096 tokens unless configured otherwise. It supports changing the context through OLLAMA_CONTEXT_LENGTH, /set parameter num_ctx, or API options. [[docs.ollama.com]](https://docs.ollama.com/faq)

## Recommended starting points
·      General chat: 4K
·      Coding question: 4K–8K
·      Several source files: 8K–16K
·      Document analysis: 8K–32K
·      Repository-scale analysis: only use larger contexts after verifying memory

Inside an Ollama session:
```sh
 /set parameter num_ctx 4096
 # for 8k
  /set parameter num_ctx 8192
  # check session parameters:
  /show parameters
```
A model may advertise 128K but perform better on your laptop at 4K or 8K because it can remain completely GPU-resident.
# 14. Model architecture: dense versus mixture-of-experts

## Dense models

In a dense model, most or all parameters participate in each token-generation step.

Examples include many traditional:

·      7B models;
·      8B models;
·      14B models;
·      32B models.

Dense models are relatively straightforward to estimate: larger parameter count generally means more computation per token.

## Mixture-of-experts models

A mixture-of-experts, or MoE, model may have:
·      a large total parameter count;
·      a much smaller number of active parameters per token.

For example, Ollama describes Qwen3-Coder 30B as having approximately 30B total parameters but about 3.3B active parameters. However, its local Ollama package is still approximately 19 GB because the experts’ weights must be stored and made accessible. [[ollama.com]](https://ollama.com/library/qwen3-coder), [[ollama.com]](https://ollama.com/library/qwen3-coder:30b)

### Important distinction

·      **Total parameters** mainly affect model storage and memory.
·      **Active parameters** strongly affect computation per token.
·      MoE can be computationally efficient but still memory intensive.
Do not select an MoE model based only on active parameter count.

# 15. Choose models based on task

## General assistant and learning

Look for:

·      strong instruction following;

·      clear explanations;

·      multilingual ability;

·      low hallucination rate;

·      appropriate model size;

·      stable structured output.

Good starting families include:

·      Google Gemma;

·      Meta Llama;

·      Qwen;

·      Mistral;

·      Microsoft Phi.

## Programming

Look for:

·      code-specific training;

·      fill-in-the-middle support, when required;

·      long-context code understanding;

·      tool calling;

·      repository-level reasoning;

·      support for your programming languages;

·      reliable tests and structured output.

A 7B coding-specialized model may be more useful than a larger general chat model for everyday programming.

## Vision and screenshot understanding

Look for explicit support for:

·      text and image input;

·      OCR;

·      screenshots;

·      charts and diagrams;

·      document pages;

·      multiple images.

Vision models use additional memory and may have different prompt syntax. Do not assume every chat model can process images.

## Embeddings and RAG

Embedding models are used for:

·      semantic search;

·      document retrieval;

·      clustering;

·      classification;

·      similarity matching.

They do not replace a chat model. A typical RAG setup uses:

1.     An embedding model to index and retrieve text.

2.     A chat/instruction model to answer using the retrieved passages.

## Tool-calling and agents

Look for:

·      explicit tool support;

·      reliable JSON generation;

·      strong instruction following;

·      long-context capability;

·      low tendency to invent tool outputs;

·      prompt-injection resistance appropriate to your application.

Test tool calling yourself. A model card saying “tools” does not guarantee reliable function calls for your schema.
# 16. Practical Google and Meta choices

## Google Gemma 3

Gemma 3 is available in several sizes in Ollama:

|   |   |   |   |
|---|---|---|---|
|**Model**|**Approximate Ollama size**|**Input**|**Suggested hardware**|
|**Gemma 3 1B**|815 MB|Text|8 GB RAM|
|**Gemma 3 4B**|3.3 GB|Text and image|8–16 GB RAM|
|**Gemma 3 12B**|8.1 GB|Text and image|24–32 GB RAM or 12 GB VRAM|
|**Gemma 3 27B**|17 GB|Text and image|48–64 GB RAM or 24 GB VRAM|

Ollama lists Gemma 3 in 270M, 1B, 4B, 12B, and 27B variants. The 4B, 12B, and 27B variants support text and image input and advertise up to a 128K model context window. [[ollama.com]](https://ollama.com/library/gemma3)

### Commands

|   |
|---|
|1     ollama run gemma3:1b|
|1     ollama run gemma3:4b|
|1     ollama run gemma3:12b|
|1     ollama run gemma3:27b|

### Best use

·      **4B:** best Google starting model for laptops.

·      **12B:** better capability when you have sufficient memory.

·      **27B:** quality-focused choice for powerful systems.

Gemma 3 also provides quantization-aware-trained variants designed to preserve quality at lower memory usage. [[ollama.com]](https://ollama.com/library/gemma3)

## Meta Llama 3.2

Ollama provides Meta Llama 3.2 text models in 1B and 3B sizes:

|   |   |   |
|---|---|---|
|**Model**|**Approximate Ollama size**|**Best use**|
|**Llama 3.2 1B**|1.3 GB|Low-memory and CPU-only testing|
|**Llama 3.2 3B**|2.0 GB|Lightweight assistant and tool experiments|

Llama 3.2 supports text input and is positioned for multilingual dialogue, summarization, retrieval, prompt rewriting, and tool-oriented tasks. [[ollama.com]](https://ollama.com/library/llama3.2)

### Commands

|   |
|---|
|1     ollama run llama3.2:1b|
|1     ollama run llama3.2:3b|

### Best use

·      **1B:** API testing, rewriting, classification, and low-end hardware.

·      **3B:** fast local assistant and general experimentation.

For stronger general performance, also consider a Meta Llama 3.1 8B variant if your machine has around 16 GB or more RAM, or approximately 8 GB of usable VRAM.

# 17. Suggested combinations by hardware

## 8 GB RAM, no dedicated GPU

Start with:

|   |
|---|
|1     ollama pull llama3.2:1b<br><br>2     ollama pull llama3.2:3b<br><br>3     ollama pull gemma3:1b|

Recommended context:

|   |
|---|
|1     2048–4096|

Avoid:

·      12B and larger models;

·      long context windows;

·      running multiple models simultaneously.

## 16 GB RAM, integrated GPU or CPU-only

Start with:

|   |
|---|
|1     ollama pull gemma3:4b<br><br>2     ollama pull llama3.2:3b|

Optionally test a 7B/8B Q4 model.

Recommended context:

|   |
|---|
|1     4096–8192|

This is usually the best entry-level configuration for serious local experimentation.

## 16 GB RAM and 6–8 GB dedicated VRAM

Recommended:

|   |
|---|
|1     ollama pull gemma3:4b<br><br>2     ollama pull llama3.2:3b|

Also test:

·      a 7B/8B general model;

·      a 7B coding model;

·      a compact embedding model.

Prioritize models that fit fully in VRAM. An 8B model may be stronger, but Gemma 3 4B may feel faster and support image input.

## 32 GB RAM and 8–12 GB VRAM

Recommended:

|   |
|---|
|1     ollama pull gemma3:12b|

Also consider:

·      Llama 3.1 8B;

·      7B/14B coding models;

·      a 7B vision model;

·      separate embedding and reranking models.

Use 4K or 8K context initially. Increase it only after examining VRAM usage.

## 64 GB RAM and 16–24 GB VRAM

Recommended:

|   |
|---|
|1     ollama pull gemma3:27b|

You can also evaluate:

·      27B/32B general models;

·      30B-class MoE coding models;

·      Q5 quantizations of smaller models;

·      larger vision-language models.

For example, Ollama’s Qwen3-Coder 30B listing is approximately 19 GB, so it is better suited to a system with substantial VRAM or system RAM. [[ollama.com]](https://ollama.com/library/qwen3-coder), [[ollama.com]](https://ollama.com/library/qwen3-coder:30b)

# 18. Performance metrics that matter

Do not evaluate a model using only “it answered correctly once.” Measure several dimensions.

## 18.1 Time to first token

This is the delay between submitting the prompt and receiving the first generated token.

Affected by:

·      model loading time;

·      prompt length;

·      context length;

·      GPU/CPU placement;

·      storage speed;

·      model architecture.

A model can have fast generation but slow prompt processing.

## 18.2 Prompt-processing speed

This measures how quickly the model reads your input.

It matters for:

·      long documents;

·      source-code repositories;

·      RAG prompts;

·      long conversation histories.

## 18.3 Generation speed

Usually measured in:

|   |
|---|
|1     tokens per second|

Informal interpretation:

·      Under 2 tokens/s: slow interactive experience.

·      2–5 tokens/s: usable but slow.

·      5–10 tokens/s: comfortable.

·      10–20 tokens/s: responsive.

·      Over 20 tokens/s: very responsive.

Perceived speed also depends on answer length and time to first token.

## 18.4 Peak memory

Measure:

·      system RAM before and after loading;

·      allocated GPU memory;

·      swap use;

·      whether the model remains fully GPU-resident.

## 18.5 Quality and reliability

Evaluate:

·      factual accuracy;

·      instruction following;

·      code correctness;

·      structured output validity;

·      refusal behavior where appropriate;

·      citation behavior;

·      hallucination rate;

·      consistency across repeated runs.

## 18.6 Thermal stability

A laptop may generate quickly for the first minute and then slow down because of heat.

Monitor temperature:

```sh
watch -n 1 sensors
# install sensor on kali
sudo apt update
sudo apt install -y lm-sensors
sudo sensors-detect
# monitor nvidia temperature
watch -n 1 \
"nvidia-smi --query-gpu=temperature.gpu,power.draw,clocks.sm \
--format=csv,noheader"
```
# 19. Benchmark Ollama from the command line

Ollama’s API supplies timing and token-count information in its final response.

Run:
```sh
 curl -s http://localhost:11434/api/generate \
      -d '{
        "model": "gemma3:4b",
        "prompt": "Explain containers versus virtual machines in 300 words.",
        "stream": false,
        "options": {
          "num_ctx": 4096,
          "temperature": 0
        }
      }'| jq
```
install jq on kali
```sh
sudo apt update
sudo apt install -y jq
```
calculate approximate generation speed:

```sh
    curl -s http://localhost:11434/api/generate \
      -d '{
        "model": "gemma3:4b",
        "prompt": "Explain containers versus virtual machines in 300 words.",
        "stream": false,
        "options": {
          "num_ctx": 4096,
          "temperature": 0
        }
      }' |
    jq '{
      model,
      prompt_tokens: .prompt_eval_count,
      generated_tokens: .eval_count,
      prompt_tokens_per_second:
        (.prompt_eval_count / (.prompt_eval_duration / 1000000000)),
      generation_tokens_per_second:
        (.eval_count / (.eval_duration / 1000000000)),
      total_seconds:
        (.total_duration / 1000000000)
    }'
```
Run the same prompt at least three times:
·      First run includes model-loading/warm-up effects.
·      Later runs better represent steady-state performance.
·      Keep context, prompt, temperature, and output requirements identical.
# 21. Monitor a benchmark in real time

Open three terminals.

## Terminal 1: Run the model

|   |
|---|
|1     ollama run gemma3:4b|

## Terminal 2: Check model placement

|   |
|---|
|1     watch -n 1 ollama ps|

## Terminal 3: Check hardware

For NVIDIA:

|   |
|---|
|1     watch -n 1 nvidia-smi|

For CPU and RAM:

|   |
|---|
|1     htop|

For overall memory:

|   |
|---|
|1     watch -n 1 free -h|

Look for:

·      whether the model is fully on the GPU;

·      VRAM consumption;

·      CPU utilization;

·      RAM and swap usage;

·      model unloads or crashes;

·      thermal throttling;

·      tokens per second.

# 22. Swap: useful protection, poor model memory

Check swap:

|   |
|---|
|1     swapon --show<br><br>2     free -h|

Swap can prevent the system from immediately terminating a process when RAM is exhausted, but it is not a substitute for RAM or VRAM.

If a model actively pages through swap:

·      generation may become extremely slow;

·      the desktop may freeze;

·      storage activity may remain high;

·      the system can become unresponsive.

Monitor paging:

|   |
|---|
|1     vmstat 1|

The si and so columns indicate swap input and output. Sustained nonzero values while generating usually signal memory pressure.

Select a smaller model or reduce context instead of relying on swap.

# 23. Storage planning

Inspect available space:

|   |
|---|
|1     df -h /|

Find where Ollama stores its models:

|   |
|---|
|1     systemctl cat ollama \| grep -i OLLAMA_MODELS|

Check model storage size:

|   |
|---|
|1     sudo du -sh /usr/share/ollama/.ollama/models 2>/dev/null<br><br>2     du -sh ~/.ollama/models 2>/dev/null|

List installed models:

|   |
|---|
|1     ollama list|

Remove an unused model:

|   |
|---|
|1     ollama rm MODEL_NAME|

Plan for:

·      multiple quantizations;

·      model updates;

·      embedding models;

·      vector databases;

·      source documents;

·      Docker containers;

·      temporary downloads.

#### Simple decision process
|   |
|---|
|1     Free/available system RAM<br><br>2     Free dedicated VRAM<br><br>3     Available storage|

## Step 3: Choose a conservative starting size

·      8 GB RAM → 1B–3B.

·      16 GB RAM → 3B–8B.

·      32 GB RAM → 8B–14B.

·      64 GB RAM → 27B–32B.

# Recommended first local model set

For a typical learning laptop, start with:

|   |
|---|
|1     ollama pull llama3.2:3b<br><br>2     ollama pull gemma3:4b|

Use them as follows:

·      **Llama 3.2 3B:** fast text assistant and tool experiments.

·      **Gemma 3 4B:** stronger general experimentation and image input.

If the laptop has at least 24–32 GB RAM or approximately 12 GB VRAM, add:

|   |
|---|
|1     ollama pull gemma3:12b|

If you primarily need coding, add one coding-specialized model appropriate for your memory rather than downloading several general chat models.