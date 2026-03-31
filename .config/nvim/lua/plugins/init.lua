-- Build hooks (must be registered before vim.pack.add)
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind

    if name == "nvim-treesitter" and kind ~= "delete" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end

    if name == "nvim-pretty-ts-errors" and kind == "install" then
      local dir = vim.fn.stdpath("data") .. "/site/pack/core/opt/" .. name
      vim.fn.jobstart({ "npm", "install" }, { cwd = dir })
    end
  end,
})

-- Install and load all plugins
vim.pack.add({
  -- Colorscheme
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

  -- Icons
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-mini/mini.icons",

  -- LSP & Tools
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/neovim/nvim-lspconfig",

  -- Completion
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/onsails/lspkind.nvim",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-path",
  "https://github.com/hrsh7th/cmp-cmdline",
  "https://github.com/hrsh7th/cmp-nvim-lua",
  "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help",
  "https://github.com/saadparwaiz1/cmp_luasnip",
  "https://github.com/L3MON4D3/LuaSnip",

  -- Treesitter
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/jlcrochet/vim-razor",

  -- Formatting & Linting
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",

  -- UI
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/folke/noice.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/norcalli/nvim-colorizer.lua",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  "https://github.com/kosayoda/nvim-lightbulb",

  -- Navigation
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/folke/trouble.nvim",

  -- Editing
  "https://github.com/kylechui/nvim-surround",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/mg979/vim-visual-multi",

  -- Windows & Navigation
  "https://github.com/anuvyklack/windows.nvim",
  "https://github.com/anuvyklack/middleclass",
  "https://github.com/anuvyklack/animation.nvim",
  "https://github.com/christoomey/vim-tmux-navigator",
  "https://github.com/folke/which-key.nvim",

  -- TypeScript
  "https://github.com/enochchau/nvim-pretty-ts-errors",
})

-- ============================================================================
-- IMMEDIATE SETUP
-- ============================================================================

require("plugins.colorscheme")
require("plugins.oil")
require("plugins.lsp")
require("plugins.lualine")
require("plugins.lightbulb")
require("plugins.treesitter")
require("plugins.bufferline")
require("plugins.indent-blankline")
require("plugins.conform")
require("plugins.lint")

-- ============================================================================
-- DEFERRED SETUP
-- ============================================================================

vim.schedule(function()
  require("plugins.noice")
  require("plugins.windows")
  require("which-key").setup()
  require("nvim-surround").setup()
  require("fzf-lua").setup()
  require("trouble").setup()
  require("colorizer").setup()
end)

-- ============================================================================
-- INSERT MODE SETUP
-- ============================================================================

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    require("plugins.cmp")
    require("nvim-autopairs").setup()
  end,
})
