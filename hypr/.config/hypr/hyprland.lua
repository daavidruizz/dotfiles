-- Hyprland config — modular layout
-- Docs: https://wiki.hypr.land/Configuring/

local D = os.getenv("HOME") .. "/.config/hypr/conf/"

----------------------
------ GLOBALS  ------
----------------------
TERMINAL     = "kitty"
FILE_MANAGER = "thunar"
MENU         = "wofi --show drun"
MAIN_MOD     = "SUPER"

----------------------
------ MACHINE  ------
----------------------
-- Para MSI:    descomentar _msi,    comentar _legion
-- Para Legion: descomentar _legion, comentar _msi
dofile(D .. "monitors_msi.lua")
dofile(D .. "workspaces_msi.lua")
--dofile(D .. "monitors_legion.lua")
--dofile(D .. "workspaces_legion.lua")

--------------------------
------ CORE MODULES ------
--------------------------
dofile(D .. "env.lua")
dofile(D .. "input.lua")
dofile(D .. "keybinds.lua")
dofile(D .. "appearance.lua")
dofile(D .. "autostart.lua")
dofile(D .. "rules.lua")
