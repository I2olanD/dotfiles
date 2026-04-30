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
