local function find_config_dir(bufnr, config_files)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == "" then
    return nil
  end

  local dir = vim.fn.fnamemodify(filepath, ":h")

  while dir ~= "/" and dir ~= "" do
    for _, config_file in ipairs(config_files) do
      if vim.fn.filereadable(dir .. "/" .. config_file) == 1 then
        return dir
      end
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end
  return nil
end

local biome_configs = { "biome.json", "biome.jsonc" }

local function js_formatter(bufnr)
  local biome_root = find_config_dir(bufnr, biome_configs)
  if biome_root then
    return { "biome" }
  end
  return { "prettier" }
end

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = js_formatter,
        typescript = js_formatter,
        javascriptreact = js_formatter,
        typescriptreact = js_formatter,
        json = js_formatter,
        jsonc = js_formatter,
        css = js_formatter,

        scss = { "prettier" },
        sass = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },

        lua = { "stylua" },

        go = { "goimports", "gofumpt" },

        yaml = { "yamlfmt" },

        sql = { "sqlfmt" },
      },

      formatters = {
        biome = {
          cwd = function(_, ctx)
            return find_config_dir(ctx.buf, biome_configs) or vim.fn.getcwd()
          end,
        },
      },

      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
      },
    })
  end,
}
