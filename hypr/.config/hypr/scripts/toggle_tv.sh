#!/bin/bash
# ~/scripts/toggle_tv.sh

# Verificar si HDMI-A-2 está activo en la lista de monitores actuales
if hyprctl monitors | grep -q "HDMI-A-2"; then
  # TV activa -> Deshabilitarla usando la nueva sintaxis Lua
  hyprctl dispatch config "monitor = { 'HDMI-A-2', 'disable' }"
  notify-send "TV" "Monitor deshabilitado" -i display
  echo "TV deshabilitada"
else
  # TV inactiva -> Habilitarla con su respectiva tabla de configuración en Lua
  hyprctl dispatch config "monitor = { 'HDMI-A-2', '1920x1080@60', '960x-1080', '1' }"
  notify-send "TV" "Monitor habilitado" -i display
  echo "TV habilitada"
fi
