return {
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    init = function()
      vim.diagnostic.config({
        severity_sort = true,

        virtual_lines = false,
        virtual_text = true,
      })
    end,
    keys = {
      {
        "<leader>d",
        function()
          local virtual_lines = vim.diagnostic.config().virtual_lines
          local virtual_text = vim.diagnostic.config().virtual_text

          vim.diagnostic.config({
            virtual_lines = not virtual_lines,
            virtual_text = not virtual_text,
          })
        end,
        desc = "Toggle LSP [L]ines",
      },
    },
    config = function()
      require("lsp_lines").setup()
    end,
  },
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

        nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        nmap("<leader>gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        nmap("<leader>gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
          vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })
      end

      -- see@https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      local servers = {
        sqls = {},
        gopls = {},
        omnisharp = {},
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
        vimls = {},
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
