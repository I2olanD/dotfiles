return {
  "mfussenegger/nvim-lint",
  event = { "BufWritePost", "BufReadPost", "InsertLeave" },
  config = function()
    local lint = require("lint")

    local function has_biome_config()
      local root = vim.fn.getcwd()
      return vim.fn.filereadable(root .. "/biome.json") == 1
        or vim.fn.filereadable(root .. "/biome.jsonc") == 1
    end

    local js_linters = has_biome_config() and { "biomejs" } or { "eslint" }

    lint.linters_by_ft = {
      lua = { "luacheck" },
      json = has_biome_config() and { "biomejs" } or { "jsonlint" },
      javascript = js_linters,
      typescript = js_linters,
      javascriptreact = js_linters,
      typescriptreact = js_linters,
      sql = { "sqlfluff" },
      svelte = js_linters,
    }
  end,
}
