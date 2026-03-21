#!/bin/bash
COVER="/tmp/hyprlock-cover.jpg"
COVER_URL="/tmp/hyprlock-cover-url.txt"
DEFAULT="$HOME/Pictures/default-no-music.jpg"

URL=$(/usr/bin/playerctl metadata mpris:artUrl 2>/dev/null)

if [ -z "$URL" ]; then
  echo "$DEFAULT"
  exit
fi

# Solo descarga si la URL cambió
LAST_URL=$(cat "$COVER_URL" 2>/dev/null)
if [ "$URL" != "$LAST_URL" ] || [ ! -f "$COVER" ]; then
  curl -s "$URL" -o "$COVER" 2>/dev/null
  echo "$URL" > "$COVER_URL"
fi

echo "$COVER"
