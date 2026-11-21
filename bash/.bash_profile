#
# ~/.bash_profile — se ejecuta UNA vez, al hacer login (TTY / ssh)
#
# Aquí van las variables de entorno: Hyprland y todo lo que lances
# desde él las hereda. Lo interactivo (alias, prompt…) va en ~/.bashrc.
#

# ────────────────────────────────────────────────
# EXPORTS — comunes a todas las máquinas
# ────────────────────────────────────────────────

export PATH="$HOME/.local/bin:$PATH"

export FILE_MANAGER=thunar
export XDG_FILE_MANAGER=thunar

# Locale del sistema
if [ -f /etc/locale.conf ]; then
  set -a
  . /etc/locale.conf
  set +a
fi

# ────────────────────────────────────────────────
# EXPORTS — específicos de la máquina
#   archMSI → ~/.bash_profile_msi, archLEGION → ~/.bash_profile_legion
# ────────────────────────────────────────────────

_host="${HOSTNAME,,}"
_host="${_host#arch}"
[[ -f ~/.bash_profile_$_host ]] && . ~/.bash_profile_$_host

# ────────────────────────────────────────────────
# HYPRLAND — arrancar en TTY1 (después de los exports)
# ────────────────────────────────────────────────

if [[ -z $DISPLAY && -z $WAYLAND_DISPLAY && $XDG_VTNR == 1 ]]; then
  exec start-hyprland
fi

# Resto de TTYs / ssh: cargar la config interactiva
[[ -f ~/.bashrc ]] && . ~/.bashrc
