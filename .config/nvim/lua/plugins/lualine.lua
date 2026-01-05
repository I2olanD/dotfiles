local linter_utils = require("utils.linter")

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "catppuccin-latte"
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { linter_utils.current_linters, 'lsp_status' },
        lualine_z = { 'location' },
      },
    },
  },
}
