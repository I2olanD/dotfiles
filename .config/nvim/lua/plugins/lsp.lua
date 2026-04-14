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
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local function on_attach(client, bufnr)
  keymaps.on_attach(client, bufnr)

  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

for server_name, server_config in pairs(servers) do
  vim.lsp.config(server_name, vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
  }, server_config))
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
