local servers = {
  omnisharp = {},
  tsserver = { filetypes = { "typescript", "typescriptreact", "typescript.tsx" } },
  gopls = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { "vim" } }
    }
  }
}

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)


            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              settings = servers[server_name],
              filetypes = (servers[server_name] or {}).filetypes,
            })
          end
        }
      })
    end
  }
}
