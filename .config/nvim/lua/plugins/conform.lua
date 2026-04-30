local toolchain = require("utils.js_toolchain")

local function js_formatter(bufnr)
  return { toolchain.resolve(bufnr, vim.bo[bufnr].filetype).formatter }
end

require("conform").setup({
  formatters_by_ft = {
    javascript = js_formatter,
    typescript = js_formatter,
    javascriptreact = js_formatter,
    typescriptreact = js_formatter,
    json = js_formatter,
    jsonc = js_formatter,
    css = js_formatter,
    vue = js_formatter,
    scss = js_formatter,
    sass = js_formatter,
    html = js_formatter,

    markdown = { "prettier" },

    lua = { "stylua" },

    go = { "goimports", "gofumpt" },

    yaml = { "yamlfmt" },

    sql = { "sqlfmt" },

    scala = { "scalafmt" },
    sbt = { "scalafmt" },
  },

  formatters = {
    biome = {
      cwd = function(_, ctx)
        return toolchain.biome_root(ctx.buf) or vim.fn.getcwd()
      end,
    },
  },

  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 500,
    quiet = true,
  },
})
