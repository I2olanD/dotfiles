return {
  "mfussenegger/nvim-lint",
  event = { "BufWritePost", "BufReadPost", "InsertLeave" },
  config = function(_, opts)
    local lint = require("lint")

    local linters = {
      lua = { "luacheck" },
      json = { "jsonlint" },
      javascript = { "eslint" },
      typescript = { "eslint" },
      javascriptreact = { "eslint" },
      typescriptreact = { "eslint" },
      sql = { "sqlfluff" },
      svelte = { "eslint" }
    }

    lint.linters_by_ft = vim.tbl_deep_extend("force", linters, opts.linters_by_ft or {})
  end,
}
