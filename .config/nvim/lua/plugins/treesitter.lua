return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "jlcrochet/vim-razor",
    },
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.treesitter.language.register("typescript", "javascript")
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
          "bash",

          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",

          "css",
          "scss",

          "html",
          "javascript",
          "typescript",

          "json",

          "python",

          "dockerfile",

          "go",

          "lua",

          "markdown",
          "markdown_inline",

          "toml",

          "terraform",

          "yaml",
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_selection = false,
            node_decremental = "<bs>",
          },
        },
        additional_vim_regex_highlighting = false,
      })
    end,
  },
}
