------------------
--- WORKSPACES ---
------------------

-- Apps al inicio
--hl.exec_once("hypridle -c ~/.config/hypr/hypridle_legion.conf")

-- SETUP LEGION — ajusta según monitores conectados
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1", persistent = true })
