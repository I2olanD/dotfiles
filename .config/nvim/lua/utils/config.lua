local M = {}

M.biome_configs = { "biome.json", "biome.jsonc" }

function M.find_config_dir(bufnr, config_files)
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

return M
