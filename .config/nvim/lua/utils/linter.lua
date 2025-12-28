local M = {}
local last_linter = nil

function M.notify_linter_status()
  local lint = require("lint")
  local filetype = vim.bo.filetype

  if filetype == nil or filetype == "" then
    return
  end

  local configured_linters = lint.linters_by_ft[filetype]

  if configured_linters and #configured_linters > 0 then
    local linter_names = table.concat(configured_linters, ", ")

    if last_linter == linter_names then
      return;
    end

    vim.notify(
      string.format("Linter found for %s: %s", filetype, linter_names),
      vim.log.levels.INFO,
      { title = "nvim-lint" }
    )

    last_linter = linter_names
  else
    return
    -- vim.notify(
    --   string.format("No linter configured for filetype: %s", filetype),
    --   vim.log.levels.WARN,
    --   { title = "nvim-lint" }
    -- )
  end
end

function M.current_linters()
  local lint = require("lint")
  local filetype = vim.bo.filetype
  local linters = lint.linters_by_ft[filetype]

  if linters and #linters > 0 then
    return "󰁨 " .. table.concat(linters, ", ")
  end
  return ""
end

return M
