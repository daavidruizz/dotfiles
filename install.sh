#!/bin/bash
# install.sh - Setup completo del entorno Hyprland (vía GNU Stow)
#
# USO:
#   bash install.sh                           # instala todo
#   bash install.sh --only hypr waybar kitty  # solo esos módulos
#   bash install.sh --dry-run                 # simula sin aplicar nada
#   bash install.sh --stow-only               # solo fuentes + stow + wallpapers
#   bash install.sh --stow-only --only hypr   # igual pero solo ese módulo
#
# LOG: se guarda en install.log (en el directorio del script)

set -uo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$DOTFILES/install.log"
DRY_RUN=false
STOW_ONLY=false
declare -a ONLY_MODULES=()
declare -a FAILED=()
declare -a ALL_MODULES=(hypr waybar dunst rofi nwg-dock kitty wlogout thunar easyeffects fastfetch btop gtk nvim swayosd vim bash qt)

# -------------------------------------------------------
# Menú interactivo (solo si no se pasan argumentos)
# -------------------------------------------------------
if [[ $# -eq 0 ]]; then
  echo ""
  echo "╔══════════════════════════════════════════╗"
  echo "║   Hyprland Dotfiles - Instalador         ║"
  echo "╠══════════════════════════════════════════╣"
  echo "║  1) Instalación completa                 ║"
  echo "║  2) Solo stow (fuentes + links + walls)  ║"
  echo "║  3) Stow de un módulo concreto           ║"
  echo "╚══════════════════════════════════════════╝"
  echo ""
  read -rp "Opción [1-3]: " menu_opt

  case "$menu_opt" in
    1) ;;
    2) STOW_ONLY=true ;;
    3)
      echo ""
      echo "Módulos disponibles:"
      echo "  ${ALL_MODULES[*]}"
      echo ""
      read -rp "Módulo: " menu_module
      if [[ -z "$menu_module" ]]; then
        echo "No se especificó módulo. Saliendo."
        exit 1
      fi
      STOW_ONLY=true
      ONLY_MODULES=("$menu_module")
      ;;
    *)
      echo "Opción no válida. Saliendo."
      exit 1
      ;;
  esac
fi

# -------------------------------------------------------
# Parse argumentos (modo no interactivo)
# -------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)   DRY_RUN=true;  shift ;;
    --stow-only) STOW_ONLY=true; shift ;;
    --only) shift; while [[ $# -gt 0 && "$1" != --* ]]; do ONLY_MODULES+=("$1"); shift; done ;;
    *) echo "Argumento desconocido: $1"; exit 1 ;;
  esac
done

# -------------------------------------------------------
# Helpers
# -------------------------------------------------------
log()  { echo "$1" | tee -a "$LOG_FILE"; }
ok()   { log "  [OK]   $1"; }
fail() { log "  [FAIL] $1"; FAILED+=("$1"); }
skip() { log "  [SKIP] $1"; }
info() { log "  [INFO] $1"; }

# Ejecuta un comando, envía stdout+stderr a terminal Y al log.
# Retorna el exit code del comando (no el de tee).
run() {
  log "  CMD: $*"
  $DRY_RUN && return 0
  "$@" 2>&1 | tee -a "$LOG_FILE"
  return "${PIPESTATUS[0]}"
}

# -------------------------------------------------------
# Header
# -------------------------------------------------------
log ""
log "════════════════════════════════════════════════════"
log " Hyprland Dotfiles - Instalador (stow)"
log " $(date '+%Y-%m-%d %H:%M:%S')"
$DRY_RUN   && log " MODO: DRY RUN"
$STOW_ONLY && log " MODO: STOW ONLY (sin git pull ni paquetes)"
log "════════════════════════════════════════════════════"

# -------------------------------------------------------
# 0. GIT PULL
# -------------------------------------------------------
if ! $STOW_ONLY; then
  log ""
  log "==> [0/5] Sincronizando dotfiles con git..."
  if run git -C "$DOTFILES" pull --ff-only; then
    ok "git pull"
  else
    log "  [!] git pull falló o hay cambios locales. Continúa con la versión actual."
  fi
else
  log ""
  log "==> [0/5] git pull... OMITIDO (--stow-only)"
fi

# -------------------------------------------------------
# 1. PAQUETES PACMAN
# -------------------------------------------------------
if ! $STOW_ONLY; then
  log ""
  log "==> [1/5] Paquetes pacman..."

  declare -a PACMAN_PKGS=(
    hyprland hypridle hyprlock hyprpaper
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
    waybar dunst
    rofi wofi
    kitty thunar
    easyeffects wireplumber pipewire pipewire-pulse pavucontrol playerctl
    fastfetch btop htop brightnessctl networkmanager network-manager-applet
    bluez bluez-utils
    wl-clipboard
    polkit-gnome
    grim slurp
    firefox qalculate-gtk
    nwg-look nwg-dock-hyprland papirus-icon-theme adwaita-icon-theme
    noto-fonts noto-fonts-emoji
    ttf-font-awesome ttf-fira-sans ttf-roboto ttf-jetbrains-mono-nerd ttf-montserrat
    lm_sensors
    jq curl libnotify
    pacman-contrib
    vim neovim
    swayosd
    stow
    qt5ct qt6ct kvantum
  )

  if run sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"; then
    ok "pacman"
  else
    fail "pacman"
    log "  [!] Fallo en pacman, abortando (dependencia crítica)"
    exit 1
  fi
else
  log ""
  log "==> [1/5] Paquetes pacman... OMITIDO (--stow-only)"
fi

# -------------------------------------------------------
# 2. PAQUETES AUR
# -------------------------------------------------------
if ! $STOW_ONLY; then
  log ""
  log "==> [2/5] Paquetes AUR..."

  install_yay() {
    run sudo pacman -S --needed --noconfirm git base-devel || return 1
    run git clone https://aur.archlinux.org/yay.git /tmp/yay-install || return 1
    (cd /tmp/yay-install && run makepkg -si --noconfirm) || return 1
  }

  if ! command -v yay &>/dev/null; then
    info "yay no encontrado, instalando..."
    if install_yay; then
      ok "yay instalado"
    else
      fail "yay bootstrap"
      exit 1
    fi
  fi

  declare -a AUR_PKGS=(
    grimblast-git
    google-chrome
    adw-gtk3
    whitesur-icon-theme
    bibata-cursor-theme
    whitesur-cursor-theme
    ttf-sf-pro
    bluetuith
    mpvpaper
    wlogout
  )

  if run yay -S --needed --noconfirm --answerdiff=None --answerclean=None "${AUR_PKGS[@]}"; then
    ok "AUR"
  else
    fail "AUR"
    log "  [!] Algunos paquetes AUR fallaron. Continúa con el resto..."
  fi
else
  log ""
  log "==> [2/5] Paquetes AUR... OMITIDO (--stow-only)"
fi

# -------------------------------------------------------
# 3. FUENTES BUNDLED
# -------------------------------------------------------
log ""
log "==> [3/5] Fuentes bundled..."

FONTS_SRC="$DOTFILES/hypr/.config/hypr/hyprlock/Fonts"
FONTS_DEST="$HOME/.local/share/fonts"

if [ ! -d "$FONTS_SRC" ]; then
  fail "fuentes bundled (ruta no encontrada: $FONTS_SRC)"
else
  run mkdir -p "$FONTS_DEST"
  fonts_ok=true
  for font_dir in "SF Pro Display" "JetBrains"; do
    if [ -d "$FONTS_SRC/$font_dir" ]; then
      run cp -r "$FONTS_SRC/$font_dir/." "$FONTS_DEST/" || fonts_ok=false
    else
      log "  [SKIP] Fuente no encontrada en repo: $font_dir"
    fi
  done
  if $fonts_ok; then
    run fc-cache -fv
    ok "fuentes bundled"
  else
    fail "fuentes bundled (algunos archivos no se copiaron)"
  fi
fi

# -------------------------------------------------------
# 4. SYMLINKS VÍA STOW
# -------------------------------------------------------
log ""
log "==> [4/5] Creando symlinks con stow..."

if ! command -v stow &>/dev/null; then
  fail "stow no encontrado — instalar con: sudo pacman -S stow"
  exit 1
fi

if [ ${#ONLY_MODULES[@]} -gt 0 ]; then
  declare -a MODULES=("${ONLY_MODULES[@]}")
  info "Modo --only: ${MODULES[*]}"
else
  declare -a MODULES=("${ALL_MODULES[@]}")
fi

stow_module() {
  local module="$1"
  local stow_dir="$DOTFILES/$module"

  if [ ! -d "$stow_dir" ]; then
    skip "$module (directorio no encontrado: $stow_dir)"
    return
  fi

  if [ ! -d "$stow_dir/.config" ] && [ ! -d "$stow_dir/.local" ] && \
     [ -z "$(find "$stow_dir" -maxdepth 1 -name '.*' -not -name '.' | head -1)" ]; then
    fail "$module (no tiene estructura stow válida)"
    return
  fi

  # Backup de directorios reales que stow querría convertir en symlinks
  local bak_ts
  bak_ts="$(date +%Y%m%d_%H%M%S)"
  for base in .config .local/share .local/bin; do
    local pkg_base="$stow_dir/$base"
    [ -d "$pkg_base" ] || continue
    for pkg_subdir in "$pkg_base"/*/; do
      [ -d "$pkg_subdir" ] || continue
      local rel_subdir="${pkg_subdir#"$stow_dir/"}"
      rel_subdir="${rel_subdir%/}"
      local target_dir="$HOME/$rel_subdir"
      if [ -L "$target_dir" ] && [ ! -e "$target_dir" ]; then
        log "  [RM-BROKEN] $target_dir (symlink roto)"
        $DRY_RUN || rm "$target_dir"
      fi
      if [ -d "$target_dir" ] && [ ! -L "$target_dir" ]; then
        log "  [BAK] $target_dir → ${target_dir}.bak.$bak_ts"
        $DRY_RUN || mv "$target_dir" "${target_dir}.bak.$bak_ts"
      fi
    done
  done

  # Eliminar archivos/symlinks que colisionan con lo que stow quiere crear
  log "  Resolviendo conflictos para $module..."
  while IFS= read -r -d '' pkg_file; do
    local rel="${pkg_file#"$stow_dir/"}"
    local target="$HOME/$rel"
    if [ -f "$target" ] && [ ! -L "$target" ]; then
      local real_path
      real_path="$(realpath "$target" 2>/dev/null || true)"
      if [[ "$real_path" == "$DOTFILES"* ]]; then
        log "  [SKIP] $target (resuelve a dotfile vía symlink de dir)"
        continue
      fi
      log "  [RM-FILE] $target"
      $DRY_RUN || rm -f "$target"
    elif [ -L "$target" ]; then
      local real_link
      real_link="$(realpath "$target" 2>/dev/null || true)"
      if [[ "$real_link" != "$DOTFILES"* ]]; then
        log "  [RM-LINK] $target (apuntaba a: $(readlink "$target"))"
        $DRY_RUN || rm -f "$target"
      fi
    fi
  done < <(find "$stow_dir" -type f -print0)

  local -a stow_flags=(--dir="$DOTFILES" --target="$HOME" --verbose=2)
  $DRY_RUN && stow_flags+=(--simulate)

  if run stow "${stow_flags[@]}" --restow "$module"; then
    ok "$module"
  else
    fail "$module"
  fi
}

for module in "${MODULES[@]}"; do
  stow_module "$module"
done

# -------------------------------------------------------
# 5. WALLPAPERS (copia directa, no stow)
# -------------------------------------------------------
log ""
log "==> [5/5] Wallpapers..."

WALL_SRC="$DOTFILES/wallpapers"

copy_wallpapers() {
  local src="$1"
  local dest="$2"
  local label="$3"

  if [ ! -d "$src" ]; then
    fail "$label (no encontrado: $src)"
    return 1
  fi
  run mkdir -p "$dest"
  if run cp -r "$src/." "$dest/"; then
    ok "$label"
  else
    fail "$label (error al copiar)"
  fi
}

copy_wallpapers "$WALL_SRC/LOTR"                 "$HOME/wallpapers/LOTR"      "wallpapers/LOTR"
copy_wallpapers "$WALL_SRC/Pictures/wallpapers"  "$HOME/Pictures/wallpapers"  "Pictures/wallpapers"

for img in profle.jpg default-no-music.jpg; do
  if [ -f "$WALL_SRC/Pictures/$img" ]; then
    if run cp "$WALL_SRC/Pictures/$img" "$HOME/Pictures/$img"; then
      ok "Pictures/$img"
    else
      fail "Pictures/$img (error al copiar)"
    fi
  else
    fail "Pictures/$img (no encontrado en repo)"
  fi
done

run mkdir -p "$HOME/Pictures/Screenshots"
ok "Pictures/Screenshots/"

# -------------------------------------------------------
# RESUMEN FINAL
# -------------------------------------------------------
log ""
log "════════════════════════════════════════════════════"
log " RESUMEN  $(date '+%Y-%m-%d %H:%M:%S')"
log "════════════════════════════════════════════════════"

if [ ${#FAILED[@]} -eq 0 ]; then
  log " Todo OK. Sin errores."
else
  log " Fallos detectados (${#FAILED[@]}):"
  for f in "${FAILED[@]}"; do
    log "   ✗ $f"
  done
  log ""
  log " Para re-ejecutar un módulo:"
  log "   cd $DOTFILES && stow --restow --verbose=2 <modulo>"
  log ""
  log " Log completo: $LOG_FILE"
fi

$DRY_RUN && log "" && log " [DRY RUN] Nada fue modificado."

log ""
log " Pasos manuales pendientes:"
log "   1. Seleccionar máquina en ~/.config/hypr/hyprland.conf"
log "      → comentar/descomentar source conf.d/monitors_msi|legion y workspaces_msi|legion"
log "   2. Hacer lo mismo en ~/.config/waybar/config"
log "      → cambiar modules/workspaces_msi.json ↔ workspaces_legion.json en el include"
log "   3. sudo sensors-detect           (temperaturas CPU en waybar)"
log "   4. sudo systemctl enable --now NetworkManager"
log "   5. Reiniciar sesión o ejecutar: Hyprland"
log ""
