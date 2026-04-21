require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  styles = {
    comments = { "italic" },
    keywords = { "italic" },
  },
  integrations = {
    treesitter = true,
    native_lsp = { enabled = true },
  },
})

vim.cmd.colorscheme("catppuccin-mocha")
