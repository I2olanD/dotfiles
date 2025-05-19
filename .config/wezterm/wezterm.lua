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

-- Font
--
-- @see https://wezfurlong.org/wezterm/config/lua/config/font_rules.html
config.font = wezterm.font({ family = "Hack Nerd Font", scale = 1.6 })

-- Colorscheme
--
-- @see https://wezfurlong.org/wezterm/config/lua/wezterm.gui/get_appearance.html
local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Tokyo Night"
    -- return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

-- Terminal
--
-- @see https://wezterm.org/config/lua/config/window_padding.html
-- config.window_padding = {
--   left = 0,
--   right = 0,
--   top = 0,
--   bottom = 0,
-- }

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

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

return config
