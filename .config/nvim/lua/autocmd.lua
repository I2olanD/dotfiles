local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
local custom_group = vim.api.nvim_create_augroup("custom", { clear = true })

local function attach(opts)
  vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "<leader>h", function() vim.lsp.buf.hover() end, opts)
end

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(e)
    local opts = { buffer = e.buf }
    attach(opts)
  end,
  group = custom_group,
  pattern = "*",
})
