-------------------
--- KEYBINDINGS ---
-------------------

-- Core
hl.bind(MAIN_MOD .. " + RETURN", hl.dsp.exec_cmd(TERMINAL))
hl.bind(MAIN_MOD .. " + Q",      hl.dsp.window.kill())
hl.bind(MAIN_MOD .. " + M",      hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(MAIN_MOD .. " + E",      hl.dsp.exec_cmd(FILE_MANAGER .. " --class=type1-floating"))
hl.bind(MAIN_MOD .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(MAIN_MOD .. " + R",      hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(MAIN_MOD .. " + P",      hl.dsp.window.pseudo())
hl.bind(MAIN_MOD .. " + J",      hl.dsp.layout("togglesplit"))
hl.bind(MAIN_MOD .. " + K",      hl.dsp.layout("swapsplit"))
hl.bind(MAIN_MOD .. " + L",      hl.dsp.exec_cmd("hyprlock"))
hl.bind(MAIN_MOD .. " + B",      hl.dsp.exec_cmd("google-chrome-stable --enable-notifications --enable-system-notifications"))
hl.bind(MAIN_MOD .. " + SPACE",  hl.dsp.exec_cmd("rofi --class rofi -show drun -show-icons"))
hl.bind(MAIN_MOD .. " + W",      hl.dsp.exec_cmd("/usr/bin/google-chrome-stable --profile-directory=Default --app-id=hnpfjngllnobngcgfapefoaidbinmjnm"))
hl.bind("XF86Calculator",        hl.dsp.exec_cmd("qalculate-gtk"))

-- Focus
hl.bind(MAIN_MOD .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(MAIN_MOD .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(MAIN_MOD .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(MAIN_MOD .. " + down",  hl.dsp.focus({ direction = "d" }))

-- Workspaces: switch
for i = 1, 10 do
    local k = (i == 10) and "0" or tostring(i)
    hl.bind(MAIN_MOD .. " + " .. k, hl.dsp.focus({workspace = i})) 
    hl.bind(MAIN_MOD .. " + SHIFT + " .. k, hl.dsp.window.move({ workspace = i }))
end

-- Mouse
hl.bind(MAIN_MOD .. " + mouse_down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(MAIN_MOD .. " + mouse_up",   hl.dsp.focus({ workspace = "m-1" }))
hl.bind(MAIN_MOD .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(MAIN_MOD .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- Media (repeating)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume raise"),       { repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume lower"),       { repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),  { repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"),          { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"),          { repeating = true })

-- Media (locked — funciona en lockscreen)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Screenshots
hl.bind("SUPER + Print",   hl.dsp.exec_cmd("grimblast copysave screen ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"))
hl.bind("SUPER + ALT + S", hl.dsp.exec_cmd("grimblast copy area"))

-- Misc
hl.bind("SUPER + T",     hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_tv.sh"))

-- Sidepad
hl.bind("SUPER + S",         hl.dsp.exec_cmd('~/.config/hypr/scripts/sidepad.sh --init "firefox --no-remote -P default --name sidepad https://gemini.google.com/app/9ccf40715d812aac?hl=es"'))
hl.bind("SUPER + CTRL + right", hl.dsp.exec_cmd("~/.config/hypr/scripts/sidepad.sh"))
hl.bind("SUPER + CTRL + left",  hl.dsp.exec_cmd("~/.config/hypr/scripts/sidepad.sh --hide"))
hl.bind("SUPER + SHIFT + S",    hl.dsp.exec_cmd("~/.config/hypr/scripts/sidepad.sh --kill"))
