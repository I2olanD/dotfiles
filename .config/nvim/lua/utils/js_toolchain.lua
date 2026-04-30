local M = {}

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

local js_filetypes = {
  javascript = true,
  typescript = true,
  javascriptreact = true,
  typescriptreact = true,
  svelte = true,
  vue = true,
}

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

function M.is_js(ft)
  return js_filetypes[ft] == true
end

function M.is_json(ft)
  return ft == "json" or ft == "jsonc"
end

function M.biome_root(bufnr)
  return find_config_dir(bufnr, biome_configs)
end

function M.resolve(bufnr, ft)
  local biome = find_config_dir(bufnr, biome_configs)
  if biome then
    local linters = (M.is_js(ft) or M.is_json(ft)) and { "biomejs" } or {}
    return { formatter = "biome", linters = linters, cwd = biome }
  end

  if M.is_js(ft) then
    local eslint = find_config_dir(bufnr, eslint_configs)
    return {
      formatter = "prettier",
      linters = eslint and { "eslint" } or {},
      cwd = eslint,
    }
  end

  if M.is_json(ft) then
    return { formatter = "prettier", linters = { "jsonlint" }, cwd = nil }
  end

  return { formatter = "prettier", linters = {}, cwd = nil }
end

return M
