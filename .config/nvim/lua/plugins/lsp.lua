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

local on_attach = function(_, bufnr)
  vim.keymap.set("n", "<leader>gD", function() vim.lsp.buf.declaration() end,
    { buffer = bufnr, desc = "[G]o to [D]eclaration" })
  vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end,
    { buffer = bufnr, desc = "[G]o to [D]efinition" })
  vim.keymap.set("n", "<leader>gi", function() vim.lsp.buf.implementation() end,
    { buffer = bufnr, desc = "[G]o to [I]mplementation" })
  vim.keymap.set("n", "<leader>k", function() vim.lsp.buf.code_action() end,
    { buffer = bufnr, desc = "[C]ode action" })

  vim.api.nvim_buf_create_user_command(
    bufnr,
    "Format",
    function(_) vim.lsp.buf.format() end,
    { desc = "Format current buffer with LSP" })
end

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
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
              on_attach = on_attach,
              handlers = handlers
            })

            require("lspconfig").dartls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
              handlers = handlers
            })
          end
        }
      })
    end
  }
}
