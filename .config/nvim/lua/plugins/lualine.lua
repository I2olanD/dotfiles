local linter_utils = require("utils.linter")
local formatter_utils = require("utils.formatter")

require("lualine").setup({
  options = {
    theme = "catppuccin-latte",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { formatter_utils.current_formatters, linter_utils.current_linters, "lsp_status" },
    lualine_z = { "location" },
  },
})
