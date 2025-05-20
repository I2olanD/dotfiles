local M = {}

function M.is_flutter_project()
  local pubspec_path = vim.fn.findfile("pubspec.yaml", ".;")
  if pubspec_path == "" then
    return false
  end

  local pubspec = vim.fn.readfile(pubspec_path)
  for _, line in ipairs(pubspec) do
    if line:match("^%s*flutter:") then
      return true
    end
  end

  return false
end

return M
