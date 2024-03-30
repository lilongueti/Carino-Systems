#!/bin/bash

# Query NVIDIA GPU memory total (memory.total) and used (memory.used) via nvidia-smi
read total used <<<$(nvidia-smi --query-gpu=memory.total,memory.used --format=csv,noheader,nounits | awk -F', ' '{print $1" "$2}')

# Convert MB to GB for total and used memory
total_gb=$(echo "$total / 1024" | bc -l)
used_gb=$(echo "$used / 1024" | bc -l)

# Output for Waybar: Used GB / Total GB
printf "%.2f GB / %.2f GB\n" $used_gb $total_gb
