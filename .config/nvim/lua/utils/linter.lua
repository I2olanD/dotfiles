local M = {}

function M.set_linters(bufnr, linters)
  vim.b[bufnr].active_linters = linters
end

function M.current_linters()
  local linters = vim.b.active_linters

  if linters and #linters > 0 then
    return "󰁨 " .. table.concat(linters, ", ")
  end
  return ""
end

return M
