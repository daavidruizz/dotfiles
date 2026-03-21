# Dependencias completas del setup Hyprland

## Dependencias por módulo

### hypr
| Binario/Tool | Usado en | Paquete |
|---|---|---|
| `hyprland` | core WM | `hyprland` |
| `hypridle` | idle daemon | `hypridle` |
| `hyprlock` | lockscreen | `hyprlock` |
| `hyprpaper` | wallpaper daemon | `hyprpaper` |
| `hyprctl` | control IPC | incluido en `hyprland` |
| `brightnessctl` | hypridle (brillo en suspend) | `brightnessctl` |
| `loginctl` | hypridle (lock-session) | `systemd` (ya presente) |
| `systemctl` | hypridle (suspend) | `systemd` (ya presente) |
| `playerctl` | songdetail.sh, songcover.sh | `playerctl` |
| `curl` | songcover.sh (descarga carátula) | `curl` |
| `jq` | power.sh (lista clientes hyprland) | `jq` |
| `grimblast` | screenshots | `grimblast-git` (AUR) |
| `rofi` | launcher (SUPER+SPACE) | `rofi` |
| `google-chrome` | keybind SUPER+B, SUPER+W | `google-chrome` (AUR) |
| `firefox` | sidepad | `firefox` |
| `qalculate-gtk` | keybind XF86Calculator | `qalculate-gtk` |
| `hyprctl setcursor` | cursor Bibata-Modern-Ice | `bibata-cursor-theme` (AUR) |
| `notify-send` | toggle_tv.sh | `libnotify` |
| `dbus-update-activation-environment` | autostart | `dbus` (ya presente) |
| `easyeffects` | autostart | `easyeffects` |
| `nwg-dock-hyprland` | dock autostart | `nwg-dock-hyprland` (AUR) |
| `dunst` | notificaciones autostart | `dunst` |
| `waybar` | barra autostart | `waybar` |

**Archivos referenciados:**
- `~/wallpapers/LOTR/` → `random-wall.sh` (incluido en dotfiles/wallpapers/)
- `~/Pictures/profle.jpg` → `hyprlock.conf` (incluido en dotfiles/wallpapers/)
- `~/Pictures/wallpapers/puente_nubes.jpg` → `hyprlock.conf` (incluido en dotfiles/wallpapers/)
- `~/Pictures/default-no-music.jpg` → `songcover.sh` (incluido en dotfiles/wallpapers/)
- `~/Pictures/Screenshots/` → grimblast (se crea en install.sh)
- `/tmp/hyprlock-cover.jpg` → generado en runtime por songcover.sh

**Fuentes requeridas (hyprlock):**
- `SF Pro Display Bold` → bundled en `hypr/.config/hypr/hyprlock/Fonts/`
- `JetBrains Mono Nerd` → bundled en `hypr/.config/hypr/hyprlock/Fonts/`

---

### waybar
| Binario/Tool | Usado en | Paquete |
|---|---|---|
| `sensors` | cpu_temp.sh (chip k10temp) | `lm_sensors` + `sudo sensors-detect` |
| `nvidia-smi` | gpu_temp.sh | `nvidia-utils` |
| `kitty` | system-monitor.sh, networkmanager.sh, lanzador | `kitty` |
| `nmtui` | networkmanager.sh | `networkmanager` |
| `nm-applet` | nm-applet.sh | `network-manager-applet` |
| `pavucontrol` | click en módulo pulseaudio | `pavucontrol` |
| `bluetuith` | click en módulo bluetooth | `bluetuith` (AUR) |
| `wlogout` | custom/power | `wlogout` |
| `google-chrome` | custom/mail, clock (calendar) | `google-chrome` (AUR) |
| `checkupdates` | updates.sh | `pacman-contrib` |
| `yay` | updates.sh (AUR updates) | `yay` (AUR) |
| `flatpak` | updates.sh (opcional) | `flatpak` (opcional) |
| `wpctl` | volumen (keybinds hyprland) | `wireplumber` |

**Fuentes requeridas:**
- `SF Pro Display` → bundled en dotfiles
- `Font Awesome 6 Free` + `Font Awesome 6 Brands` → `ttf-font-awesome`

---

### wlogout
| Binario/Tool | Usado en | Paquete |
|---|---|---|
| `~/.config/hypr/scripts/power.sh` | todas las acciones | módulo `hypr` (dependencia) |
| `hyprlock` | power.sh lock | `hyprlock` |
| `systemctl` | power.sh reboot/shutdown/suspend | `systemd` |
| `hyprctl` | power.sh exit | `hyprland` |
| `jq` | power.sh terminate_clients | `jq` |

**Fuente requerida:** `Fira Sans Semibold` → `ttf-fira-sans`

---

### rofi
**Fuentes requeridas:**
- `Montserrat 9` → `ttf-montserrat` (AUR) — launchpad.rasi
- `Roboto 12` → `ttf-roboto` — rounded-template.rasi

---

### dunst
**Iconos requeridos:**
- Papirus icons en `/usr/share/icons/Papirus/` → `papirus-icon-theme`

---

### kitty
**Fuente:** ninguna especificada en config (usa la del sistema por defecto)

---

### nwg-dock
**Fuente requerida:** `JetbrainsMono Nerd Font` → bundled + `ttf-jetbrains-mono-nerd`

---

### easyeffects
**Dependencias de audio:**
- `pipewire` + `pipewire-pulse` + `wireplumber` — stack de audio Wayland

---

### gtk
**Paquetes de tema requeridos:**
- `adw-gtk3` (AUR) → tema GTK `adw-gtk3-dark`
- `whitesur-icon-theme` (AUR) → iconos `WhiteSur-dark`
- `whitesur-cursor-theme` (AUR) → cursor `WhiteSur-cursors`
- `noto-fonts` → fuente GTK sistema
- `nwg-look` → aplicar tema en Wayland

---

### qt
**Paquetes de tema requeridos:**
- `qt5ct` → configurador de tema para apps QT5
- `qt6ct` → configurador de tema para apps QT6
- `kvantum` → motor de temas QT (incluye KvGnomeDark)

**Variables de entorno (hyprland.conf):**
- `QT_QPA_PLATFORM=wayland` → apps QT nativas en Wayland
- `QT_QPA_PLATFORMTHEME=qt5ct` → aplica config de qt5ct a apps QT5
- `QT6_QPA_PLATFORMTHEME=qt6ct` → aplica config de qt6ct a apps QT6

**Tema configurado:** KvGnomeDark (kvantum) + iconos WhiteSur-dark + fuente Noto Sans

---

## Pacman (instalación de golpe)

```bash
sudo pacman -S --needed \
  hyprland hypridle hyprlock hyprpaper \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  waybar dunst \
  rofi wofi \
  kitty thunar \
  wlogout \
  easyeffects wireplumber pipewire pipewire-pulse pavucontrol playerctl \
  fastfetch btop brightnessctl networkmanager network-manager-applet \
  grim slurp \
  firefox qalculate-gtk \
  nwg-look papirus-icon-theme adwaita-icon-theme \
  noto-fonts noto-fonts-emoji \
  ttf-font-awesome ttf-fira-sans ttf-roboto ttf-jetbrains-mono-nerd \
  nvidia nvidia-utils \
  lm_sensors \
  jq curl libnotify \
  pacman-contrib \
  qt5ct qt6ct kvantum \
  stow
```

## AUR (via yay)

```bash
yay -S --needed \
  nwg-dock-hyprland \
  grimblast-git \
  google-chrome \
  adw-gtk3 \
  whitesur-icon-theme \
  bibata-cursor-theme \
  whitesur-cursor-theme \
  ttf-montserrat \
  ttf-sf-pro \
  bluetuith
```

## Post-instalación manual

```bash
# Detectar sensores de temperatura CPU (waybar cpu_temp.sh)
sudo sensors-detect

# Activar servicios de red
sudo systemctl enable --now NetworkManager
```

## Fuentes bundled en dotfiles

Copiadas automáticamente a `~/.local/share/fonts/` por `install.sh`:
- **SF Pro Display** Bold + Regular → `hypr/.config/hypr/hyprlock/Fonts/SF Pro Display/`
- **JetBrains Mono Nerd** → `hypr/.config/hypr/hyprlock/Fonts/JetBrains/`

## Dependencias entre módulos

```
wlogout  →  depende de  →  hypr  (llama a power.sh)
waybar   →  depende de  →  kitty (abre terminales flotantes)
hyprlock →  depende de  →  hypr/scripts/ (songcover.sh, songdetail.sh)
```
