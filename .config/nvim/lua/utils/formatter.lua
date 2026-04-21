local M = {}

function M.current_formatters()
  local ok, conform = pcall(require, "conform")
  if not ok then
    return ""
  end

  local formatters = conform.list_formatters_for_buffer(0)

  if #formatters > 0 then
    local names = {}
    for _, formatter in ipairs(formatters) do
      if type(formatter) == "string" then
        table.insert(names, formatter)
      end
    end

    if #names > 0 then
      return "󰉼 " .. table.concat(names, ", ")
    end
  end

  return ""
end

return M
