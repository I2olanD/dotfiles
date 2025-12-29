return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "biome", "prettier", stop_after_first = true },
        typescript = { "biome", "prettier", stop_after_first = true },
        javascriptreact = { "biome", "prettier", stop_after_first = true },
        typescriptreact = { "biome", "prettier", stop_after_first = true },
        json = { "biome", "prettier", stop_after_first = true },
        jsonc = { "biome", "prettier", stop_after_first = true },

        css = { "biome", "prettier", stop_after_first = true },
        scss = { "prettier" },
        sass = { "prettier" },

        html = { "prettier" },

        lua = { "stylua" },

        markdown = { "prettier" },

        go = { "goimports", "gofumpt" },

        yaml = { "yamlfmt" },

        sql = { "sqlfmt" },
      },

      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = true,
        timeout = 500,
      })
    end, { desc = "Format file" })
  end,
}
