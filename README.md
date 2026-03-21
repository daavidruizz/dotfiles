# Hyprland Dotfiles

Configuración completa de entorno Hyprland para Arch Linux, gestionada con [GNU Stow](https://www.gnu.org/software/stow/).

## Requisitos previos

- Arch Linux (o derivada)
- GPU NVIDIA (los paquetes de drivers están incluidos en el instalador)
- Conexión a internet

## Instalación en un PC nuevo

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
bash install.sh
```

Eso hace todo:
1. Instala paquetes pacman
2. Instala paquetes AUR (instala `yay` si no está)
3. Copia fuentes bundled a `~/.local/share/fonts/`
4. Crea symlinks con stow para todos los módulos
5. Copia wallpapers a `~/wallpapers/` y `~/Pictures/`

### Pasos manuales tras la instalación

```bash
# Detectar sensores de temperatura (necesario para waybar)
sudo sensors-detect

# Activar red
sudo systemctl enable --now NetworkManager

# Editar monitores según el hardware del PC nuevo
nano ~/.config/hypr/hyprland.conf   # sección MONITORS (líneas 26-34)
```

## Opciones del instalador

```bash
# Solo instalar módulos específicos (salta paquetes y wallpapers)
bash install.sh --only hypr waybar kitty

# Simular sin modificar nada
bash install.sh --dry-run

# Log completo en:
cat ~/dotfiles/install.log
```

## Estructura

```
dotfiles/
├── hypr/           → ~/.config/hypr/
├── waybar/         → ~/.config/waybar/dev/
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
├── wallpapers/     → ~/wallpapers/ + ~/Pictures/ (copia directa, no stow)
├── install.sh      — instalador principal
├── migrate-to-stow.sh  — script de migración (uso único, ya ejecutado)
└── PACKAGES.md     — dependencias detalladas por módulo
```

Cada módulo es un **paquete GNU Stow**: sus archivos se corresponden con la ruta que tendrían en `$HOME`. Stow crea los symlinks automáticamente.

## Flujo de trabajo diario

**Editar configuración existente** — edita directamente en `~/.config/` o en `~/dotfiles/`. Son el mismo archivo (symlink), los cambios son inmediatos.

**Añadir un archivo nuevo a un módulo existente:**

```bash
# Coloca el archivo en la estructura dotfiles
cp mi-script.sh ~/dotfiles/hypr/.config/hypr/scripts/

# Recrea los symlinks del módulo
cd ~/dotfiles && stow --restow hypr
```

**Añadir un módulo nuevo** (ej: `nvim`):

```bash
mkdir -p ~/dotfiles/nvim/.config/nvim
cp -r ~/.config/nvim/* ~/dotfiles/nvim/.config/nvim/
cd ~/dotfiles && stow nvim
```

Añade el módulo a `ALL_MODULES` en `install.sh` para que se instale en PCs nuevos.

## Monitores

El archivo `hypr/.config/hypr/hyprland.conf` incluye dos configuraciones:

```bash
# DEFAULT (PC nuevo — detecta automáticamente)
#monitor = , preferred, auto, 1

# PERSONAL (2x QHD 180Hz + HDMI desactivado)
monitor = DP-3, 2560x1440@180.00Hz, 0x0, 1
monitor = DP-2, 2560x1440@180.00Hz, 2561x0, 1
monitor = HDMI-A-1, disable
```

En un PC nuevo: comentar las líneas personales y descomentar la línea default.

## Dependencias completas

Ver [PACKAGES.md](PACKAGES.md) para la lista detallada de dependencias por módulo, incluyendo fuentes, iconos y dependencias entre módulos.
