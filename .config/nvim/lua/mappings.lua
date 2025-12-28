local map = vim.keymap.set
-- VIM
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Shift lines
map("v", "J", ":m '>+1<CR>gv-gv", { desc = "Move selected line(s) up" })
map("v", "K", ":m '<-2<CR>gv-gv", { desc = "Move selected line(s) down" })

-- Replace in place
map("x", "<leader>p", [["_dP]], { desc = "Replace in word" })
