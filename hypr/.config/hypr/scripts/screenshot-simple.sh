#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

case "$1" in
    "area")
        FILE="$SCREENSHOT_DIR/screenshot_area_$TIMESTAMP.png"
        grim -g "$(slurp)" "$FILE"
        wl-copy < "$FILE"
        notify-send "Screenshot" "Área guardada y copiada"
        ;;
    "full")
        FILE="$SCREENSHOT_DIR/screenshot_full_$TIMESTAMP.png"
        grim "$FILE"
        wl-copy < "$FILE"
        notify-send "Screenshot" "Pantalla completa guardada y copiada"
        ;;
    "window")
        FILE="$SCREENSHOT_DIR/screenshot_window_$TIMESTAMP.png"
        grimblast save active "$FILE"
        wl-copy < "$FILE"
        notify-send "Screenshot" "Ventana guardada y copiada"
        ;;
    *)
        echo "Uso: $0 {area|full|window}"
        exit 1
        ;;
esac

echo "$FILE"
