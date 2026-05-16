------------------
--- WORKSPACES ---
------------------

-- DP-2 = monitor izquierdo, DP-1 = monitor derecho
hl.workspace_rule({ workspace = "6",  monitor = "DP-2", default = true, persistent = true })
hl.workspace_rule({ workspace = "7",  monitor = "DP-2", persistent = true })
hl.workspace_rule({ workspace = "8",  monitor = "DP-2", persistent = true })
hl.workspace_rule({ workspace = "9",  monitor = "DP-2", persistent = true })
hl.workspace_rule({ workspace = "10", monitor = "DP-2", persistent = true })

hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-1", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-1", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "DP-1", persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "DP-1", persistent = true })

-- Apps al inicio
--hl.exec_once("hypridle -c ~/.config/hypr/hypridle_msi.conf")
--hl.exec_once("bash -c 'sleep 2 && flatpak run com.spotify.Client'")
--hl.window_rule({ match = { class = "Spotify" }, workspace = "7 silent" })
