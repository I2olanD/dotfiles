require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

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
