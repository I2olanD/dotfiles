-- @see https://wezfurlong.org/wezterm/config/lua/general.html

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Setup
--
-- -- @see https://wezfurlong.org/wezterm/config/lua/config/term.html
config.term = "wezterm"
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.window_frame = {
  border_left_width = "5px",
  border_right_width = "5px",
  border_bottom_height = "5px",
  border_top_height = "5px",
}

-- Font
--
-- @see https://wezfurlong.org/wezterm/config/lua/config/font_rules.html
config.font = wezterm.font({ family = "Hack Nerd Font", scale = 1.6 })

-- Colorscheme
--
-- @see https://wezfurlong.org/wezterm/config/lua/wezterm.gui/get_appearance.html
local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Catppuccin Mocha"
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
