#!/bin/bash
WALLPAPER_DIR="$HOME/wallpapers/LOTR"
RANDOM_WALL="$WALLPAPER_DIR/$(ls "$WALLPAPER_DIR" | grep -iE '\.(jpg|jpeg|png|webp)$' | shuf -n 1)"

pkill hyprpaper 2>/dev/null
sleep 1
hyprpaper &
sleep 3

echo "Wallpaper elegido: $RANDOM_WALL"
#hyprctl hyprpaper preload "$RANDOM_WALL"
#echo "Preload: $?"

hyprctl monitors | grep "Monitor " | awk '{print $2}' | while read monitor; do
  echo "Aplicando en $monitor"
  hyprctl hyprpaper wallpaper "$monitor,$RANDOM_WALL"
done
