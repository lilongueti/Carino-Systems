#!/bin/bash

# Check if nvidia-smi command exists
if ! command -v nvidia-smi &> /dev/null; then
    echo "nvidia-smi command not found. Please make sure you have NVIDIA drivers installed."
    exit 1
fi

# Get GPU temperature
temperature=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)

echo "${temperature}°C"
