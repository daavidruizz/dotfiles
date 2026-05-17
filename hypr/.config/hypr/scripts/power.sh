#!/usr/bin/env bash
#    ___                    
#   / _ \___ _    _____ ____
#  / ___/ _ \ |/|/ / -_) __/
# /_/   \___/__,__/\__/_/   
#                           

terminate_clients() {
  	TIMEOUT=5
	# Get a list of all client PIDs in the current Hyprland session
	client_pids=$(hyprctl clients -j | jq -r '.[] | .pid')

	# Send SIGTERM (kill -15) to each client PID and wait for termination
	for pid in $client_pids; do
		echo ":: Sending SIGTERM to PID $pid"
		kill -15 $pid
	done

	start_time=$(date +%s)
	for pid in $client_pids; do
		# Wait for the process to terminate
		while kill -0 $pid 2>/dev/null; do
		current_time=$(date +%s)
		elapsed_time=$((current_time - start_time))

		if [ $elapsed_time -ge $TIMEOUT ]; then
			echo ":: Timeout reached."
			return 0
		fi

		echo ":: Waiting for PID $pid to terminate..."
		sleep 1
		done

		echo ":: PID $pid has terminated."
	done
	bash $home/.config/ml4w/listeners.sh --stopall
}

if [[ "$1" == "exit" ]]; then
	echo ":: Exit"
	terminate_clients
	sleep 0.5
	hyprctl dispatch exit
	sleep 2
fi

if [[ "$1" == "lock" ]]; then
	echo ":: Lock"
	sleep 0.5
	hyprlock
fi

power_countdown() {
	local title="$1"
	local cmd="$2"
	local delay=5
	local cancel_file="/tmp/.power_cancel"
	rm -f "$cancel_file"

	local notif_id
	notif_id=$(dunstify -p -u critical -t $((delay * 1000 + 1000)) \
		"⏻  $title" "Ejecutando en ${delay}s…  [Click derecho en el botón para cancelar]")

	for i in $(seq $((delay - 1)) -1 1); do
		sleep 1
		if [[ -f "$cancel_file" ]]; then
			rm -f "$cancel_file"
			dunstify -r "$notif_id" -u low "Cancelado" "$title fue cancelado"
			exit 0
		fi
		dunstify -r "$notif_id" -u critical -t $((i * 1000 + 500)) \
			"⏻  $title" "Ejecutando en ${i}s…"
	done

	sleep 1
	dunstify -r "$notif_id" -u critical -t 2000 "⏻  $title" "Ejecutando…"
	eval "$cmd"
}

if [[ "$1" == "reboot" ]]; then
	echo ":: Reboot"
	power_countdown "Reiniciando" "terminate_clients && sleep 0.5 && systemctl reboot"
fi

if [[ "$1" == "shutdown" ]]; then
	echo ":: Shutdown"
	power_countdown "Apagando" "terminate_clients && sleep 0.5 && systemctl poweroff"
fi

if [[ "$1" == "suspend" ]]; then
	echo ":: Suspend"
	sleep 0.5
	systemctl suspend
fi

if [[ "$1" == "hibernate" ]]; then
	echo ":: Hibernate"
	sleep 1
	systemctl hibernate
fi
