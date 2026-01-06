local M = {}

local map = vim.keymap.set

-- ============================================================================
-- VIM CORE
-- ============================================================================

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected line(s) down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected line(s) up" })

map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking selection" })

-- ============================================================================
-- FILE NAVIGATION (FZF)
-- ============================================================================

map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "List buffers" })
map("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>", { desc = "Search help tags" })

-- ============================================================================
-- FILE EXPLORER (Oil)
-- ============================================================================

map("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open Oil at current file" })
map("n", "<leader>E", "<CMD>Oil .<CR>", { desc = "Open Oil at cwd" })

-- ============================================================================
-- BUFFER MANAGEMENT (Bufferline)
-- ============================================================================

map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New empty buffer" })
map("n", "<leader>bc", "<cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<left>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Go to previous buffer" })
map("n", "<right>", "<cmd>BufferLineCycleNext<CR>", { desc = "Go to next buffer" })
map("n", "<up>", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close all other buffers" })

-- ============================================================================
-- WINDOW MANAGEMENT
-- ============================================================================

map("n", "<C-m>", ":WindowsMaximize<CR>", { desc = "Maximize window" })

-- ============================================================================
-- DIAGNOSTICS (Trouble)
-- ============================================================================

map("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle diagnostics panel" })

-- ============================================================================
-- FORMATTING (Conform)
-- ============================================================================

map({ "n", "v" }, "<leader>mp", function()
  require("conform").format({
    lsp_fallback = true,
    async = true,
    timeout = 500,
  })
end, { desc = "Format file" })

-- ============================================================================
-- MULTI-CURSOR (vim-visual-multi)
-- ============================================================================

map({ "n", "v" }, "<C-n>", "<Plug>(VM-Find-Under)", { desc = "Add cursor at word" })
map({ "n", "v" }, "<C-Up>", "<Plug>(VM-Add-Cursor-Up)", { desc = "Add cursor up" })
map({ "n", "v" }, "<C-Down>", "<Plug>(VM-Add-Cursor-Down)", { desc = "Add cursor down" })

-- ============================================================================
-- HELP (Which-key)
-- ============================================================================

map("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Show buffer local keymaps" })

-- ============================================================================
-- LSP (buffer-local keymaps)
-- ============================================================================

function M.on_attach(_, bufnr)
  local opts = function(desc)
    return { buffer = bufnr, desc = desc }
  end

  map("n", "<leader>gD", vim.lsp.buf.declaration, opts("Go to declaration"))
  map("n", "<leader>gd", vim.lsp.buf.definition, opts("Go to definition"))
  map("n", "<leader>gi", vim.lsp.buf.implementation, opts("Go to implementation"))
  map("n", "<leader>k", vim.lsp.buf.code_action, opts("Code action"))

  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

return M
