local map = vim.keymap.set

-- TMUX window navigation
map("n", "<c-h>", "<cmd> TmuxNavigationLeft <CR>", { desc = "window left" })
map("n", "<c-l>", "<cmd> TmuxNavigationRight <CR>", { desc = "window right" })
map("n", "<c-j>", "<cmd> TmuxNavigationDown <CR>", { desc = "window down" })
map("n", "<c-k>", "<cmd> TmuxNavigationUp <CR>", { desc = "window up" })

-- Windows
map("n", "<C-m>", ":WindowsMaximize<CR>", { silent = true, desc = "[M]aximize current buffer" })

-- Telescope
map("n", "<leader>ff", "<CMD> Telescope find_files <CR>", { silent = true, desc = "[F]ind [F]iles" })
map("n", "<leader>fb", "<CMD> Telescope file_browser <CR>", { silent = true, desc = "[F]File [B]rowser" })
map("n", "<leader>fc", "<CMD> Telescope file_browser path=%:p:h <CR>", { silent = true, desc = "[F]File [C]urrent Path" })
map("n", "<leader>fg", "<CMD> Telescope live_grep <CR>", { silent = true, desc = "[F]find by [G]rep" })
map("n", "<leader>lb", "<CMD> Telescope buffers <CR>", { silent = true, desc = "[L]ist [B]uffers" })

-- Shift lines
map("v", "J", ":m '>+1<CR>gv-gv", { desc = "Move selected line(s) up" })
map("v", "K", ":m '<-2<CR>gv-gv", { desc = "Move selected line(s) down" })

-- Trouble
map("n", "<leader>tt", "<cmd>TroubleToggle<CR>", { desc = "[T]oggle [T]rouble" })

-- Replace in place
map("x", "<leader>p", [["_dP]], { desc = "Replace in word" })

-- Noice
--
map("n", "<leader>ne", "<CMD>Noice errors<CR>", { desc = "[N]oice [E]errors" })
map("n", "<leader>nl", "<CMD>Noice last<CR>", { desc = "[N]oice [L]ast" })
map("n", "<leader>nh", "<CMD>Noice history<CR>", { desc = "[N]oice [H]istory" })
