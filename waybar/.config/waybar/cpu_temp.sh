#!/bin/bash
# AMD Ryzen (k10temp)
temp=$(sensors k10temp-* 2>/dev/null | grep "Tctl:" | awk '{print $2}' | sed 's/+//;s/°C//' | head -1)

# Intel (coretemp) — fallback
if [ -z "$temp" ]; then
  temp=$(sensors coretemp-* 2>/dev/null | grep "Package id 0:" | awk '{print $4}' | sed 's/+//;s/°C//' | head -1)
fi

echo "${temp:-0}"
