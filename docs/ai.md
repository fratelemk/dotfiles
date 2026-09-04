# Running llama.cpp on Raspberry Pi 5

Prerequisites
```bash
apt update && sudo apt install cmake build-essential git -y
git clone https://github.com/ggml-org/llama.cpp.git && cd llama.cpp
```

Build
```bash
cmake .. -DGGML_ARM_FMA=ON \
         -DGGML_ARM_DOTPROD=ON \
         -DGGML_NATIVE=ON \
         -DGGML_LTO=ON \
         -DGGML_ARM_SVE=OFF
cmake --build . --config Release -j4
```

Tune
```bash
echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
echo always | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
sysctl vm.swappiness=1
cpufreq-set -g performance
```

Run
```bash
taskset -c 0,1,2,3 ./llama-cli \
  -m models/gemma-4-e2b-it-Q4_K_M.gguf \
  -t 4 \
  --cache-type-k q4_0 \
  --cache-type-v q4_0 \
  --ctx-size 4096 \
  --batch-size 256 \
  --ubatch-size 64 \
  --flash-attn \
  --mlock \
  --poll \
  --prio 3 \
  --mlock \
  --no-mmap:
```
