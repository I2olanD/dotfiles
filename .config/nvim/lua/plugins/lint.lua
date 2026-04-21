local config = require("utils.config")
local linter_utils = require("utils.linter")
local lint = require("lint")

local js_filetypes = {
  javascript = true,
  typescript = true,
  javascriptreact = true,
  typescriptreact = true,
  svelte = true,
  vue = true,
}

lint.linters_by_ft = {
  lua = { "luacheck" },
  sql = { "sqlfluff" },
}

local function run_linter(bufnr, linters)
  lint.try_lint(linters)
  linter_utils.set_linters(bufnr, linters)
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if not ft or ft == "" then
      return
    end

    if js_filetypes[ft] or ft == "json" or ft == "jsonc" then
      local biome_root = config.find_config_dir(args.buf, config.biome_configs)
      if biome_root then
        lint.linters.biomejs.cwd = biome_root
        run_linter(args.buf, { "biomejs" })
        return
      end

      if js_filetypes[ft] then
        local eslint_root = config.find_config_dir(args.buf, config.eslint_configs)
        if eslint_root then
          lint.linters.eslint.cwd = eslint_root
          run_linter(args.buf, { "eslint" })
        end
      else
        run_linter(args.buf, { "jsonlint" })
      end
    else
      local linters = lint._resolve_linter_by_ft(ft)
      run_linter(args.buf, linters)
    end
  end,
})
