#!/usr/bin/env bash
#
# Script para contar actualizaciones disponibles
#

_checkCommandExists() {
  cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo 1
    return
  fi
  echo 0
  return
}

# Evitar múltiples instancias
script_name=$(basename "$0")
instance_count=$(pgrep -fc "$script_name")
if [ "$instance_count" -gt 1 ]; then
  sleep $((instance_count))
fi

# Umbrales para colores
threshhold_green=0
threshhold_yellow=10
threshhold_red=25

# Verificar archivos de bloqueo de pacman
check_lock_files() {
  local pacman_lock="/var/lib/pacman/db.lck"
  local checkup_lock="${TMPDIR:-/tmp}/checkup-db-${UID}/db.lck"

  while [ -f "$pacman_lock" ] || [ -f "$checkup_lock" ]; do
    sleep 1
  done
}

# Inicializar contadores
updates_aur=0
updates_pacman=0
updates=0

# Detectar sistema y contar actualizaciones
if [[ $(_checkCommandExists "pacman") == 0 ]]; then
  # Sistema Arch Linux
  check_lock_files

  # Detectar helper de AUR
  aur_helper=""
  if [[ $(_checkCommandExists "yay") == 0 ]]; then
    aur_helper="yay"
  elif [[ $(_checkCommandExists "paru") == 0 ]]; then
    aur_helper="paru"
  fi

  # Contar actualizaciones oficiales
  if command -v checkupdates >/dev/null 2>&1; then
    updates_pacman=$(checkupdates 2>/dev/null | wc -l)
  else
    updates_pacman=$(pacman -Qu 2>/dev/null | wc -l)
  fi

  # Contar actualizaciones AUR
  if [[ -n "$aur_helper" ]]; then
    case "$aur_helper" in
    "yay")
      updates_aur=$(yay -Qum 2>/dev/null | wc -l)
      ;;
    "paru")
      updates_aur=$(paru -Qum 2>/dev/null | wc -l)
      ;;
    esac
  fi

  updates=$((updates_aur + updates_pacman))

elif [[ $(_checkCommandExists "dnf") == 0 ]]; then
  # Sistema Fedora
  updates=$(dnf check-update -q 2>/dev/null | grep -c "^[a-zA-Z0-9]")

elif [[ $(_checkCommandExists "apt") == 0 ]]; then
  # Sistema Debian/Ubuntu
  updates=$(apt list --upgradable 2>/dev/null | grep -c upgradable)

else
  # Sistema no soportado
  updates=0
fi

# Determinar clase CSS
css_class="green"
if [ "$updates" -gt $threshhold_yellow ]; then
  css_class="yellow"
fi
if [ "$updates" -gt $threshhold_red ]; then
  css_class="red"
fi

# Generar output JSON para Waybar
if [ "$updates" -gt 0 ]; then
  tooltip="$updates actualizaciones disponibles\\nClick para actualizar"
  if [ "$updates_pacman" -gt 0 ] && [ "$updates_aur" -gt 0 ]; then
    tooltip="Oficiales: $updates_pacman | AUR: $updates_aur\\nClick para actualizar"
  elif [ "$updates_pacman" -gt 0 ]; then
    tooltip="$updates_pacman actualizaciones oficiales\\nClick para actualizar"
  elif [ "$updates_aur" -gt 0 ]; then
    tooltip="$updates_aur actualizaciones de AUR\\nClick para actualizar"
  fi

  printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s"}' \
    "$updates" "$updates" "$tooltip" "$css_class"
else
  printf '{"text": "", "alt": "0", "tooltip": "Sistema actualizado", "class": "green"}'
fi
