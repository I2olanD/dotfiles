local ensure_installed = {
  "bash",
  "html",
  "javascript",
  "lua",
  "markdown",
  "markdown_inline",
  "regex",
  "scala",
  "svelte",
  "toml",
  "vue",
  "tsx",
  "typescript",
}

local installed = require("nvim-treesitter.config").get_installed()
local missing = vim
  .iter(ensure_installed)
  :filter(function(parser)
    return not vim.tbl_contains(installed, parser)
  end)
  :totable()

if #missing > 0 then
  require("nvim-treesitter").install(missing)
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)

    -- https://github.com/nvim-treesitter/nvim-treesitter#indentation
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require("nvim-ts-autotag").setup({
  opts = {
    enable_close_on_slash = false,
  },
})
