local map = vim.keymap.set

-- TMUX window navigation
map("n", "<c-h>", "<cmd> TmuxNavigationLeft<CR>", { desc = "window left" })
map("n", "<c-l>", "<cmd> TmuxNavigationRight<CR>", { desc = "window right" })
map("n", "<c-j>", "<cmd> TmuxNavigationDown<CR>", { desc = "window down" })
map("n", "<c-k>", "<cmd> TmuxNavigationUp<CR>", { desc = "window up" })

-- Diagnostic
-- map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

-- Windows
map("n", "<C-m>", ":WindowsMaximize<CR>", { silent = true, desc = "[M]aximize current buffer" })

-- Telescope
map("n", "<leader>ff", "<CMD> Telescope find_files <CR>", { silent = true, desc = "[F]ind [F]iles" })
map("n", "<leader>fg", "<CMD> Telescope live_grep <CR>", { silent = true, desc = "[F]find by [G]rep" })
map("n", "<leader>fb", "<CMD> Telescope buffers <CR>", { silent = true, desc = "[F]ind [B]uffers" })
map("n", "<leader>fe", "<CMD> Telescope file_browser <CR>", { silent = true, desc = "[F]ile [E]xplorer" })

-- Neotree
map("n", "<leader>e", "<CMD>Neotree reveal<CR>", { silent = true, desc = "File [E]xplorer" })
map("n", "<leader>q", "<CMD>Neotree toggle<CR>", { silent = true, desc = "File [E]xplorer toggle" })
