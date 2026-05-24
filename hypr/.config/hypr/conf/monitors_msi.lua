----------------------
------ MONITORS ------
----------------------

-- SETUP MSI (2x 2560x1440@180Hz + TV deshabilitada)
-- DEFAULT: descomentar en PC nuevo si no se conoce la config exacta

hl.monitor({
	output = "DP-2",
	mode = "2560x1440@180.00Hz",
	position = "0x0",
	scale = 1,
})

hl.monitor({
	output = "DP-1",
	mode = "2560x1440@180.00Hz",
	position = "2561x0",
	scale = 1,
})

hl.monitor({
	output = "HDMI-A-2",
	mode = "1920x1080@60",
	position = "960x-1080",
	scale = 1,
	disabled = true,
})
