----------------------------------
------ VARIABLES & ENV VARS ------
----------------------------------

-- Cursor / display
hl.env("XCURSOR_SIZE",  "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- NVIDIA
hl.env("LIBVA_DRIVER_NAME",        "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME","nvidia")
hl.env("NVD_BACKEND",              "direct")

-- Wayland
hl.env("GTK_BACKEND", "wayland")

-- QT theming
hl.env("QT_QPA_PLATFORM",      "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT6_QPA_PLATFORMTHEME","qt6ct")
