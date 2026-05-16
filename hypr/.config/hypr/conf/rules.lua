------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

-- Global
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
--hl.window_rule({ match = { class = "^$", title = "^$", xwayland = "1", float = true, fullscreen = "0", pinned = "0" }, no_focus = true })
hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- System dialogs
hl.window_rule({ match = { title = "^(NetworkManager)$"    }, float = true, center = true, size = {800,  600} })
hl.window_rule({ match = { title = "^(System Monitor)$"    }, float = true, center = true, size = {900,  700} })
hl.window_rule({ match = { title = "^(Disk Usage)$"        }, float = true, center = true, size = {800,  600} })
hl.window_rule({ match = { title = "^(Audio Control)$"     }, float = true, center = true, size = {600,  400} })
hl.window_rule({ match = { title = "^(Bluetooth Manager)$" }, float = true, center = true, size = {500,  400} })
hl.window_rule({ match = { title = "^(Calendar)$"          }, float = true, center = true, size = {600,  500} })
hl.window_rule({ match = { title = "^(Calculator)$"        }, float = true, center = true, size = {400,  500} })

-- File manager
hl.window_rule({ match = { class = "thunar" }, float = true, center = true, size = {1200, 800} })

-- Generic floating
hl.window_rule({ match = { class = "type1-floating" }, float = true, center = true, size = {1200, 600} })

-- File choosers
hl.window_rule({ match = { class = "xdg-desktop-portal-gtk" }, float = true, center = true, size = {900, 650} })

-- Sidepad
hl.window_rule({ match = { class = "sidepad" }, float = true, pin = true, center = true, size = {1000, 700} })

-- Rofi
hl.window_rule({ match = { class = "rofi" }, opacity = "0.9 0.9" })

-- Chrome PWA
hl.window_rule({ match = { class = "^chrome-calendar\\.google\\.com" }, float = true, center = true, size = {1400, 800} })
hl.window_rule({ match = { class = "^chrome-outlook\\.live\\.com"    }, float = true, center = true, size = {1400, 800} })
hl.window_rule({ match = { class = "^chrome-mail\\.google\\.com"     }, float = true, center = true, size = {1400, 800} })

-- Bluetooth
hl.window_rule({ match = { class = "bluetuith" }, float = true, center = true, size = {1200, 600}, opacity = "1.0 override" })

-- Notifications
hl.window_rule({ match = { class = "Dunst" }, float = true })

-- Document viewers
hl.window_rule({ match = { class = "org\\.pwmt\\.zathura" }, float = true, center = true, size = {"70%", "90%"} })
hl.window_rule({ match = { class = "zathura"              }, float = true, center = true, size = {"70%", "90%"} })

-- Text editor
hl.window_rule({ match = { class = "org\\.kde\\.kwrite" }, float = true, center = true, size = {"60%", "70%"} })
hl.window_rule({ match = { class = "kwrite"             }, float = true, center = true, size = {"60%", "70%"} })

-- Image viewers
hl.window_rule({ match = { class = "feh" }, float = true, center = true, size = {"60%", "70%"} })
hl.window_rule({ match = { class = "imv" }, float = true, center = true, size = {"60%", "70%"} })

-- Calculator
hl.window_rule({ match = { class = "qalculate-gtk" }, float = true, center = true, size = {400, 500} })
