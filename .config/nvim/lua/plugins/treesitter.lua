vim.treesitter.language.register("typescript", "javascript")

local ensure_installed = {
  "bash",
  "html",
  "lua",
  "markdown",
  "markdown_inline",
  "regex",
  "svelte",
  "toml",
  "vue",
  "tsx",
  "typescript",
}

local installed = require("nvim-treesitter.config").get_installed()
local missing = vim.iter(ensure_installed)
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
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
