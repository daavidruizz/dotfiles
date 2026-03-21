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
dotfiles/
├── hypr/           → ~/.config/hypr/
├── waybar/         → ~/.config/waybar/
├── kitty/          → ~/.config/kitty/
├── dunst/          → ~/.config/dunst/
├── rofi/           → ~/.config/rofi/ + ~/.local/share/rofi/themes/
├── wlogout/        → ~/.config/wlogout/
├── nwg-dock/       → ~/.config/nwg-dock-hyprland/
├── swayosd/        → ~/.config/swayosd/
├── thunar/         → ~/.config/Thunar/
├── easyeffects/    → ~/.config/easyeffects/
├── fastfetch/      → ~/.config/fastfetch/
├── btop/           → ~/.config/btop/
├── gtk/            → ~/.config/{gtk-2.0,gtk-3.0,gtk-4.0,nwg-look}/
├── nvim/           → ~/.config/nvim/
├── vim/            → ~/.vimrc
├── bash/           → ~/.bashrc
├── wallpapers/     → ~/wallpapers/ + ~/Pictures/ (copia directa)
├── install.sh
└── PACKAGES.md
```

---

## Multi-máquina

El repo está pensado para funcionar en distintos PCs sin cambios. Lo único que varía por máquina es la configuración de monitores y workspace-monitor bindings, que va en un archivo **no commiteado**:

```
~/.config/hypr/monitors.conf
```

Este archivo es ignorado por git (`.gitignore`). En cada máquina creas el tuyo.

**Ejemplo para setup de dos monitores:**

```ini
workspace = 1, monitor:DP-2, default:true, persistent:true
workspace = 2, monitor:DP-2, persistent:true
workspace = 3, monitor:DP-2, persistent:true
workspace = 4, monitor:DP-2, persistent:true
workspace = 5, monitor:DP-2, persistent:true

workspace = 6, monitor:DP-3, default:true, persistent:true
workspace = 7, monitor:DP-3, persistent:true
workspace = 8, monitor:DP-3, persistent:true
workspace = 9, monitor:DP-3, persistent:true
workspace = 10, monitor:DP-3, persistent:true
```

**Máquina con un solo monitor:** crear el archivo vacío es suficiente, los workspaces 1-5 del `hyprland.conf` base se aplican solos.

```bash
touch ~/.config/hypr/monitors.conf
```

La configuración de monitores físicos (`monitor =`) sigue estando en `hyprland.conf` — editarla a mano según el hardware.

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
git pull && bash install.sh --only <modulo>
```

---

## Dependencias

Ver [PACKAGES.md](PACKAGES.md) para la lista completa por módulo.
