local toolchain = require("utils.js_toolchain")
local linter_utils = require("utils.linter")
local lint = require("lint")

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

    if toolchain.is_js(ft) or toolchain.is_json(ft) then
      local resolved = toolchain.resolve(args.buf, ft)
      if #resolved.linters == 0 then
        return
      end
      if resolved.cwd then
        lint.linters[resolved.linters[1]].cwd = resolved.cwd
      end
      run_linter(args.buf, resolved.linters)
      return
    end

    local linters = lint._resolve_linter_by_ft(ft)
    run_linter(args.buf, linters)
  end,
})
