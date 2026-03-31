local config = require("utils.config")

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

local js_filetypes = {
  javascript = true,
  typescript = true,
  javascriptreact = true,
  typescriptreact = true,
  svelte = true,
}

local lint = require("lint")

lint.linters_by_ft = {
  lua = { "luacheck" },
  sql = { "sqlfluff" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype

    if js_filetypes[ft] or ft == "json" or ft == "jsonc" then
      local biome_root = config.find_config_dir(args.buf, config.biome_configs)
      if biome_root then
        lint.linters.biomejs.cwd = biome_root
        lint.try_lint({ "biomejs" })
        return
      end

      if js_filetypes[ft] then
        local eslint_root = config.find_config_dir(args.buf, eslint_configs)
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
