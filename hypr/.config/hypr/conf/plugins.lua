---------------------
------ PLUGINS ------
---------------------
-- hyprglass: efecto Liquid Glass (blur + refracción + aberración cromática + specular)
-- SOLO archMSI. Se instala con ./install.sh (hyprpm add) y se carga en el
-- autostart con `hyprpm reload -n`. Si el plugin no está cargado este bloque
-- no hace nada (p. ej. en archLEGION).
-- Tras cada actualización de Hyprland: hyprpm update
-- Repo: https://github.com/hyprnux/hyprglass

if hl.plugin.hyprglass then
	local hg = hl.plugin.hyprglass

	-- Presets (definidos antes de usarlos en config/layer)
	-- "liquid": ventanas. Vidrio oscuro y legible; el borde casi no deforma el
	-- fondo (poca refracción/lente/aberración), solo un brillo de borde sutil.
	hg.preset("liquid", {
		blur_strength = 2.0,
		blur_iterations = 3,
		glass_opacity = 1.0,
		refraction_strength = 0.3,
		lens_distortion = 0.25,
		chromatic_aberration = 0.08,
		fresnel_strength = 0.5,
		specular_strength = 0.8,
		edge_thickness = 0.06,
		tint_color = 0xffffff10,

		dark = {
			tint_color = 0x0b0d1428,
			brightness = 0.95,
			contrast = 1.0,
			saturation = 0.95,
			vibrancy = 0.25,
			adaptive_dim = 0.25,
		},
		light = {
			brightness = 1.1,
			contrast = 0.92,
			saturation = 0.9,
			vibrancy = 0.15,
			adaptive_boost = 0.4,
		},
	})

	hg.config({
		enabled = true,
		default_theme = "dark",
		default_preset = "liquid",
		manage_window_blur = true,

		-- Capas (waybar, rofi, dock, swaync) SIN hyprglass: con layers.enabled = true el
		-- plugin anula el blur nativo de las layer_rule (appearance.lua) y la franja de
		-- waybar queda sin difuminar (probado: mask_mode region, exclude y
		-- manage_blur = false no lo arreglan). Con false conservan su blur de siempre.
		layers = { enabled = false },
	})
end
