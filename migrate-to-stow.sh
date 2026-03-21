#!/bin/bash
# migrate-to-stow.sh
# Reorganiza la estructura de dotfiles de "flat" a estructura GNU Stow.
#
# ANTES (estructura actual):
#   dotfiles/hypr/hyprland.conf
#
# DESPUÉS (estructura stow):
#   dotfiles/hypr/.config/hypr/hyprland.conf
#
# IMPORTANTE: Este script NO toca ~/.config/ ni crea ningún symlink.
#             Solo reorganiza los archivos dentro de ~/dotfiles/.
#             Ejecutar manualmente cuando estés listo.
#
# USO: bash migrate-to-stow.sh [--dry-run]
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
LOG_FILE="$DOTFILES/migrate-to-stow.log"

[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

# -------------------------------------------------------
# Helpers
# -------------------------------------------------------
log() { echo "$1" | tee -a "$LOG_FILE"; }
run() {
  log "  CMD: $*"
  if ! $DRY_RUN; then
    "$@"
  fi
}

log ""
log "════════════════════════════════════════════"
log " migrate-to-stow.sh  $(date '+%Y-%m-%d %H:%M:%S')"
$DRY_RUN && log " MODO: DRY RUN (no se mueve nada)"
log "════════════════════════════════════════════"

# -------------------------------------------------------
# Función genérica: mueve contenido a estructura stow
# move_to_stow <modulo> <destino_relativo_al_home>
#
# Ejemplo:
#   move_to_stow "hypr" ".config/hypr"
#   mueve dotfiles/hypr/*.conf → dotfiles/hypr/.config/hypr/
# -------------------------------------------------------
move_to_stow() {
  local module="$1"        # nombre del directorio en dotfiles/
  local dest_rel="$2"      # ruta relativa a $HOME donde vive el config

  local src="$DOTFILES/$module"
  local stow_dest="$DOTFILES/$module/$dest_rel"

  log ""
  log "── $module → $dest_rel"

  if [ ! -d "$src" ]; then
    log "  [SKIP] $src no existe"
    return
  fi

  # Crear estructura de destino
  run mkdir -p "$stow_dest"

  # Mover todos los archivos/dirs excepto el propio destino y los install.sh
  for item in "$src"/*; do
    local name
    name="$(basename "$item")"

    # Saltar: el propio directorio stow destino, install.sh y archivos .log
    if [[ "$name" == ".config" || "$name" == ".local" || \
          "$name" == "install.sh" || "$name" == *.log ]]; then
      log "  [SKIP] $name (protegido)"
      continue
    fi

    log "  [MOVE] $name → $dest_rel/$name"
    run mv "$item" "$stow_dest/$name"
  done

  log "  [OK] $module listo"
}

# -------------------------------------------------------
# Caso especial para rofi: tiene archivos en .config/rofi
# Y también en .local/share/rofi/themes (mismo package)
# -------------------------------------------------------
migrate_rofi() {
  local src="$DOTFILES/rofi"
  local stow_config="$DOTFILES/rofi/.config/rofi"
  local stow_themes="$DOTFILES/rofi/.local/share/rofi/themes"

  log ""
  log "── rofi (multi-destino)"

  run mkdir -p "$stow_config/template"
  run mkdir -p "$stow_themes"

  for f in config.rasi launchpad.rasi rounded-nord-dark.rasi; do
    [ -f "$src/$f" ] && run mv "$src/$f" "$stow_config/$f" && log "  [MOVE] $f → .config/rofi/"
  done
  [ -d "$src/template" ] && run mv "$src/template" "$stow_config/template" && log "  [MOVE] template/ → .config/rofi/template/"

  # Duplicar temas en .local/share también (rofi los busca ahí)
  for f in launchpad.rasi rounded-nord-dark.rasi; do
    if [ -f "$stow_config/$f" ]; then
      run cp "$stow_config/$f" "$stow_themes/$f"
      log "  [COPY] $f → .local/share/rofi/themes/"
    fi
  done

  log "  [OK] rofi listo"
}

# -------------------------------------------------------
# Caso especial para gtk: gtk-2.0, gtk-3.0, gtk-4.0 y nwg-look
# todo bajo el mismo package "gtk"
# -------------------------------------------------------
migrate_gtk() {
  local src="$DOTFILES/gtk"

  log ""
  log "── gtk (multi-destino)"

  for subdir in gtk-2.0 gtk-3.0 gtk-4.0 nwg-look; do
    if [ -d "$src/$subdir" ]; then
      local stow_dest="$DOTFILES/gtk/.config/$subdir"
      run mkdir -p "$stow_dest"
      run mv "$src/$subdir" "$DOTFILES/gtk/.config/"
      log "  [MOVE] $subdir → .config/$subdir"
    fi
  done

  log "  [OK] gtk listo"
}

# -------------------------------------------------------
# Wallpapers: van a ~/wallpapers/ y ~/Pictures/ (no ~/.config)
# -------------------------------------------------------
migrate_wallpapers() {
  local src="$DOTFILES/wallpapers"

  log ""
  log "── wallpapers (no-stow: van a ~ directamente)"
  log "  Los wallpapers NO se gestionan con stow."
  log "  Se copian con install.sh de wallpapers (ya existe)."
  log "  [SKIP] wallpapers — sin cambios"
}

# -------------------------------------------------------
# EJECUCIÓN
# -------------------------------------------------------

move_to_stow "hypr"         ".config/hypr"
move_to_stow "waybar"       ".config/waybar/dev"
move_to_stow "dunst"        ".config/dunst"
move_to_stow "kitty"        ".config/kitty"
move_to_stow "nwg-dock"     ".config/nwg-dock-hyprland"
move_to_stow "wlogout"      ".config/wlogout"
move_to_stow "thunar"       ".config/Thunar"
move_to_stow "easyeffects"  ".config/easyeffects"
move_to_stow "fastfetch"    ".config/fastfetch"
move_to_stow "btop"         ".config/btop"

migrate_rofi
migrate_gtk
migrate_wallpapers

log ""
log "════════════════════════════════════════════"
log " Migración completada."
log " Siguiente paso: bash install.sh"
log " Log guardado en: $LOG_FILE"
log "════════════════════════════════════════════"
log ""
