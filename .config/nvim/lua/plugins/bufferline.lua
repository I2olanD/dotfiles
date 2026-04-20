local mocha = require("catppuccin.palettes").get_palette("mocha")

require("bufferline").setup({
  options = {
    separator_style = "slant",
  },
  highlights = {
    separator          = { fg = mocha.overlay0 },
    separator_selected = { fg = mocha.overlay0 },
    separator_visible  = { fg = mocha.overlay0 },
  },
})
