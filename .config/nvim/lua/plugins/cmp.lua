local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

local function is_visible(cmp)
  return cmp.core.view:visible() or vim.fn.pumvisible() == 1
end

cmp.setup({
  preselect = cmp.PreselectMode.None,

  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },

  completion = {
    completeopt = "menuone,noinsert,noselect",
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-h>"] = cmp.mapping.abort(),
    ["<C-l>"] = cmp.mapping.confirm(),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
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
    format = lspkind.cmp_format({
      mode = "symbol",
      maxwidth = 50,
      ellipsis_char = "...",
    }),
  },

  sources = cmp.config.sources({
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
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
      border = "single",
      side_padding = 1,
      scrollbar = false,
      winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder",
      col_offset = 0,
      row_offset = -3,
    },
    documentation = {
      border = "single",
      winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder",
    },
  },

  experimental = {
    ghost_text = {
      hl_group = "CmpGhostText",
    },
  },
})
