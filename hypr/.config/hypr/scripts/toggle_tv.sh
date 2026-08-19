#!/bin/bash
# ~/.config/hypr/scripts/toggle_tv.sh
if hyprctl monitors -j | jq -e '.[] | select(.name=="HDMI-A-2")' >/dev/null; then
  # TV activa -> deshabilitar
  hyprctl eval 'hl.monitor({ output = "HDMI-A-2", disabled = true })'
  notify-send "TV" "Monitor deshabilitado" -i display
else
  # TV inactiva -> habilitar (restaura su config normal)
  hyprctl eval 'hl.monitor({ output = "HDMI-A-2", mode = "1920x1080@60", position = "960x-1080", scale = 1 })'
  notify-send "TV" "Monitor habilitado" -i display
fi
#hyprctl reload -> no funciona del todo bien, TODO
