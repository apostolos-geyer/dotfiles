local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.colors = require("cyberdream")

config.font_size = 20.0
config.font = wezterm.font("IosevkaTerm Nerd Font Propo")

config.macos_window_background_blur = 30

config.window_background_opacity = 0.9

config.line_height = 1.34

config.mouse_bindings = {
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
}

--- TAKEN FROM TEEJ
-- default is true, has more "native" look
config.use_fancy_tab_bar = false

-- I don't like putting anything at the ege if I can help it.
config.enable_scroll_bar = false
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.tab_bar_at_bottom = true
--- END TAKEN FROM TEEJ

return config
