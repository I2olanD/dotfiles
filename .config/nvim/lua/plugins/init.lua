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

    if name == "nvim-pretty-ts-errors" and kind == "install" then
      local dir = vim.fn.stdpath("data") .. "/site/pack/core/opt/" .. name
      vim.fn.jobstart({ "npm", "install" }, { cwd = dir })
    end
  end,
})

vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-mini/mini.icons",

  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/neovim/nvim-lspconfig",

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

  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
  "https://github.com/saghen/blink.download",
  { src = "https://github.com/saghen/blink.pairs", version = vim.version.range("0.*") },
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/jlcrochet/vim-razor",

  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",

  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/folke/noice.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/rcarriga/nvim-notify",
  "https://github.com/catgoose/nvim-colorizer.lua",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  "https://github.com/kosayoda/nvim-lightbulb",

  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/folke/trouble.nvim",

  "https://github.com/kylechui/nvim-surround",
  "https://github.com/mg979/vim-visual-multi",

  "https://github.com/anuvyklack/windows.nvim",
  "https://github.com/anuvyklack/middleclass",
  "https://github.com/anuvyklack/animation.nvim",
  "https://github.com/christoomey/vim-tmux-navigator",
  "https://github.com/folke/which-key.nvim",

  "https://github.com/enochchau/nvim-pretty-ts-errors",

  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/sindrets/diffview.nvim",

  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/jay-babu/mason-nvim-dap.nvim",

  "https://github.com/SmiteshP/nvim-navic",
  "https://github.com/utilyre/barbecue.nvim",

  "https://github.com/stevearc/aerial.nvim",
  "https://github.com/rmagatti/goto-preview",
  "https://github.com/rmagatti/logger.nvim",
  "https://github.com/VidocqH/lsp-lens.nvim",
  "https://github.com/smjonas/inc-rename.nvim",
})

require("plugins.colorscheme")
require("plugins.oil")
require("plugins.lsp")
require("plugins.lualine")

vim.schedule(function()
  require("plugins.treesitter")
  require("plugins.bufferline")
  require("plugins.indent-blankline")
  require("plugins.conform")
  require("plugins.lint")
  require("plugins.noice")
  require("plugins.windows")
  require("which-key").setup()
  require("nvim-surround").setup()
  require("fzf-lua").setup()
  require("trouble").setup()
  require("colorizer").setup()
  require("plugins.git")
  require("plugins.aerial")
  require("plugins.dap")
  require("barbecue").setup()
end)

vim.api.nvim_create_autocmd("LspAttach", {
  once = true,
  callback = function()
    require("plugins.lightbulb")
    require("lsp-lens").setup()
    require("goto-preview").setup()
    require("inc_rename").setup()
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    require("plugins.blink")
    require("blink.pairs").setup({
      mappings = { enabled = true },
      highlights = { enabled = true, matchparen = { enabled = true } },
    })
  end,
})
