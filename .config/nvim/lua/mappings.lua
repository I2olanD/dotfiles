local map = vim.keymap.set
-- VIM
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Windows
map("n", "<C-m>", ":WindowsMaximize<CR>", { silent = true, desc = "[M]aximize current buffer" })

-- Buffers
map("n", "<left>", "<CMD>BufferLineCyclePrev<CR>", { desc = "Goto left buffer", silent = true })
map("n", "<right>", "<CMD>BufferLineCycleNext<CR>", { desc = "Goto right buffer", silent = true })
map("n", "<up>", "<CMD>BufferLineCloseOthers<CR>", { desc = "Close all other buffers", silent = true })

-- Telescope
map("n", "<leader>ff", "<CMD>Telescope find_files<CR>", { silent = true, desc = "[F]ind [F]iles" })
map("n", "<leader>fb", "<CMD>Telescope file_browser<CR>", { silent = true, desc = "[F]File [B]rowser" })
map("n", "<leader>fc", "<CMD>Telescope file_browser path=%:p:h<CR>", { silent = true, desc = "[F]File [C]urrent Path" })
map("n", "<leader>fg", "<CMD>Telescope live_grep<CR>", { silent = true, desc = "[F]find by [G]rep" })
map("n", "<leader>lb", "<CMD>Telescope buffers<CR>", { silent = true, desc = "[L]ist [B]uffers" })

-- NeoTree
map("n", "<leader>e", ":Neotree toggle<CR>", { silent = true, desc = "[E]xplore" })

-- Shift lines
map("v", "J", ":m '>+1<CR>gv-gv", { desc = "Move selected line(s) up" })
map("v", "K", ":m '<-2<CR>gv-gv", { desc = "Move selected line(s) down" })

-- Trouble
map("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<CR>", { desc = "[T]oggle [T]rouble" })

-- Replace in place
map("x", "<leader>p", [["_dP]], { desc = "Replace in word" })
