-- require("ltokyonight").setup({
--   lazy = false,
--   priority = 1000,
--   opts = {},
-- })

require("tokyonight").setup({
  transparent = true,
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
})

vim.cmd.colorscheme("tokyonight-night")

-- require("catppuccin").setup({
--   flavour = "mocha",
--   transparent_background = true,
--   styles = {
--     comments = { "italic" },
--     keywords = { "italic" },
--   },
--   integrations = {
--     treesitter = true,
--     native_lsp = { enabled = true },
--   },
-- })
--
-- vim.cmd.colorscheme("catppuccin-mocha")
