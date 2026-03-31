vim.treesitter.language.register("typescript", "javascript")

require("nvim-treesitter").setup({
  ensure_installed = {
    "bash",
    "html",
    "lua",
    "markdown",
    "markdown_inline",
    "regex",
    "svelte",
    "toml",
    "tsx",
    "typescript",
  },
  auto_install = true,
  ignore_install = { "javascript" },
})
