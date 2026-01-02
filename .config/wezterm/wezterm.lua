local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.term = "wezterm"
config.front_end = "WebGpu"
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.font = wezterm.font({ family = "Hack Nerd Font" })
config.font_size = 13.0
config.dpi = 192.0
config.window_padding = {
  left = '0cell',
  right = '0cell',
  top = '0cell',
  bottom = '0',
}

local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Tokyo Night"
  else
    return "Catppuccin Latte"
  end
end

wezterm.on("window-config-reloaded", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local scheme = scheme_for_appearance(window:get_appearance())

  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    overrides.set_environment_variables = {
      TERM_COLOR_SCHEME = overrides.color_scheme,
    }

    window:set_config_overrides(overrides)
  end
end)

return config
