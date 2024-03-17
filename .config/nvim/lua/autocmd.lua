local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
local custom_group = vim.api.nvim_create_augroup("custom", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})
