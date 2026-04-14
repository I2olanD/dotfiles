require("aerial").setup({
  backends = { "treesitter", "lsp" },
  layout = {
    min_width = 30,
  },
  filter_kind = false,
})
