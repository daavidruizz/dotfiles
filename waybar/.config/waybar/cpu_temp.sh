#!/bin/bash
# Temperatura CPU AMD Ryzen
temp=$(sensors k10temp-pci-00c3 | grep "Tctl:" | awk '{print $2}' | sed 's/+//;s/°C//')
if [ ! -z "$temp" ]; then
  echo "$temp"
else
  echo "0"
fi
