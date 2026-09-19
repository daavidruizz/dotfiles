<div align="center">

# dotfiles

**Hyprland · Arch Linux · GNU Stow**

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=flat&logo=arch-linux&logoColor=white)](https://archlinux.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-blue?style=flat)](https://hyprland.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat)](LICENSE)

Setup personal de escritorio Wayland en Arch Linux. Gestionado con [GNU Stow](https://www.gnu.org/software/stow/) — cada módulo es un paquete independiente y los archivos en `~/.config/` son symlinks al repo.

Soporta dos máquinas desde el mismo repo con detección automática por hostname.

</div>

---

## Stack

| Componente | Herramienta |
|---|---|
| Compositor | [Hyprland](https://hyprland.org) (config en Lua) |
| Barra | [Waybar](https://github.com/Alexays/Waybar) |
| Terminal | [Kitty](https://sw.kovidgoyal.net/kitty/) |
| Launcher | [Rofi](https://github.com/davatorium/rofi) |
| Notificaciones | [SwayNC](https://github.com/ErikReider/SwayNotificationCenter) (con blur, `SUPER+N` abre el panel) |
| Plugin Hyprland | [hyprglass](https://github.com/hyprnux/hyprglass) vía hyprpm (Liquid Glass, solo archMSI) |
| Lockscreen | [Hyprlock](https://github.com/hyprwm/hyprlock) |
| Idle daemon | [Hypridle](https://github.com/hyprwm/hypridle) |
| Wallpaper | [awww](https://codeberg.org/LGFae/awww) (el antiguo swww) + [mpvpaper](https://github.com/GhostNaN/mpvpaper) para vídeo |
| Dock | [nwg-dock-hyprland](https://github.com/nwg-piotr/nwg-dock-hyprland) |
| Audio | PipeWire + [EasyEffects](https://github.com/wwmm/easyeffects) |
| OSD volumen/brillo | [SwayOSD](https://github.com/ErikReider/SwayOSD) |
| Clipboard | [cliphist](https://github.com/sentriz/cliphist) + wl-paste |
| Menú apagado | [wlogout](https://github.com/ArtsyMacaw/wlogout) |
| File manager | Thunar |
| Editor | Neovim (LazyVim) |
| Tema GTK | Adwaita / adw-gtk3 |
| Iconos | WhiteSur-dark |
| Cursor | Bibata Modern Ice |
| Qt | qt5ct · qt6ct · Kvantum |

---

## Instalación

```bash
git clone git@github.com:daavidruizz/dotfiles.git ~/dotfiles
bash ~/dotfiles/install.sh
```

El script instala paquetes (pacman + AUR), copia fuentes, crea los symlinks con stow y copia los wallpapers.

En **archMSI** además instala `hyprpm` y compila el plugin [hyprglass](https://github.com/hyprnux/hyprglass) (`hyprpm update` + `add` + `enable`). `hyprpm` necesita una sesión de Hyprland en marcha: si ejecutas `install.sh` desde un TTY lo omite y te indica el comando a lanzar después.

### Opciones

```bash
bash install.sh --only hypr waybar   # solo módulos concretos
bash install.sh --stow-only          # solo stow, sin instalar paquetes
bash install.sh --dry-run            # simula sin tocar nada
cat install.log                      # ver el log completo
```

### Pasos post-instalación

```bash
sudo sensors-detect                         # temperaturas en waybar
sudo systemctl enable --now NetworkManager
```

---

## Estructura

```
dotfiles/
├── hypr/               → ~/.config/hypr/
│   └── .config/hypr/
│       ├── hyprland.lua            ← entry point (detección de máquina)
│       ├── hyprlock.conf
│       ├── hypridle.conf / hypridle_legion.conf
│       ├── conf/                   ← módulos Lua
│       │   ├── appearance.lua
│       │   ├── autostart.lua
│       │   ├── env.lua
│       │   ├── input.lua
│       │   ├── keybinds.lua
│       │   ├── rules.lua
│       │   ├── monitors_msi.lua / monitors_legion.lua
│       │   └── workspaces_msi.lua / workspaces_legion.lua
│       └── scripts/                ← power, wallpaper, screenshot, música...
│
├── waybar/             → ~/.config/waybar/
│   └── .config/waybar/
│       ├── config                  ← layout + includes de módulos
│       ├── style.css
│       └── modules/                ← un JSON por módulo funcional
│           ├── audio.json          ← pulseaudio + bluetooth
│           ├── system.json         ← CPU · RAM · disco · temperaturas
│           ├── updates.json
│           ├── clipboard.json
│           ├── workspaces_msi.json    ← persistent-workspaces DP-1/DP-2
│           └── workspaces_legion.json ← persistent-workspaces eDP-1
│
├── kitty/              → ~/.config/kitty/
├── rofi/               → ~/.config/rofi/
├── nvim/               → ~/.config/nvim/      (LazyVim)
├── swaync/             → ~/.config/swaync/
├── gtk/                → ~/.config/gtk-{2,3,4}.0/
├── qt/                 → ~/.config/qt5ct|qt6ct|kvantum/
├── environment.d/      → ~/.config/environment.d/
├── bash/               → ~/.bashrc
├── wallpapers/         → ~/wallpapers/        (copiado, no symlinkeado)
└── install.sh
```

---

### Notificaciones (swaync)

Sistema de notificaciones con sonido, todo en el módulo `swaync/`:

| Evento | Notificación | Sonido (tema freedesktop) |
|---|---|---|
| Notificación normal | sí | `message` |
| Crítica | sí (no caduca) | `dialog-warning` |
| Bluetooth conectado / desconectado | sí | `device-added` / `device-removed` |
| Cargador conectado / desconectado (portátil) | sí | `power-plug` / `power-unplug` |
| Batería baja (≤20 %) / crítica (≤10 %) / completa | sí | `dialog-warning` / `dialog-error` / `complete` |
| Batería baja del ratón/teclado (Logitech) | sí | igual que batería |
| Subir/bajar volumen o brillo | **no** (solo el OSD de SwayOSD) | `audio-volume-change` |

- `SUPER+N` abre el panel, `SUPER+SHIFT+N` activa "No molestar" (silencia también los sonidos; los de volumen/brillo suenan siempre).
- Arriba del panel hay una barra de **volumen** y, en archLEGION, otra de **brillo**.
- Los avisos de Bluetooth y batería los generan `bluetooth-notify.sh` y `battery-notify.sh` (lanzados en `autostart.lua`); swaync elige el sonido por la *categoría* de la notificación (`device.added`, `power.low`…, ver `"scripts"` en la config). Cambiar un sonido = editar esa línea; para uno propio, dejar `~/.local/share/sounds/<nombre>.oga`.
- **Config por máquina:** `config_msi.json` (solo volumen) y `config_legion.json` (volumen + brillo). `~/.config/swaync/config.json` es un **enlace** a la variante de la máquina que crea `install.sh`; no se versiona (`.gitignore`). Sin `install.sh`: `ln -sfn config_msi.json ~/dotfiles/swaync/.config/swaync/config.json` (o `config_legion.json`).
- Recargar: `swaync-client -R -rs` (config + CSS). Depurar sonidos: `touch ~/.cache/play-sound.debug` y mirar `~/.cache/play-sound.log`.

---

## Multi-máquina (archMSI ↔ archLEGION)

La detección es automática: `hyprland.lua` lee `/proc/sys/kernel/hostname` y carga la config correspondiente sin intervención manual.

| | archMSI | archLEGION |
|---|---|---|
| Pantallas | 2× DP 2560×1440 @180Hz | eDP-1 integrado |
| GPU | AMD Radeon | Integrada |
| Idle | `hypridle.conf` | `hypridle_legion.conf` |
| Brillo | — | `brightnessctl` |
| Batería | No | `battery.json` en waybar |
| Plugin hyprglass | Sí (`hyprpm reload -n` en el autostart) | No |
| swaync (config) | `config_msi.json`: barra de volumen | `config_legion.json`: volumen + brillo |
| Avisos de batería | Solo ratón/teclado Logitech | Portátil (cargador, baja, crítica, completa) + periféricos |

El único ajuste manual al cambiar de máquina es el último `include` en `waybar/config` para seleccionar `workspaces_msi.json` o `workspaces_legion.json`.

---

## Día a día

Los archivos en `~/.config/` son symlinks, por lo que editarlos directamente es editar el dotfile. No hace falta nada especial para ver los cambios en la mayoría de apps.

**Añadir un archivo a un módulo existente:**

```bash
cp script.sh ~/dotfiles/hypr/.config/hypr/scripts/
cd ~/dotfiles && stow hypr
```

**Añadir un módulo nuevo:**

```bash
mkdir -p ~/dotfiles/foo/.config/foo
cp -r ~/.config/foo/* ~/dotfiles/foo/.config/foo/
cd ~/dotfiles && stow foo
# añadirlo a ALL_MODULES en install.sh
```

**Sincronizar entre máquinas:**

```bash
# en la máquina con cambios
git add -A && git commit -m "descripción" && git push

# en la otra
git pull && bash install.sh --stow-only
```

---

## Dependencias

Ver [PACKAGES.md](PACKAGES.md) para la lista completa por módulo con los comandos de instalación exactos.
