vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind

    if name == "nvim-treesitter" and kind ~= "delete" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      require("nvim-treesitter").update()
    end
  end,
})

vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },

  "https://github.com/akinsho/bufferline.nvim",

  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

  "https://github.com/stevearc/conform.nvim",

  "https://github.com/lewis6991/gitsigns.nvim",

  "https://github.com/sindrets/diffview.nvim",

  "https://github.com/lukas-reineke/indent-blankline.nvim",

  "https://github.com/mfussenegger/nvim-lint",

  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/neovim/nvim-lspconfig",

  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/scalameta/nvim-metals",

  "https://github.com/nvim-lualine/lualine.nvim",

  "https://github.com/stevearc/oil.nvim",

  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

  "https://github.com/anuvyklack/windows.nvim",

  "https://github.com/nvim-mini/mini.icons",

  "https://github.com/L3MON4D3/LuaSnip",

  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/jlcrochet/vim-razor",

  "https://github.com/catgoose/nvim-colorizer.lua",

  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/folke/trouble.nvim",

  "https://github.com/kylechui/nvim-surround",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/mg979/vim-visual-multi",

  "https://github.com/anuvyklack/middleclass",
  "https://github.com/anuvyklack/animation.nvim",
  "https://github.com/christoomey/vim-tmux-navigator",
  "https://github.com/folke/which-key.nvim",

  "https://github.com/SmiteshP/nvim-navic",
  "https://github.com/utilyre/barbecue.nvim",

  "https://github.com/rmagatti/goto-preview",
  "https://github.com/rmagatti/logger.nvim",
  "https://github.com/VidocqH/lsp-lens.nvim",
  "https://github.com/smjonas/inc-rename.nvim",

  "https://github.com/mbbill/undotree",

  "https://github.com/stevearc/aerial.nvim",
})

-- Eager: needed at startup
require("plugins.colorscheme")
require("plugins.oil")
require("plugins.lsp")
require("plugins.lualine")

-- Deferred to first idle tick
vim.schedule(function()
  require("plugins.treesitter")
  require("plugins.bufferline")
  require("plugins.indent-blankline")
  require("plugins.conform")
  require("plugins.lint")
  require("plugins.metals")
  require("plugins.windows")
  require("plugins.which-key")
  require("plugins.nvim-surround")
  require("plugins.fzf-lua")
  require("plugins.trouble")
  require("plugins.colorizer")
  require("plugins.barbecue")
  require("plugins.aerial")
  require("plugins.git")
end)

-- Deferred to first LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
  once = true,
  callback = function()
    require("plugins.lsp-lens")
    require("plugins.goto-preview")
    require("plugins.inc-rename")
  end,
})

-- Deferred to first insert mode entry
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    require("plugins.blink")
    require("plugins.autopairs")
  end,
})
