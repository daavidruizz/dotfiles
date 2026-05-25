-- Hyprland config — modular layout
-- Docs: https://wiki.hypr.land/Configuring/

local D = os.getenv("HOME") .. "/.config/hypr/conf/"


-- Obtenemos el hostname
local file = io.open("/proc/sys/kernel/hostname", "r")
local hostname = ""
if file then
    hostname = file:read("*l") -- Lee la primera línea
    file:close()
end

----------------------
------ GLOBALS  ------
----------------------
MACHINE      = hostname
TERMINAL     = "kitty"
FILE_MANAGER = "thunar"
MENU         = "wofi --show drun"
MAIN_MOD     = "SUPER"

----------------------
------ MACHINE  ------
----------------------
LEGION  = "archLEGION"
MSI     = "archMSI"

if MACHINE == MSI then
    dofile(D .. "monitors_msi.lua")
    dofile(D .. "workspaces_msi.lua")    
elseif MACHINE == LEGION then
    dofile(D .. "monitors_legion.lua")
    dofile(D .. "workspaces_legion.lua")
else
    dofile(D .. "monitors_msi.lua") --TODO DEFAULTS
    dofile(D .. "workspaces_msi.lua")
end
--------------------------
------ CORE MODULES ------
--------------------------
dofile(D .. "env.lua")
dofile(D .. "input.lua")
dofile(D .. "keybinds.lua")
dofile(D .. "appearance.lua")
dofile(D .. "autostart.lua")
dofile(D .. "rules.lua")
