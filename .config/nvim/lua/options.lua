-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.termguicolors = true

vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.timeoutlen = 500
vim.opt.fileencoding = "utf-8"

-- line wrap
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- autowrite
vim.opt.autowrite = true
vim.opt.updatetime = 500

-- turn of swapfiles
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false
