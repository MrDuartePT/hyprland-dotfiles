#!/bin/bash
CPU_TEMP_VALUE=$(sensors | grep 'Tctl:' | tr -d 'Tctl: +')

GPU_TEMP_VALUE=$(nvidia-smi -q -d temperature | grep 'GPU Current Temp' | tr -d 'GPU Current Temp:')

echo 󰻠 $CPU_TEMP_VALUE 󰢮 $GPU_TEMP_VALUEºC 