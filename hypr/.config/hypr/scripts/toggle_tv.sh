#!/bin/bash
# ~/scripts/toggle_tv.sh

# Verificar si HDMI-A-1 aparece en la lista de monitores
if hyprctl monitors | grep -q "HDMI-A-1"; then
    # TV aparece = está habilitada - deshabilitarla
    hyprctl keyword monitor "HDMI-A-1, disable"
    notify-send "TV" "Monitor deshabilitado" -i display
    echo "TV deshabilitada"
else
    # TV no aparece = está deshabilitada - habilitarla
    hyprctl keyword monitor "HDMI-A-1, 1920x1080@60, 960x-1080, 1"
    notify-send "TV" "Monitor habilitado" -i display
    echo "TV habilitada"
fi
