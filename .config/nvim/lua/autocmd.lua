local yank_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
local trim_group = vim.api.nvim_create_augroup("TrimWhitespace", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
  group = yank_group,
  pattern = "*",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = trim_group,
  callback = function()
    if not vim.bo.modifiable or vim.bo.binary then
      return
    end
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  once = true,
  callback = function()
    require("lsp-lens").setup()
    require("goto-preview").setup()
    require("inc_rename").setup()
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    require("plugins.blink")
    require("nvim-autopairs").setup()
  end,
})
