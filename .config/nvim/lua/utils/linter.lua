local M = {}

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
