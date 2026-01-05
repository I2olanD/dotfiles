return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    keymaps = {
      ["q"] = "actions.close",
      ["<Esc>"] = "actions.close",
    },
  },
  keys = {
    { "<leader>e", "<CMD>Oil<CR>",   desc = "Open Oil at current file" },
    { "<leader>E", "<CMD>Oil .<CR>", desc = "Open Oil at cwd" },
  },
  -- Optional dependencies
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
