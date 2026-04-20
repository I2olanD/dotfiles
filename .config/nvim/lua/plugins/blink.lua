vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#313244" })
vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = "#89b4fa", bg = "#313244" })

require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-h>"] = { "hide", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    list = { selection = { preselect = true, auto_insert = false } },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = {
        border = "single",
        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
      },
    },
    menu = { border = "single" },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  snippets = { preset = "luasnip" },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  signature = { enabled = true },
})
