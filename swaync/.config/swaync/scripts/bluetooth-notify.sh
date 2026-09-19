#!/bin/bash
# bluetooth-notify.sh
# Avisa (notificación + sonido vía swaync) al conectar/desconectar un dispositivo
# Bluetooth. Escucha las señales de BlueZ por D-Bus: sin polling.
#
# Categorías que envía (swaync elige el sonido con ellas, ver "scripts" en config_*.json):
#   device.added   → conectado
#   device.removed → desconectado
#
# Se lanza desde hypr/conf/autostart.lua.
# Test sin hardware: BT_NOTIFY_FIXTURE=<fichero con líneas de `gdbus monitor`>
set -u

# Lee una propiedad de org.bluez.Device1 (sin las comillas de busctl)
bt_prop() { # <ruta D-Bus> <propiedad>
	busctl --system get-property org.bluez "$1" org.bluez.Device1 "$2" 2>/dev/null |
		sed -E 's/^s "(.*)"$/\1/'
}

declare -A last # último estado por dispositivo, para no duplicar avisos

handle() {
	local line="$1" path state name icon
	[[ "$line" == *"org.freedesktop.DBus.Properties.PropertiesChanged ('org.bluez.Device1'"* ]] || return
	[[ "$line" =~ \'Connected\':\ \<(true|false)\> ]] || return
	state="${BASH_REMATCH[1]}"
	path="${line%%:*}"

	[[ "${last[$path]:-}" == "$state" ]] && return
	last[$path]="$state"

	name="$(bt_prop "$path" Alias)"
	name="${name:-Dispositivo Bluetooth}"
	icon="$(bt_prop "$path" Icon)"

	# El hint "synchronous" hace que conectado/desconectado del mismo dispositivo
	# se reemplacen entre sí en vez de apilarse.
	if [[ "$state" == true ]]; then
		notify-send -a "Bluetooth" -c device.added -i "${icon:-bluetooth-active-symbolic}" \
			-h "string:x-canonical-private-synchronous:bt-$path" \
			"Bluetooth conectado" "$name"
	else
		notify-send -a "Bluetooth" -c device.removed -i "${icon:-bluetooth-disabled-symbolic}" \
			-h "string:x-canonical-private-synchronous:bt-$path" \
			"Bluetooth desconectado" "$name"
	fi
}

main() {
	while true; do
		if [[ -n "${BT_NOTIFY_FIXTURE:-}" ]]; then
			while IFS= read -r line; do handle "$line"; done <"$BT_NOTIFY_FIXTURE"
			return
		fi
		while IFS= read -r line; do handle "$line"; done < <(gdbus monitor --system --dest org.bluez 2>/dev/null)
		sleep 5 # bluetooth.service parado o reiniciado: reintenta
	done
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	main
fi
