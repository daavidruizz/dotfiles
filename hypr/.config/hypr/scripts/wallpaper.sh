#!/usr/bin/env bash
# wallpaper.sh — gestor unificado de wallpaper
#
#   wallpaper.sh [select]   selector manual con rofi   (awww)
#   wallpaper.sh random     imagen estática aleatoria  (awww)
#   wallpaper.sh video      vídeo aleatorio            (mpvpaper)
#
# Backends: awww para estáticos, mpvpaper para vídeo.

# --- Config ---
WALL_DIR="$HOME/wallpapers"   # imágenes del selector manual (recursivo)
RANDOM_DIR="$WALL_DIR/random" # imágenes del modo random
VIDEO_DIR="$WALL_DIR/videos"  # vídeos del modo video

# Transición de awww
TRANSITION_TYPE="grow"
TRANSITION_FPS=60
TRANSITION_DURATION=1

# --- Utilidades ---
stop() { pkill "$@" 2>/dev/null || true; }
monitors() { hyprctl monitors | awk '/^Monitor /{print $2}'; }

find_images() {
  find "$1" -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
    2>/dev/null
}

# Mata mpvpaper, asegura el daemon de awww y aplica la imagen $1 en todos los monitores
set_static() {
  stop -9 mpvpaper
  awww query &>/dev/null || {
    awww-daemon &
    disown
    sleep 0.5
  }
  awww img "$1" \
    --transition-type "$TRANSITION_TYPE" \
    --transition-fps "$TRANSITION_FPS" \
    --transition-duration "$TRANSITION_DURATION"
}

# --- Modos ---
mode_select() {
  mapfile -t walls < <(find_images "$WALL_DIR" | sort)
  [ "${#walls[@]}" -eq 0 ] && {
    notify-send "Wallpaper" "Sin imágenes en $WALL_DIR"
    exit 1
  }

  local chosen
  chosen=$(
    for img in "${walls[@]}"; do
      printf '%s\0icon\x1f%s\n' "${img#"$WALL_DIR"/}" "$img"
    done | rofi -dmenu -i -show-icons -p "Wallpaper"
  )
  [ -z "$chosen" ] && exit 0
  set_static "$WALL_DIR/$chosen"
}

mode_random() {
  local wall
  wall=$(find_images "$RANDOM_DIR" | shuf -n1)
  [ -z "$wall" ] && {
    notify-send "Wallpaper" "Sin imágenes en $RANDOM_DIR"
    exit 1
  }
  sleep 2
  echo "Wallpaper elegido: $wall"
  set_static "$wall"
}

mode_video() {
  stop awww-daemon # sin fondo estático compitiendo detrás del vídeo
  stop -9 mpvpaper
  sleep 0.3

  local vid
  vid=$(find "$VIDEO_DIR" -type f 2>/dev/null | shuf -n1)
  [ -z "$vid" ] && {
    notify-send "Wallpaper" "Sin vídeos en $VIDEO_DIR"
    exit 1
  }

  while read -r mon; do
    mpvpaper -o "no-audio loop no-config hwdec=nvdec-copy" "$mon" "$vid" &
    disown
  done < <(monitors)
}

# --- Dispatch ---
case "${1:-select}" in
select | "") mode_select ;;
random) mode_random ;;
video) mode_video ;;
*)
  echo "Uso: $(basename "$0") [select|random|video]" >&2
  exit 1
  ;;
esac
