# dotfiles

Hyprland + Arch Linux. Gestionado con GNU Stow.

## Instalación

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
bash install.sh
```

Instala paquetes (pacman + AUR), fuentes, crea los symlinks y copia los wallpapers.

Después, a mano:

```bash
sudo sensors-detect                   # temperaturas en waybar
sudo systemctl enable --now NetworkManager
# ajustar monitores en hyprland.conf si el hardware es distinto
```

## Opciones

```bash
bash install.sh --only hypr waybar   # solo esos módulos
bash install.sh --dry-run            # simula sin tocar nada
cat ~/dotfiles/install.log           # log completo
```

## Estructura

```
dotfiles/
├── hypr/           → ~/.config/hypr/
├── waybar/         → ~/.config/waybar/
├── dunst/          → ~/.config/dunst/
├── rofi/           → ~/.config/rofi/ + ~/.local/share/rofi/themes/
├── kitty/          → ~/.config/kitty/
├── wlogout/        → ~/.config/wlogout/
├── nwg-dock/       → ~/.config/nwg-dock-hyprland/
├── thunar/         → ~/.config/Thunar/
├── easyeffects/    → ~/.config/easyeffects/
├── fastfetch/      → ~/.config/fastfetch/
├── btop/           → ~/.config/btop/
├── gtk/            → ~/.config/{gtk-2.0,gtk-3.0,gtk-4.0,nwg-look}/
├── wallpapers/     → ~/wallpapers/ + ~/Pictures/ (copia directa)
├── install.sh
└── PACKAGES.md     — dependencias por módulo
```

Cada directorio es un paquete stow: la estructura interna refleja `$HOME`, los archivos en `~/.config/` son symlinks a aquí.

## Día a día

Editar configs directamente en `~/.config/` funciona, es el mismo archivo.

Añadir algo a un módulo existente:

```bash
cp archivo ~/dotfiles/hypr/.config/hypr/scripts/
cd ~/dotfiles && stow --restow hypr
```

Módulo nuevo:

```bash
mkdir -p ~/dotfiles/nvim/.config/nvim
cp -r ~/.config/nvim/* ~/dotfiles/nvim/.config/nvim/
stow nvim
# añadirlo también a ALL_MODULES en install.sh
```

## Monitores

`hyprland.conf` tiene las dos opciones:

```bash
# para pc nuevo
#monitor = , preferred, auto, 1

# setup actual
monitor = DP-3, 2560x1440@180.00Hz, 0x0, 1
monitor = DP-2, 2560x1440@180.00Hz, 2561x0, 1
monitor = HDMI-A-1, disable
```

## Dependencias

Ver [PACKAGES.md](PACKAGES.md).
