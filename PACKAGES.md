# Dependencias completas del setup Hyprland

## Dependencias por módulo

### hypr
| Binario/Tool | Usado en | Paquete |
|---|---|---|
| `hyprland` | core WM | `hyprland` |
| `hypridle` | idle daemon | `hypridle` |
| `hyprlock` | lockscreen | `hyprlock` |
| `hyprpaper` | wallpaper daemon (alternativa, desactivado en el autostart) | `hyprpaper` |
| `awww` / `awww-daemon` | wallpaper de imagen (autostart + `wallpaper.sh`); es el antiguo `swww`, renombrado | `awww` |
| `mpvpaper` | wallpaper de vídeo (`wallpaper.sh video`) | `mpvpaper` (AUR) |
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
| `swaync` | notificaciones autostart (`SUPER+N` panel) | `swaync` |
| `hyprpm` | gestor de plugins (solo archMSI, para hyprglass) | `hyprpm` |
| `waybar` | barra autostart | `waybar` |
| hyprpicker | color picker | hyprlpicker |

**Archivos referenciados:**
- `~/wallpapers/random/` → `wallpaper.sh random` (copiado por `install.sh` desde dotfiles/wallpapers/default). `wallpaper.sh video` usa `~/wallpapers/videos/`
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
| `google-chrome` | custom/mail, clock (calendar) | `google-chrome` (AUR) |
| `checkupdates` | updates.sh | `pacman-contrib` |
| `yay` | updates.sh (AUR updates) | `yay` (AUR) |
| `flatpak` | updates.sh (opcional) | `flatpak` (opcional) |
| `wpctl` | volumen (keybinds hyprland) | `wireplumber` |

**Fuentes requeridas:**
- `SF Pro Display` → bundled en dotfiles
- `Font Awesome 6 Free` + `Font Awesome 6 Brands` → `ttf-font-awesome`

---

### rofi
**Fuentes requeridas:**
- `Montserrat 9` → `ttf-montserrat` (AUR) — launchpad.rasi
- `Roboto 12` → `ttf-roboto` — rounded-template.rasi (tema Nord anterior, ya no activo)
- `JetBrainsMono Nerd Font Mono 12` → `ttf-jetbrains-mono-nerd` — glass.rasi (tema activo)

**Tema activo:** `template/glass.rasi` (seleccionado en `config.rasi`). Rofi 2.0 corre como capa de Wayland (namespace `rofi`): el blur lo aplica Hyprland con la `layer_rule` de `appearance.lua` (`ignore_alpha = 0.3` para que siga el redondeo).

---

### swaync
**Fuentes requeridas:**
- `JetBrainsMono Nerd Font Mono` → `ttf-jetbrains-mono-nerd` (fallback: `SF Pro Display`, bundled)

**Iconos:** los del tema GTK del sistema (Adwaita / Papirus → `papirus-icon-theme`)

**Blur:** lo aplica Hyprland con layer rules en `appearance.lua` (`swaync-control-center`, `swaync-notification-window`, con `ignore_alpha`)

**Sustituye a dunst:** `power.sh` y el resto de scripts usan `notify-send` (`libnotify`), no `dunstify`.

**Sonidos y avisos (scripts en `swaync/.config/swaync/scripts/`):**
- `sound-theme-freedesktop` → los `.oga` (`message`, `device-added`, `power-plug`, `dialog-warning`…). Se instala explícitamente para que pacman no lo trate como huérfano.
- `pipewire` → `pw-play` (reproduce los sonidos)
- `bluez` → avisos de Bluetooth (`gdbus monitor` de `glib2` + `busctl` de `systemd`)
- `brightnessctl` → barra de brillo (solo `config_legion.json`; usa `-c backlight`)
- `util-linux` → `flock` (evita apilar sonidos con teclas en repetición)

**Config por máquina:** `config_msi.json` / `config_legion.json`; `install.sh` enlaza `config.json` a la de la máquina (no versionado).

---

### hyprglass (plugin de Hyprland, solo archMSI)
Instalado por `install.sh` en archMSI. Manual (necesita una sesión de Hyprland abierta):
```bash
sudo pacman -S hyprpm
hyprpm update
hyprpm add https://github.com/hyprnux/hyprglass
hyprpm enable hyprglass      # pide sudo
```
- Se carga en cada arranque con `hyprpm reload -n` (`conf/autostart.lua`, solo si `MACHINE == MSI`).
- Config en `hypr/.config/hypr/conf/plugins.lua` (inerte si el plugin no está cargado).
- Tras actualizar Hyprland: `hyprpm update` (se compila contra la versión exacta).

---

### kitty
**Fuente:** ninguna especificada en config (usa la del sistema por defecto)

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

### thunderbird
### papers
### okular
### yazi
---

## Pacman (instalación de golpe)

```bash
sudo pacman -S --needed \
  hyprland hypridle hyprlock hyprpaper awww \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  waybar swaync sound-theme-freedesktop \
  rofi wofi \
  kitty thunar \
  easyeffects wireplumber pipewire pipewire-pulse pavucontrol playerctl \
  fastfetch btop brightnessctl networkmanager network-manager-applet \
  grim slurp \
  firefox qalculate-gtk \
  chromium \
  nwg-look papirus-icon-theme adwaita-icon-theme \
  noto-fonts noto-fonts-emoji \
  ttf-font-awesome ttf-fira-sans ttf-roboto ttf-jetbrains-mono-nerd \
  lm_sensors \
  jq curl libnotify \
  pacman-contrib \
  qt5ct qt6ct kvantum \
  stow \
  thunderbird \
  papers \
  okular \
  yazi
```

## AUR (via yay)

```bash
yay -S --needed \
  grimblast-git \
  mpvpaper \
  adw-gtk3 \
  whitesur-icon-theme \
  bibata-cursor-theme \
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
hypr     →  depende de  →  swaync/scripts/ (play-sound.sh en las teclas de volumen/brillo; bluetooth/battery-notify.sh en el autostart)
```
