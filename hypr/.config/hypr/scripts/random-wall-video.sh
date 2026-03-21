#!/bin/bash
WALLPAPER_DIR="$HOME/wallpapers/videos"
RANDOM_WALL=$(ls "$WALLPAPER_DIR" | shuf -n 1)
pkill -9 mpvpaper 2>/dev/null
sleep 0.3

hyprctl monitors | grep "Monitor " | awk '{print $2}' | while read monitor; do
  mpvpaper -o "no-audio loop no-config hwdec=nvdec-copy" "$monitor" "$WALLPAPER_DIR/$RANDOM_WALL" &
done
