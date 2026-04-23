local M = {}

local map = vim.keymap.set

-- ============================================================================
-- HELP (Which-key)
-- ============================================================================

map("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Show buffer local keymaps" })

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
-- GIT (Gitsigns + Diffview)
-- ============================================================================

map("n", "]h", function()
  require("gitsigns").nav_hunk("next")
end, { desc = "Next hunk" })
map("n", "[h", function()
  require("gitsigns").nav_hunk("prev")
end, { desc = "Prev hunk" })
map("n", "<leader>hs", function()
  require("gitsigns").stage_hunk()
end, { desc = "Stage hunk" })
map("n", "<leader>hr", function()
  require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })
map("v", "<leader>hs", function()
  require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Stage selected" })
map("v", "<leader>hr", function()
  require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Reset selected" })
map("n", "<leader>hS", function()
  require("gitsigns").stage_buffer()
end, { desc = "Stage buffer" })
map("n", "<leader>hp", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })
map("n", "<leader>hb", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "Toggle blame" })
map("n", "<leader>hd", function()
  require("gitsigns").diffthis()
end, { desc = "Diff this" })

map("n", "<leader>hv", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" })
map("n", "<leader>hq", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })
map("n", "<leader>hf", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview file history" })

-- ============================================================================
-- SYMBOLS (Aerial)
-- ============================================================================

map("n", "<leader>sa", "<cmd>AerialToggle<cr>", { desc = "Toggle symbol outline" })
map("n", "<leader>ss", function()
  require("fzf-lua").lsp_document_symbols()
end, { desc = "Search symbols" })

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
  map({ "n", "v" }, "<leader>k", function()
    vim.lsp.buf.code_action({
      filter = function(a)
        return not a.disabled
      end,
    })
  end, opts("Code action"))

  map("n", "gpt", function()
    require("goto-preview").goto_preview_definition()
  end, opts("Peek definition"))
  map("n", "gpi", function()
    require("goto-preview").goto_preview_implementation()
  end, opts("Peek implementation"))
  map("n", "gpr", function()
    require("goto-preview").goto_preview_references()
  end, opts("Peek references"))
  map("n", "gP", function()
    require("goto-preview").close_all_win()
  end, opts("Close all previews"))

  map("n", "<leader>rn", function()
    return ":IncRename " .. vim.fn.expand("<cword>")
  end, { buffer = bufnr, desc = "Rename symbol", expr = true })

  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    require("conform").format({ lsp_fallback = true, async = true, timeout = 500 })
  end, { desc = "Format current buffer" })
end

-- ============================================================================
-- Undo Tree
-- ============================================================================

map("n", "<leader>U", vim.cmd.UndotreeToggle)

return M
