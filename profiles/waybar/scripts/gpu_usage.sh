#!/bin/bash

# Query NVIDIA GPU usage (utilization.gpu) via nvidia-smi
usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

# Output for Waybar: GPU Usage Percentage
echo "$usage%"
