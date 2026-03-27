#!/bin/bash
# Contenido del script
command -v nvidia-smi &>/dev/null || exit 0
temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
[ -n "$temp" ] && echo "$temp"
