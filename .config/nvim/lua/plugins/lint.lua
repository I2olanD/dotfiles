local function find_config_dir(bufnr, config_files)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == "" then
    return nil
  end

  local dir = vim.fn.fnamemodify(filepath, ":h")

  while dir ~= "/" and dir ~= "" do
    for _, config_file in ipairs(config_files) do
      if vim.fn.filereadable(dir .. "/" .. config_file) == 1
          or vim.fn.isdirectory(dir .. "/" .. config_file) == 1 then
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
local eslint_configs = {
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.json",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
}

return {
  "mfussenegger/nvim-lint",
  event = { "BufWritePost", "BufReadPost", "InsertLeave" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      lua = { "luacheck" },
      sql = { "sqlfluff" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local js_fts = {
          javascript = true,
          typescript = true,
          javascriptreact = true,
          typescriptreact = true,
          svelte = true,
        }

        if js_fts[ft] or ft == "json" or ft == "jsonc" then
          local biome_root = find_config_dir(args.buf, biome_configs)
          if biome_root then
            lint.linters.biomejs.cwd = biome_root
            lint.try_lint({ "biomejs" })
            return
          end

          if js_fts[ft] then
            local eslint_root = find_config_dir(args.buf, eslint_configs)
            if eslint_root then
              lint.linters.eslint.cwd = eslint_root
              lint.try_lint({ "eslint" })
            end
          elseif ft == "json" or ft == "jsonc" then
            lint.try_lint({ "jsonlint" })
          end
        else
          lint.try_lint()
        end
      end,
    })
  end,
}
