require("mini.icons").setup()

require("oil").setup({
  keymaps = {
    ["q"] = "actions.close",
    ["<Esc>"] = "actions.close",
    ["<C-h>"] = false,
    ["<C-j>"] = false,
    ["<C-k>"] = false,
    ["<C-l>"] = false,
  },
})
