# dotfiles

Setup personal de Hyprland en Arch Linux. Gestionado con [GNU Stow](https://www.gnu.org/software/stow/) — cada módulo es un paquete independiente, los archivos en `~/.config/` son symlinks que apuntan aquí.

---

## Stack

| Componente | Herramienta |
|---|---|
| Compositor | Hyprland |
| Barra | Waybar |
| Terminal | Kitty |
| Launcher | Rofi |
| Notificaciones | Dunst |
| Lockscreen | Hyprlock |
| Idle daemon | Hypridle |
| Wallpaper | Hyprpaper / mpvpaper |
| Dock | nwg-dock-hyprland |
| Audio | EasyEffects + Pipewire |
| OSD volumen/brillo | SwayOSD |
| Menú apagado | wlogout |
| File manager | Thunar |
| Tema GTK | adw-gtk3-dark + WhiteSur icons |
| Cursor | Bibata Modern Ice |

---

## Instalación

```bash
git clone git@github.com:daavidruizz/dotfiles.git ~/dotfiles
bash ~/dotfiles/install.sh
```

Hace todo: instala paquetes (pacman + AUR), copia fuentes, crea los symlinks con stow y copia los wallpapers.

### Opciones

```bash
bash install.sh --only hypr waybar   # solo módulos concretos
bash install.sh --dry-run            # simula sin tocar nada
cat install.log                      # ver el log completo
```

### Después de instalar

```bash
sudo sensors-detect                        # para las temperaturas en waybar
sudo systemctl enable --now NetworkManager
```

---

## Estructura

```
dotfiles_modules/
├── hypr/.config/hypr/
│   ├── hyprland.conf              ← entry point (solo source-directives)
│   ├── conf.d/
│   │   ├── appearance.conf        ← general, decoration, animations, misc
│   │   ├── autostart.conf         ← exec-once comunes
│   │   ├── env.conf               ← variables de entorno + $terminal/$menu
│   │   ├── input.conf             ← teclado, ratón, touchpad
│   │   ├── keybinds.conf          ← todos los keybindings
│   │   ├── rules.conf             ← todas las window rules
│   │   ├── monitors_msi.conf      ← monitores MSI (2x DP 1440p@180Hz)
│   │   ├── monitors_legion.conf   ← monitores Legion (eDP-1)
│   │   ├── workspaces_msi.conf    ← workspaces + autostart MSI
│   │   └── workspaces_legion.conf ← workspaces Legion
│   ├── hypridle_msi.conf          ← idle daemon — desktop (sin brightnessctl)
│   ├── hypridle_legion.conf       ← idle daemon — portátil (brightnessctl)
│   ├── hyprlock.conf
│   ├── hyprpaper.conf
│   └── scripts/
│
├── waybar/.config/waybar/
│   ├── config                     ← layout (modules-left/center/right) + includes
│   ├── style.css
│   └── modules/
│       ├── audio.json             ← pulseaudio + bluetooth
│       ├── clock.json
│       ├── network.json
│       ├── power.json             ← grupo power
│       ├── system.json            ← hardware group (cpu/mem/disk/temps)
│       ├── updates.json
│       ├── workspaces.json        ← archicon, mail, tray, window title (genérico)
│       ├── workspaces_msi.json    ← persistent-workspaces DP-1/DP-2
│       └── workspaces_legion.json ← persistent-workspaces eDP-1
│
├── bash/.bashrc                   ← sección "MSI ONLY" marcada al final
├── kitty/  dunst/  rofi/  nvim/   ← configs independientes, sin cambios
└── install.sh
```

---

## Multi-máquina (MSI ↔ Legion)

Las configs machine-specific están en el repo con sufijo `_msi` / `_legion`. Para cambiar de máquina, editar dos archivos:

**1. `~/.config/hypr/hyprland.conf`** — comentar/descomentar:

```conf
# MSI
source = ~/.config/hypr/conf.d/monitors_msi.conf
source = ~/.config/hypr/conf.d/workspaces_msi.conf

# Legion (descomentar estas, comentar las de arriba)
#source = ~/.config/hypr/conf.d/monitors_legion.conf
#source = ~/.config/hypr/conf.d/workspaces_legion.conf
```

**2. `~/.config/waybar/config`** — cambiar la última línea del `include`:

```json
"~/.config/waybar/modules/workspaces_msi.json"
// ó
"~/.config/waybar/modules/workspaces_legion.json"
```

El `hypridle` se lanza desde el `workspaces_*.conf` de la máquina, apuntando a `hypridle_msi.conf` o `hypridle_legion.conf` automáticamente.

---

## Día a día

Los archivos en `~/.config/` son symlinks, así que editarlos directamente es editar el dotfile. No hace falta nada especial.

**Añadir un archivo a un módulo existente:**

```bash
cp script.sh ~/dotfiles/hypr/.config/hypr/scripts/
cd ~/dotfiles && stow --restow hypr
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
# en la máquina que tiene cambios
git add -A && git commit -m "..." && git push

# en la otra
git pull && bash install.sh --stow-only
```

---

## Dependencias

Ver [PACKAGES.md](PACKAGES.md) para la lista completa por módulo.
