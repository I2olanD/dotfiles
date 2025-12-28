return {
  "mfussenegger/nvim-lint",
  event = { "BufWritePost", "BufReadPost", "InsertLeave" },
  config = function()
    require("lint").linters_by_ft = {
      lua = { "luacheck" },
      json = { "jsonlint" },
      javascript = { "eslint" },
      typescript = { "eslint" },
      javascriptreact = { "eslint" },
      typescriptreact = { "eslint" },
      sql = { "sqlfluff" },
      svelte = { "eslint" },
    }
  end,
}
