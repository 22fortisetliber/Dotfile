local wezterm = require("wezterm")

local module = {}

function module.setup(config)
    config.font = wezterm.font_with_fallback({ "CodeNewRoman Nerd Font Mono"}, { weight = 'Medium' })
    config.font_size = 12
    config.underline_thickness = "200%"
    config.underline_position = "-3pt"
end

return module

