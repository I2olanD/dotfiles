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
      "vue"
    },
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = "/Users/rolandolah/.nvm/versions/node/v20.19.0/lib/node_modules/@vue/language-server",
          languages = { "typescript", "vue" },
        },
      },
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
    }
  },

  gopls = {}
}

local on_attach = function(_, bufnr)
  vim.keymap.set("n", "<leader>gd", function()
    vim.lsp.buf.declaration()
  end, { buffer = bufnr, desc = "[g]o to [d]eclaration" })
  vim.keymap.set("n", "<leader>gd", function()
    vim.lsp.buf.definition()
  end, { buffer = bufnr, desc = "[g]o to [d]efinition" })
  vim.keymap.set("n", "<leader>gi", function()
    vim.lsp.buf.implementation()
  end, { buffer = bufnr, desc = "[g]o to [i]mplementation" })
  vim.keymap.set("n", "<leader>k", function()
    vim.lsp.buf.code_action()
  end, { buffer = bufnr, desc = "[c]ode action" })
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "format current buffer with lsp" })
end

return {
  {
    "mason-org/mason.nvim",
    -- event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      for server_name, server_config in pairs(servers) do
        local config = vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          capabilities = capabilities,
          settings = servers[server_name].settings or {},
          filetypes = servers[server_name].filetypes or {},
          init_options = servers[server_name].init_options or {},
        }, server_config)

        vim.lsp.config(server_name, config)
      end

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
      })
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettier",
          "jsonlint",
          "sqlfluff",
          "luacheck",
          "gofumpt",
          "goimports",
          "htmlhint"
        },
      })
    end,
  },
}
