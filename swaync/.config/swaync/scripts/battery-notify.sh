#!/bin/bash
# battery-notify.sh
# Avisos de batería vía swaync (notificación + sonido).
#   Batería del sistema (portátil): cargador conectado/desconectado, baja, crítica, completa.
#   Periféricos (ratón/teclado, scope=Device): baja y crítica.
# Sin batería de sistema (p. ej. archMSI) solo vigila los periféricos. No hay `if`
# por máquina: lo que exista en /sys/class/power_supply es lo que se vigila.
#
# Umbrales: BAT_LOW (defecto 20) y BAT_CRIT (defecto 10), en %.
# Categorías (swaync elige el sonido con ellas, ver "scripts" en config_*.json):
#   power.plugged · power.unplugged · power.low · power.critical · power.full
#
# Se lanza desde hypr/conf/autostart.lua.
# Test sin hardware: POWER_SUPPLY_DIR=<árbol falso con el formato de /sys/class/power_supply>
set -u

PS_DIR="${POWER_SUPPLY_DIR:-/sys/class/power_supply}"
LOW="${BAT_LOW:-20}"
CRIT="${BAT_CRIT:-10}"
REARM=5 # histéresis: tras avisar, no se re-arma hasta superar LOW+REARM (o cargar)

declare -A lvl       # supply → ok|low|crit (último nivel avisado)
declare -A full_sent # supply → 1 si ya se avisó "completa" en esta carga
ac_prev=""
QUIET=0 # 1 = solo inicializa estado, sin avisar (primera pasada al arrancar)

rd() { [[ -r "$1" ]] && cat "$1"; }

notify() { # <categoría> <urgencia> <icono> <título> <cuerpo> [id-sincronizado]
	((QUIET)) && return 0
	local args=(-a "Batería" -c "$1" -u "$2" -i "$3")
	[[ -n "${6:-}" ]] && args+=(-h "string:x-canonical-private-synchronous:$6")
	notify-send "${args[@]}" "$4" "$5"
}

# Porcentaje: de `capacity`, o estimado con `capacity_level` (p. ej. el ratón Logitech)
capacity() { # <dir> → número, o vacío si no hay dato
	local c
	c="$(rd "$1/capacity")"
	if [[ -n "$c" ]]; then
		echo "$c"
		return
	fi
	case "$(rd "$1/capacity_level")" in
	Critical) echo "$CRIT" ;;
	Low) echo "$LOW" ;;
	Normal | High | Full) echo 100 ;;
	esac
}

# "17 %" si hay porcentaje real; "nivel bajo" / "nivel crítico" si solo hay capacity_level
level_text() { # <dir> <cap> <low|crit>
	if [[ -n "$(rd "$1/capacity")" ]]; then
		echo "$2 %"
	elif [[ "$3" == crit ]]; then
		echo "nivel crítico"
	else
		echo "nivel bajo"
	fi
}

check() {
	local d type name scope status cap label prev new
	local ac=0 have_ac=0 sys_dir=""

	# 1) cargadores y batería del sistema
	for d in "$PS_DIR"/*; do
		[[ -d "$d" ]] || continue
		type="$(rd "$d/type")"
		case "$type" in
		Mains | USB)
			have_ac=1
			[[ "$(rd "$d/online")" == 1 ]] && ac=1
			;;
		Battery)
			[[ "$(rd "$d/scope")" != Device && -z "$sys_dir" ]] && sys_dir="$d"
			;;
		esac
	done

	if [[ -n "$sys_dir" ]] && ((have_ac)); then
		cap="$(capacity "$sys_dir")"
		if [[ -n "$ac_prev" && "$ac" != "$ac_prev" ]]; then
			if ((ac)); then
				notify power.plugged normal battery-level-100-plugged-in-symbolic \
					"Cargador conectado" "Batería: ${cap:-?} %" power-source
			else
				notify power.unplugged normal battery-level-50-symbolic \
					"Cargador desconectado" "Batería: ${cap:-?} %" power-source
			fi
		fi
		ac_prev="$ac"
	fi

	# 2) niveles: batería del sistema y periféricos
	for d in "$PS_DIR"/*; do
		[[ -d "$d" ]] || continue
		[[ "$(rd "$d/type")" == Battery ]] || continue
		name="${d##*/}"
		scope="$(rd "$d/scope")"
		status="$(rd "$d/status")"
		cap="$(capacity "$d")"
		[[ -n "$cap" ]] || continue

		if [[ "$scope" == Device ]]; then
			label="$(rd "$d/model_name")"
			label="${label:-$name}"
		else
			label="Batería"
		fi

		# completa (solo batería del sistema, una vez por carga)
		if [[ "$scope" != Device ]]; then
			if [[ "$status" == Full ]]; then
				if [[ -z "${full_sent[$name]:-}" ]]; then
					full_sent[$name]=1
					notify power.full normal battery-level-100-charged-symbolic \
						"Batería completa" "Ya puedes desconectar el cargador"
				fi
			else
				unset "full_sent[$name]"
			fi
		fi

		# baja / crítica
		prev="${lvl[$name]:-ok}"
		if [[ "$status" == Charging || "$status" == Full ]] || ((cap > LOW + REARM)); then
			lvl[$name]=ok
		else
			new=ok
			((cap <= LOW)) && new=low
			((cap <= CRIT)) && new=crit
			if [[ "$new" == crit && "$prev" != crit ]]; then
				lvl[$name]=crit
				notify power.critical critical battery-level-10-symbolic \
					"Batería crítica" "$label: $(level_text "$d" "$cap" crit)" "batt-$name"
			elif [[ "$new" == low && "$prev" == ok ]]; then
				lvl[$name]=low
				notify power.low normal battery-level-20-symbolic \
					"Batería baja" "$label: $(level_text "$d" "$cap" low)" "batt-$name"
			fi
		fi
	done
}

main() {
	QUIET=1
	check
	QUIET=0

	# Despierta con eventos de udev (enchufar/desenchufar) o cada 60 s (niveles)
	exec 3< <(udevadm monitor --udev --subsystem-match=power_supply 2>/dev/null)
	local rc
	while true; do
		read -r -t 60 <&3
		rc=$?
		((rc == 0)) && sleep 0.5 # agrupa ráfagas de eventos
		((rc == 1)) && sleep 60  # udevadm terminó (EOF): solo sondeo
		check
	done
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	main
fi
