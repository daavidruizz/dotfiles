#!/usr/bin/env bash
#
# installupdates.sh — System update manager
# Launched via: kitty --class type1-floating -e installupdates.sh
#

set -euo pipefail

# ─── Helpers ──────────────────────────────────────────────────────────────────

_has() { command -v "$1" &>/dev/null; }

_header() {
  clear
  echo -e "\033[1;36m╔══════════════════════════════════════════╗\033[0m"
  echo -e "\033[1;36m║          SYSTEM UPDATE MANAGER           ║\033[0m"
  echo -e "\033[1;36m╚══════════════════════════════════════════╝\033[0m"
  echo
}

_section() {
  echo -e "\033[1;35m┌─ $1 $(printf '─%.0s' $(seq 1 $((40 - ${#1}))))┐\033[0m"
}

_section_end() {
  echo -e "\033[1;35m└$(printf '─%.0s' $(seq 1 44))┘\033[0m"
}

_info()    { echo -e "\033[1;34m  $*\033[0m"; }
_success() { echo -e "\033[1;32m  $*\033[0m"; }
_warn()    { echo -e "\033[1;33m  $*\033[0m"; }
_error()   { echo -e "\033[1;31m  $*\033[0m"; }
_dim()     { echo -e "\033[0;37m  $*\033[0m"; }

_divider() {
  echo -e "\033[1;36m──────────────────────────────────────────────\033[0m"
}

# ─── Menu ─────────────────────────────────────────────────────────────────────

MENU_CHOICE=""

show_menu() {
  echo -e "\033[1;33m  Select update mode:\033[0m"
  echo
  echo -e "\033[1;37m  [1]\033[0m  AUR only"
  echo -e "\033[1;37m  [2]\033[0m  pacman + AUR"
  echo -e "\033[1;37m  [3]\033[0m  Exit"
  echo
  echo -e "\033[0;37m  Choice: \033[0m\c"
  read -r MENU_CHOICE
  echo
}

# ─── Check available updates ──────────────────────────────────────────────────

check_updates() {
  local mode="$1"  # "aur" | "full"

  _info "Checking for available updates..."
  echo

  local total=0

  if [[ "$mode" == "full" ]]; then
    _section "OFFICIAL REPOSITORIES"
    echo

    local official=""
    if _has checkupdates; then
      official=$(checkupdates 2>/dev/null || true)
    else
      official=$(pacman -Qu 2>/dev/null || true)
    fi

    if [[ -n "$official" ]]; then
      local count; count=$(echo "$official" | wc -l)
      echo "$official" | head -15
      [[ $count -gt 15 ]] && _dim "... and $((count - 15)) more"
      total=$((total + count))
    else
      _success "No official updates available"
    fi

    echo
    _section_end
    echo
  fi

  _section "AUR"
  echo

  local aur=""
  if _has yay; then
    aur=$(yay -Qum 2>/dev/null || true)
  elif _has paru; then
    aur=$(paru -Qum 2>/dev/null || true)
  else
    _warn "No AUR helper found (yay/paru)"
  fi

  if [[ -n "$aur" ]]; then
    local aur_count; aur_count=$(echo "$aur" | wc -l)
    echo "$aur" | head -15
    [[ $aur_count -gt 15 ]] && _dim "... and $((aur_count - 15)) more"
    total=$((total + aur_count))
  else
    _success "No AUR updates available"
  fi

  echo
  _section_end

  # Flatpak (only on full update)
  if [[ "$mode" == "full" ]] && _has flatpak; then
    echo
    _section "FLATPAK"
    echo
    local fp_updates; fp_updates=$(flatpak remote-ls --updates 2>/dev/null || true)
    if [[ -n "$fp_updates" ]]; then
      echo "$fp_updates" | head -10
      local fp_count; fp_count=$(echo "$fp_updates" | wc -l)
      total=$((total + fp_count))
    else
      _success "No Flatpak updates available"
    fi
    echo
    _section_end
  fi

  echo
  _divider
  if [[ $total -gt 0 ]]; then
    _warn "Total: $total update(s) available"
  else
    _success "System is up to date"
  fi
  _divider
  echo
}

# ─── Confirm prompt ───────────────────────────────────────────────────────────

confirm_update() {
  echo -e "\033[1;33m  Proceed? [y/N] \033[0m\c"
  read -r response
  case "$response" in
    [yY] | [yY][eE][sS]) return 0 ;;
    *) return 1 ;;
  esac
}

# ─── Run update ───────────────────────────────────────────────────────────────

run_update_aur() {
  _info "Upgrading AUR packages..."
  echo
  if _has yay; then
    yay -Syu --noconfirm
  elif _has paru; then
    paru -Syu --noconfirm
  else
    _error "No AUR helper found. Aborting."
    exit 1
  fi
}

run_update_full() {
  _info "Upgrading official packages..."
  echo
  sudo pacman -Syu

  echo
  _info "Upgrading AUR packages..."
  echo
  if _has yay; then
    yay -Syu --noconfirm
  elif _has paru; then
    paru -Syu --noconfirm
  else
    _warn "No AUR helper found — skipping AUR step"
  fi

  if _has flatpak; then
    echo
    _info "Upgrading Flatpak applications..."
    echo
    flatpak update -y
  fi
}

# ─── Cleanup ──────────────────────────────────────────────────────────────────

run_cleanup() {
  echo
  _info "Removing orphaned packages..."
  local orphans; orphans=$(pacman -Qdtq 2>/dev/null || true)
  if [[ -n "$orphans" ]]; then
    echo "$orphans" | sudo pacman -Rns - 2>/dev/null || true
  else
    _success "No orphans to remove"
  fi
}

# ─── Main ─────────────────────────────────────────────────────────────────────

main() {
  _header

  show_menu

  case "$MENU_CHOICE" in
    1)
      check_updates "aur"
      if confirm_update; then
        echo
        _divider
        _info "Starting AUR update..."
        _divider
        echo
        run_update_aur
        run_cleanup
        echo
        _divider
        _success "Update complete."
        _divider
        pkill -RTMIN+1 waybar 2>/dev/null || true
      else
        echo
        _warn "Update cancelled."
      fi
      ;;
    2)
      check_updates "full"
      if confirm_update; then
        echo
        _divider
        _info "Starting full system update..."
        _divider
        echo
        run_update_full
        run_cleanup
        echo
        _divider
        _success "Update complete."
        _divider
        pkill -RTMIN+1 waybar 2>/dev/null || true
      else
        echo
        _warn "Update cancelled."
      fi
      ;;
    3 | "")
      _dim "Exiting."
      exit 0
      ;;
    *)
      _error "Invalid option."
      ;;
  esac

  echo
  echo -e "\033[0;37m  Press ENTER to close...\033[0m"
  read -r
}

trap 'echo; _error "Interrupted."; exit 1' INT TERM

main "$@"
