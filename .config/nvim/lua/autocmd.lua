local yank_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

-- Yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = yank_group,
  pattern = "*",
})

-- removes trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})
