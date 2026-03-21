#!/usr/bin/env bash
#
# Script para instalar actualizaciones con ventana flotante
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

# Función para abrir en ventana flotante
open_floating_terminal() {
  local script_path="$0"

  # Detectar compositor y abrir ventana flotante
  if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
    # Hyprland - aplicar reglas dinámicamente
    hyprctl keyword windowrulev2 "float,class:(floating-updates)" 2>/dev/null
    hyprctl keyword windowrulev2 "center,class:(floating-updates)" 2>/dev/null
    hyprctl keyword windowrulev2 "size 900 650,class:(floating-updates)" 2>/dev/null

    if command -v kitty >/dev/null 2>&1; then
      kitty --class="floating-updates" --title="Actualizaciones del Sistema" \
        -o initial_window_width=900 -o initial_window_height=650 \
        -e bash "$script_path" &
    elif command -v alacritty >/dev/null 2>&1; then
      alacritty --class="floating-updates" --title="Actualizaciones del Sistema" \
        --option window.dimensions.columns=110 \
        --option window.dimensions.lines=35 \
        -e bash "$script_path" &
    else
      xterm -class "floating-updates" -title "Actualizaciones del Sistema" \
        -geometry 110x35+200+200 -e bash "$script_path" &
    fi

  elif [[ "$XDG_CURRENT_DESKTOP" == "sway" ]] || command -v sway >/dev/null 2>&1; then
    # Sway
    swaymsg for_window '[app_id="floating-updates"]' floating enable 2>/dev/null || true
    swaymsg for_window '[app_id="floating-updates"]' resize set 900 650 2>/dev/null || true

    if command -v kitty >/dev/null 2>&1; then
      kitty --class="floating-updates" --title="Actualizaciones del Sistema" \
        -e bash "$script_path" &
    elif command -v alacritty >/dev/null 2>&1; then
      alacritty --class="floating-updates" --title="Actualizaciones del Sistema" \
        -e bash "$script_path" &
    else
      xterm -class "floating-updates" -title "Actualizaciones del Sistema" \
        -geometry 110x35+200+200 -e bash "$script_path" &
    fi

  else
    # Fallback para otros WM
    if command -v kitty >/dev/null 2>&1; then
      kitty --class="floating-updates" --title="Actualizaciones del Sistema" \
        -o initial_window_width=900 -o initial_window_height=650 \
        -e bash "$script_path" &
    elif command -v alacritty >/dev/null 2>&1; then
      alacritty --class="floating-updates" --title="Actualizaciones del Sistema" \
        --option window.dimensions.columns=110 \
        --option window.dimensions.lines=35 \
        -e bash "$script_path" &
    elif command -v gnome-terminal >/dev/null 2>&1; then
      gnome-terminal --class="floating-updates" --title="Actualizaciones del Sistema" \
        --geometry=110x35+200+200 \
        -- bash "$script_path" &
    else
      xterm -class "floating-updates" -title "Actualizaciones del Sistema" \
        -geometry 110x35+200+200 -e bash "$script_path" &
    fi
  fi
}

# Función de título con estilo
show_title() {
  clear
  echo -e "\033[1;36m╔══════════════════════════════════════╗\033[0m"
  echo -e "\033[1;36m║        \033[1;33mACTUALIZACIONES DEL SISTEMA\033[1;36m     ║\033[0m"
  echo -e "\033[1;36m╚══════════════════════════════════════╝\033[0m"
  echo
}

# Función de confirmación
confirm_update() {
  echo -e "\033[1;33m┌─────────────────────────────────────┐\033[0m"
  echo -e "\033[1;33m│              CONFIRMACIÓN           │\033[0m"
  echo -e "\033[1;33m└─────────────────────────────────────┘\033[0m"
  echo
  echo -e "\033[1;32m¿Deseas proceder con la actualización?\033[0m"
  echo -e "\033[0;37m[s/S] Sí  [n/N] No (por defecto)\033[0m"
  echo -n "> "

  read -r response
  case "$response" in
  [sS] | [sS][iI] | [yY] | [yY][eE][sS])
    return 0
    ;;
  *)
    return 1
    ;;
  esac
}

# Mostrar actualizaciones disponibles
show_available_updates() {
  echo -e "\033[1;34m🔍 Buscando actualizaciones disponibles...\033[0m"
  echo

  local total_updates=0

  if [[ $(_checkCommandExists "pacman") == 0 ]]; then
    # Sistema Arch Linux
    echo -e "\033[1;35m╭─ ACTUALIZACIONES OFICIALES ─────────────╮\033[0m"
    local official_updates=""
    if command -v checkupdates >/dev/null 2>&1; then
      official_updates=$(checkupdates 2>/dev/null)
    else
      official_updates=$(pacman -Qu 2>/dev/null)
    fi

    if [[ -n "$official_updates" ]]; then
      echo "$official_updates" | head -10
      local count=$(echo "$official_updates" | wc -l)
      total_updates=$((total_updates + count))
      if [[ $count -gt 10 ]]; then
        echo -e "\033[0;37m... y $((count - 10)) más\033[0m"
      fi
    else
      echo -e "\033[0;32m✓ No hay actualizaciones oficiales\033[0m"
    fi
    echo -e "\033[1;35m╰─────────────────────────────────────────╯\033[0m"

    echo
    echo -e "\033[1;35m╭─ ACTUALIZACIONES AUR ───────────────────╮\033[0m"
    local aur_updates=""
    if [[ $(_checkCommandExists "yay") == 0 ]]; then
      aur_updates=$(yay -Qum 2>/dev/null)
    elif [[ $(_checkCommandExists "paru") == 0 ]]; then
      aur_updates=$(paru -Qum 2>/dev/null)
    fi

    if [[ -n "$aur_updates" ]]; then
      echo "$aur_updates" | head -10
      local aur_count=$(echo "$aur_updates" | wc -l)
      total_updates=$((total_updates + aur_count))
      if [[ $aur_count -gt 10 ]]; then
        echo -e "\033[0;37m... y $((aur_count - 10)) más\033[0m"
      fi
    else
      echo -e "\033[0;32m✓ No hay actualizaciones de AUR\033[0m"
    fi
    echo -e "\033[1;35m╰─────────────────────────────────────────╯\033[0m"

  elif [[ $(_checkCommandExists "dnf") == 0 ]]; then
    # Sistema Fedora
    echo -e "\033[1;35m╭─ ACTUALIZACIONES DISPONIBLES ───────────╮\033[0m"
    local updates=$(dnf check-update -q 2>/dev/null | head -15)
    if [[ -n "$updates" ]]; then
      echo "$updates"
      total_updates=$(echo "$updates" | wc -l)
    else
      echo -e "\033[0;32m✓ No hay actualizaciones disponibles\033[0m"
    fi
    echo -e "\033[1;35m╰─────────────────────────────────────────╯\033[0m"

  elif [[ $(_checkCommandExists "apt") == 0 ]]; then
    # Sistema Debian/Ubuntu
    echo -e "\033[1;35m╭─ ACTUALIZACIONES DISPONIBLES ───────────╮\033[0m"
    sudo apt update -qq 2>/dev/null
    local updates=$(apt list --upgradable 2>/dev/null | grep -v "^Listing" | head -15)
    if [[ -n "$updates" ]]; then
      echo "$updates"
      total_updates=$(echo "$updates" | wc -l)
    else
      echo -e "\033[0;32m✓ No hay actualizaciones disponibles\033[0m"
    fi
    echo -e "\033[1;35m╰─────────────────────────────────────────╯\033[0m"

  else
    echo -e "\033[0;31m❌ Sistema no soportado\033[0m"
    return 1
  fi

  echo
  if [[ $total_updates -gt 0 ]]; then
    echo -e "\033[1;33m📊 Total: $total_updates actualizaciones disponibles\033[0m"
  else
    echo -e "\033[1;32m🎉 Sistema completamente actualizado\033[0m"
  fi
  echo
}

# Realizar actualización
perform_update() {
  echo -e "\033[1;32m🚀 Iniciando actualización...\033[0m"
  echo -e "\033[1;36m══════════════════════════════════════════════════\033[0m"

  if [[ $(_checkCommandExists "pacman") == 0 ]]; then
    # Sistema Arch Linux
    echo -e "\033[1;34m📦 Actualizando repositorios oficiales...\033[0m"
    sudo pacman -Syu

    echo
    echo -e "\033[1;34m🔧 Actualizando paquetes AUR...\033[0m"
    if [[ $(_checkCommandExists "yay") == 0 ]]; then
      yay -Syu --noconfirm
    elif [[ $(_checkCommandExists "paru") == 0 ]]; then
      paru -Syu --noconfirm
    else
      echo -e "\033[0;33m⚠ No se encontró helper de AUR\033[0m"
    fi

  elif [[ $(_checkCommandExists "dnf") == 0 ]]; then
    # Sistema Fedora
    echo -e "\033[1;34m📦 Actualizando sistema Fedora...\033[0m"
    sudo dnf upgrade

  elif [[ $(_checkCommandExists "apt") == 0 ]]; then
    # Sistema Debian/Ubuntu
    echo -e "\033[1;34m📦 Actualizando lista de paquetes...\033[0m"
    sudo apt update
    echo -e "\033[1;34m📦 Instalando actualizaciones...\033[0m"
    sudo apt upgrade

  else
    echo -e "\033[0;31m❌ Error: Sistema no soportado\033[0m"
    exit 1
  fi

  # Actualizar Flatpak
  if [[ $(_checkCommandExists "flatpak") == 0 ]]; then
    echo
    echo -e "\033[1;34m📱 Actualizando aplicaciones Flatpak...\033[0m"
    flatpak update -y
  fi
}

# Función principal
main() {
  # Si no se ejecuta desde terminal, abrir ventana flotante
  if [ ! -t 0 ]; then
    open_floating_terminal
    exit 0
  fi

  show_title
  show_available_updates

  if confirm_update; then
    echo
    echo -e "\033[1;32m✅ Iniciando actualización...\033[0m"
    sleep 1
    perform_update

    echo
    echo -e "\033[1;36m══════════════════════════════════════════════════\033[0m"
    echo -e "\033[1;32m🎉 ACTUALIZACIÓN COMPLETADA 🎉\033[0m"
    echo -e "\033[1;36m══════════════════════════════════════════════════\033[0m"

    # Recargar Waybar
    pkill -RTMIN+1 waybar 2>/dev/null || pkill -USR1 waybar 2>/dev/null

    echo
    echo -e "\033[1;33m📋 Presiona ENTER para cerrar...\033[0m"
    read -r
  else
    echo
    echo -e "\033[1;31m❌ Actualización cancelada.\033[0m"
    echo -e "\033[1;33m📋 Presiona ENTER para cerrar...\033[0m"
    read -r
  fi
}

# Manejar interrupción
trap 'echo -e "\n\033[1;31m🛑 Interrumpido\033[0m"; exit 1' INT TERM

# Ejecutar
main "$@"
