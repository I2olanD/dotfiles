return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "onsails/lspkind.nvim",

      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",

      "saadparwaiz1/cmp_luasnip",

      {
        "L3MON4D3/LuaSnip",
      },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require('lspkind')

      local function is_visible(cmp)
        return cmp.core.view:visible() or vim.fn.pumvisible() == 1
      end

      cmp.setup({
        preselect = cmp.PreselectMode.None, -- cmp.PreselectMode.Item,

        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },

        completion = {
          completeopt = "menuone,noinsert,noselect",
        },

        mapping = cmp.mapping.preset.insert({
          -- select previous/next item
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-h>"] = cmp.mapping.abort(),
          ["<C-l>"] = cmp.mapping.confirm(),

          -- scroll the documentation forward / backwards
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),

          -- Manually trigger a completion from nvim-cmp
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

          ["<CR>"] = cmp.mapping({
            i = function(fallback)
              if is_visible(cmp) and cmp.get_active_entry() then
                cmp.confirm()
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm(),
          }),
        }),

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        formatting = {
          -- fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
            -- symbol_map = { Codeium = "" },
          }),
        },

        sources = cmp.config.sources({
          -- { name = "codeium", priority = 1200 },
          { name = "nvim_lsp_signature_help" }, -- display function signatures with current parameter emphasized
          { name = "nvim_lsp" },                -- from language server
          { name = "nvim_lua" },                -- complete neovim's Lua runtime API such vim.lsp.*
          { name = "luasnip" },
          { name = "buffer" },                  -- source current buffer
          { name = "path" },                    -- file paths
          -- { name = "calc" }, -- source for math calculation
        }),

        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },

        window = {
          completion = {
            border = "none",
            side_padding = 0,
            scrollbar = false,
            winhighlight = "Normal:Pmenu,CursorLine:PmenuSel",
          },
          documentation = {
            border = "none",
            winhighlight = "Normal:Pmenu",
          },
        },

        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
      })
    end,
  },
}
