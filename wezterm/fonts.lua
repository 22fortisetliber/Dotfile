local wezterm = require("wezterm")

local module = {}

function module.setup(config)
    config.font = wezterm.font_with_fallback({ "JetBrains Mono"}, { weight = 'Medium' })
    config.font_size = 11
    config.underline_thickness = "100%"
    config.underline_position = "-3pt"
    config.freetype_load_target = 'Normal'
    config.freetype_render_target = 'Normal'
end

return module

