return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },

        css = { "prettier" },
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
