#!/bin/bash
# play-sound.sh [-f] <nombre>
# Reproduce un sonido del tema freedesktop (paquete sound-theme-freedesktop).
#   -f   suena aunque "No molestar" esté activo (feedback de teclas volumen/brillo)
#
# Sobrescribible: ~/.local/share/sounds/<nombre>.{oga,ogg,wav} tiene prioridad.
# Depuración:     touch ~/.cache/play-sound.debug  → registra en ~/.cache/play-sound.log
#
# Lo llaman swaync ("scripts" en config_*.json) y los atajos de volumen/brillo.

force=false
[[ "${1:-}" == "-f" ]] && {
	force=true
	shift
}
name="${1:-}"
[[ -n "$name" ]] || {
	echo "uso: play-sound.sh [-f] <nombre>" >&2
	exit 1
}

file=""
for f in "$HOME/.local/share/sounds/$name".{oga,ogg,wav} "/usr/share/sounds/freedesktop/stereo/$name.oga"; do
	[[ -r "$f" ]] && {
		file="$f"
		break
	}
done

dnd="$(swaync-client -D 2>/dev/null)"

if [[ -f "$HOME/.cache/play-sound.debug" ]]; then
	echo "$(date +%T) $name force=$force dnd=${dnd:-?} file=${file:-NINGUNO}" >>"$HOME/.cache/play-sound.log"
fi

[[ -n "$file" ]] || exit 0
if ! $force && [[ "$dnd" == "true" ]]; then
	exit 0
fi

# flock -n: si ese mismo sonido ya está sonando (teclas en repetición) no se apila
exec flock -n "${XDG_RUNTIME_DIR:-/tmp}/play-sound-$name.lock" pw-play "$file"
