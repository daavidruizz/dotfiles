#!/bin/bash
# install.sh - Setup completo del entorno Hyprland (vía GNU Stow)
#
# PRERREQUISITO: haber ejecutado migrate-to-stow.sh antes.
#
# USO:
#   bash install.sh                        # instala todo
#   bash install.sh --only hypr waybar kitty  # solo esos módulos
#   bash install.sh --dry-run              # simula sin aplicar nada
#
# LOG: se guarda en ~/dotfiles/install.log

set -uo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$DOTFILES/install.log"
DRY_RUN=false
ONLY_MODULES=()

# -------------------------------------------------------
# Parse argumentos
# -------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
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

run() {
  log "  CMD: $*"
  if ! $DRY_RUN; then
    if "$@"; then return 0; else return 1; fi
  fi
  return 0
}

FAILED=()

# -------------------------------------------------------
# Header
# -------------------------------------------------------
log ""
log "════════════════════════════════════════════════════"
log " Hyprland Dotfiles - Instalador (stow)"
log " $(date '+%Y-%m-%d %H:%M:%S')"
$DRY_RUN && log " MODO: DRY RUN"
log "════════════════════════════════════════════════════"

# -------------------------------------------------------
# 0. GIT PULL
# -------------------------------------------------------
log ""
log "==> [0/5] Sincronizando dotfiles con git..."

if git -C "$DOTFILES" pull --ff-only 2>&1 | tee -a "$LOG_FILE"; then
  ok "git pull"
else
  log "  [!] git pull falló o hay cambios locales sin commitear. Continúa con la versión actual."
fi

# -------------------------------------------------------
# 1. PAQUETES PACMAN
# -------------------------------------------------------
log ""
log "==> [1/5] Paquetes pacman..."

PACMAN_PKGS=(
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

# -------------------------------------------------------
# 2. PAQUETES AUR
# -------------------------------------------------------
log ""
log "==> [2/5] Paquetes AUR..."

if ! command -v yay &>/dev/null; then
  info "yay no encontrado, instalando..."
  if run bash -c "sudo pacman -S --needed --noconfirm git base-devel && \
                  git clone https://aur.archlinux.org/yay.git /tmp/yay-install && \
                  cd /tmp/yay-install && makepkg -si --noconfirm"; then
    ok "yay instalado"
  else
    fail "yay bootstrap"
    exit 1
  fi
fi

AUR_PKGS=(
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

if run yay -S --needed --noconfirm "${AUR_PKGS[@]}"; then
  ok "AUR"
else
  fail "AUR"
  log "  [!] Algunos paquetes AUR fallaron. Continúa con el resto..."
fi

# -------------------------------------------------------
# 3. FUENTES BUNDLED
# -------------------------------------------------------
log ""
log "==> [3/5] Fuentes bundled..."

FONTS_SRC="$DOTFILES/hypr/.config/hypr/hyprlock/Fonts"
FONTS_DEST="$HOME/.local/share/fonts"

if [ -d "$FONTS_SRC" ]; then
  run mkdir -p "$FONTS_DEST"
  run cp -rv "$FONTS_SRC/SF Pro Display/"* "$FONTS_DEST/" 2>&1 | tee -a "$LOG_FILE"
  run cp -rv "$FONTS_SRC/JetBrains/"*      "$FONTS_DEST/" 2>&1 | tee -a "$LOG_FILE"
  run fc-cache -fv 2>&1 | tee -a "$LOG_FILE"
  ok "fuentes bundled"
else
  fail "fuentes bundled (ruta no encontrada: $FONTS_SRC)"
fi

# -------------------------------------------------------
# 4. SYMLINKS VÍA STOW
# -------------------------------------------------------
log ""
log "==> [4/5] Creando symlinks con stow..."

ALL_MODULES=(hypr waybar dunst rofi nwg-dock kitty wlogout thunar easyeffects fastfetch btop gtk nvim swayosd vim bash qt)

# Si se pasó --only, usar solo esos
if [ ${#ONLY_MODULES[@]} -gt 0 ]; then
  MODULES=("${ONLY_MODULES[@]}")
  info "Modo --only: ${MODULES[*]}"
else
  MODULES=("${ALL_MODULES[@]}")
fi

stow_module() {
  local module="$1"
  local stow_dir="$DOTFILES/$module"

  if [ ! -d "$stow_dir" ]; then
    skip "$module (directorio no encontrado: $stow_dir)"
    return
  fi

  # Verificar que tiene algún contenido stoweable (.config, .local, o dotfiles en ~)
  if [ ! -d "$stow_dir/.config" ] && [ ! -d "$stow_dir/.local" ] && \
     [ -z "$(find "$stow_dir" -maxdepth 1 -name '.*' -not -name '.' | head -1)" ]; then
    fail "$module (no tiene estructura stow válida)"
    return
  fi

  # Hacer backup de directorios reales que stow querría convertir en symlinks.
  # Si el directorio target ya existe como carpeta real (no symlink), stow
  # desciende en él en vez de crear el symlink limpio → resultado: configs mezcladas.
  local bak_ts
  bak_ts="$(date +%Y%m%d_%H%M%S)"
  for base in .config .local/share .local/bin; do
    local pkg_base="$stow_dir/$base"
    [ -d "$pkg_base" ] || continue
    for pkg_subdir in "$pkg_base"/*/; do
      [ -d "$pkg_subdir" ] || continue
      local rel_subdir="${pkg_subdir#$stow_dir/}"   # ej: .config/nvim/
      rel_subdir="${rel_subdir%/}"                   # quitar trailing slash
      local target_dir="$HOME/$rel_subdir"
      # Si es symlink roto → eliminarlo
      if [ -L "$target_dir" ] && [ ! -e "$target_dir" ]; then
        log "  [RM-BROKEN] $target_dir (symlink roto)"
        $DRY_RUN || rm "$target_dir"
      fi
      # Si existe como directorio real (no symlink) → moverlo a .bak
      if [ -d "$target_dir" ] && [ ! -L "$target_dir" ]; then
        log "  [BAK] $target_dir → ${target_dir}.bak.$bak_ts"
        $DRY_RUN || mv "$target_dir" "${target_dir}.bak.$bak_ts"
      fi
    done
  done

  # Eliminar archivos/symlinks sueltos que colisionan con lo que stow quiere crear.
  log "  Eliminando conflictos para $module..."
  while IFS= read -r -d '' pkg_file; do
    local rel="${pkg_file#$stow_dir/}"   # ej: .config/hypr/hyprland.conf
    local target="$HOME/$rel"
    # Archivo real → eliminar (pero NO si resuelve dentro del propio dotfiles,
    # lo que ocurre cuando el directorio padre ya es un symlink de stow)
    if [ -f "$target" ] && [ ! -L "$target" ]; then
      local real_path
      real_path="$(realpath "$target" 2>/dev/null)"
      if [[ "$real_path" == "$DOTFILES"* ]]; then
        log "  [SKIP] $target (resuelve a dotfile fuente vía symlink de dir)"
        continue
      fi
      log "  [RM-FILE] $target"
      $DRY_RUN || rm -f "$target"
    # Symlink no gestionado por stow (apunta a ruta relativa o ajena) → eliminar
    elif [ -L "$target" ]; then
      local link_dest
      link_dest="$(readlink "$target")"
      if [[ "$link_dest" != *dotfiles* ]]; then
        log "  [RM-LINK] $target (apuntaba a: $link_dest)"
        $DRY_RUN || rm -f "$target"
      fi
    fi
  done < <(find "$stow_dir" -type f -print0)

  local stow_flags="--dir=$DOTFILES --target=$HOME --verbose=2"
  $DRY_RUN && stow_flags="$stow_flags --simulate"

  log "  Ejecutando: stow $stow_flags --restow $module"
  if stow $stow_flags --restow "$module" 2>&1 | tee -a "$LOG_FILE"; then
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

  if [ -d "$src" ]; then
    run mkdir -p "$dest"
    run cp -rv "$src/"* "$dest/" 2>&1 | tee -a "$LOG_FILE"
    ok "$label"
  else
    fail "$label (no encontrado: $src)"
  fi
}

copy_wallpapers "$WALL_SRC/LOTR"              "$HOME/wallpapers/LOTR"              "wallpapers/LOTR"
copy_wallpapers "$WALL_SRC/Pictures/wallpapers" "$HOME/Pictures/wallpapers"        "Pictures/wallpapers"

for img in profle.jpg default-no-music.jpg; do
  if [ -f "$WALL_SRC/Pictures/$img" ]; then
    run cp -v "$WALL_SRC/Pictures/$img" "$HOME/Pictures/$img" 2>&1 | tee -a "$LOG_FILE"
    ok "Pictures/$img"
  else
    fail "Pictures/$img no encontrado"
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
log "   1. Editar ~/.config/hypr/hyprland.conf → sección MONITORS"
log "   2. sudo sensors-detect           (temperaturas CPU en waybar)"
log "   3. sudo systemctl enable --now NetworkManager"
log "   4. Reiniciar sesión o ejecutar: Hyprland"
log ""
