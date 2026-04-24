local config = require("utils.config")

local function js_formatter(bufnr)
  if config.find_config_dir(bufnr, config.biome_configs) then
    return { "biome" }
  end
  return { "prettier" }
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
  },

  formatters = {
    biome = {
      cwd = function(_, ctx)
        return config.find_config_dir(ctx.buf, config.biome_configs) or vim.fn.getcwd()
      end,
    },
  },

  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 500,
    quiet = true,
  },
})
