local lint_group = vim.api.nvim_create_augroup("Lint", { clear = true })
local yank_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

-- Yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = yank_group,
  pattern = "*",
})

-- Linting
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    require("lint").try_lint()
  end,
  group = lint_group,
})

-- removes trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    local stats = require("lazy").stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
    vim.notify(
      "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms",
      vim.log.levels.INFO,
      { title = "Startup Time" }
    )
  end,
})
