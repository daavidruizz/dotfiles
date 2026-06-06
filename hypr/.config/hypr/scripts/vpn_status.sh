#!/usr/bin/env bash
# vpn_status.sh — Emite JSON para waybar custom/vpn
# Detecta si hay alguna interfaz WireGuard activa

WG_IFACE=$(ip link show type wireguard 2>/dev/null | awk -F': ' '/^[0-9]+:/{print $2; exit}')

if [[ -n "$WG_IFACE" ]]; then
  echo '{"text": "VPN", "class": "connected", "tooltip": "WireGuard activo: '"$WG_IFACE"'"}'
else
  echo '{"text": "", "class": "disconnected", "tooltip": ""}'
fi
