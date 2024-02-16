return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-treesitter/nvim-treesitter",
    "sharkdp/fd",
    "BurntSushi/ripgrep",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },

  cmd = "Telescope",
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
          width = 0.8,
          height = 0.8,
        },
        path_display = { "truncate" },
        dynamic_preview_title = true,
        mappings = {
          n = {
            ["q"] = "close",
          },
          i = {
            ["<C-h>"] = "which_key",
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")
    telescope.load_extension("ui-select")
  end,
}
