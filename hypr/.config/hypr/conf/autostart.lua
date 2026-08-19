-----------------
--- AUTOSTART ---
-----------------
hl.on("hyprland.start", function()
	-- Core services
	hl.exec_cmd("waybar --config ~/.config/waybar/config --style ~/.config/waybar/style.css")
	hl.exec_cmd("dunst")
	hl.exec_cmd("swayosd-server --top-margin 0.99")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("hypridle")
	-- Wallpaper
	--hl.exec_once("hyprpaper")
	--hl.exec_once("~/.config/hypr/scripts/random-wall-video.sh")
	hl.exec_cmd("~/.config/hypr/scripts/random-wall.sh")

	-- Dock & audio
	hl.exec_cmd("nwg-dock-hyprland -d -i 40 -mb 8 -nolauncher -hd 0 -l overlay")
	hl.exec_cmd("easyeffects --gapplication-service")

	-- Clipboard history daemon
	hl.exec_cmd("wl-paste --watch cliphist store")

	-- Cursor
	hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 23")

	-- Bitwarden
	hl.exec_cmd("bitwarden-desktop")
	hl.exec_cmd("thunderbird")
end)
