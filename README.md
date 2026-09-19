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
| Wallpaper | [swww](https://github.com/LGFae/swww) |
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
