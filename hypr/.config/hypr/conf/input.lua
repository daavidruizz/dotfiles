-------------
--- INPUT ---
-------------

hl.config({
    input = {
        kb_layout  = "es",

        follow_mouse         = 1,
        numlock_by_default   = true,
        sensitivity          = 0,
        force_no_accel       = true,
        accel_profile        = "flat",

        touchpad = {
            natural_scroll = true,
        },
    },
})  

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
--TODO TOUCHPAD SENSITIVITY
hl.device({
    name = "syna2b46:00-06cb:cd5f-mouse",
    sensitivity = 1, 
    scroll_factor = 0,
})

hl.device({
    name = "syna2b46:00-06cb:cd5f-touchpad",
    sensitivity = 1, 
    scroll_factor = 0.5,
})
