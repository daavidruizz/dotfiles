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
            natural_scroll = false,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.device({
    name          = "epic-mouse-v1",
    accel_profile = "flat",
    sensitivity   = -0.5,
})
