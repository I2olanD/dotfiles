local keymaps = require("keymaps")

local servers = {
  html = {},

  svelte = {
    filetypes = {
      "svelte",
    },
  },

  ts_ls = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
    },
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = vim.fn.stdpath("data")
            .. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin",
          languages = { "vue" },
        },
      },
    },
  },

  vue_ls = {
    filetypes = {
      "vue",
    },
  },

  lua_ls = {
    filetypes = { "lua" },
    settings = {
      Lua = {
        workspace = { checkthirdparty = false },
        telemetry = { enable = false },
        diagnostics = { globals = { "vim" } },
      },
    },
  },

  gopls = {},
}

local capabilities = require("blink.cmp").get_lsp_capabilities()

local function on_attach(client, bufnr)
  keymaps.on_attach(client, bufnr)

  if client.server_capabilities.documentSymbolProvider then
    vim.g.navic_silence = true
    require("nvim-navic").attach(client, bufnr)
  end

  if client:supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

for server_name, server_config in pairs(servers) do
  vim.lsp.config(
    server_name,
    vim.tbl_deep_extend("force", {
      on_attach = on_attach,
      capabilities = capabilities,
    }, server_config)
  )
end

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
})
require("mason-tool-installer").setup({
  ensure_installed = {
    "biome",
    "prettier",
    "jsonlint",
    "sqlfluff",
    "luacheck",
    "gofumpt",
    "goimports",
    "htmlhint",
    "stylua",
  },
})
