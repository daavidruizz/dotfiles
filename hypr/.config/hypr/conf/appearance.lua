---------------------
--- LOOK AND FEEL ---
---------------------

hl.config({
    general = {
        gaps_in       = 5,
        gaps_out      = 10,
        border_size   = 0,
        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",

    	col = {
        	active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45},
        	inactive_border = "rgba(595959aa)",
   	},

    },
    decoration = {
        rounding          = 15,
        active_opacity    = 1.0,
        inactive_opacity  = 0.9,
        fullscreen_opacity = 1.0,

        blur = {
            enabled           = true,
            size              = 4,
            passes            = 4,
            new_optimizations = true,
            ignore_opacity    = true,
            xray              = true,
        },

        shadow = {
            enabled      = true,
            range        = 10,
            render_power = 2,
            color        = "0x33000000",
        },
    },

    animations = {
        enabled = true,
    },

    --dwindle = {
    --    pseudotile     = true,
    --    preserve_split = true,
    --},

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        enable_swallow           = false,
    },

    cursor = {
        no_hardware_cursors = true,
    },
})

-- Layer rules
hl.layer_rule({ match = { namespace = "waybar"            }, blur = true })
hl.layer_rule({ match = { namespace = "rofi"              }, blur = true })
hl.layer_rule({ match = { namespace = "nwg-dock-hyprland" }, blur = true })

-- Curves — credit https://github.com/end-4/dots-hyprland
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

-- Animations
hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "myBezier", curve  = "default", style = "slide" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "myBezier", curve  = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "myBezier", curve  = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "myBezier", curve  = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "myBezier", curve  = "default" })
