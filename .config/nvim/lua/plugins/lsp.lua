return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "hrsh7th/cmp-nvim-lsp",

      "jay-babu/mason-null-ls.nvim",
      "nvimtools/none-ls.nvim",
    },

    config = function()
      require("mason").setup()

      local on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end

          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        nmap("<leader>fn", vim.lsp.buf.rename, "[R]e[n]ame")
        nmap("<leader>fd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        nmap("<leader>fr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
          vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })
      end

      local servers = {
        sqls = {},
        gopls = {},
        eslint = {
          packageManager = "yarn",
          workingDirectories = {
            { pattern = "./packages/*" },
          },
        },
        tsserver = { filetypes = { "typescript", "typescriptreact", "typescript.tsx" } },
        html = { filetypes = { "html", "twig", "hbs" } },
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim" } },
          },
        },
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),

        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              on_attach = on_attach,
              settings = servers[server_name],
              filetypes = (servers[server_name] or {}).filetypes,
            })
          end,
        },
      })

      require("mason-null-ls").setup({
        ensure_installed = { "sqlfmt", "stylua", "prettier", "goimports", "gofumpt", "yamlfmt" },
      })

      require("null-ls").setup({})
    end,
  },
}
