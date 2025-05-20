local servers = {
  ts_ls = { filetypes = { "javascriptreact", "typescript", "typescriptreact", "typescript.tsx" } },
  gopls = {},
  lua_ls = {
    lua = {
      workspace = { checkthirdparty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { "vim" } },
    },
  },
}

-- Create a special setup function for dart_ls that uses FVM
local setup_dart_ls = function(server_name, config)
  local util = require("lspconfig.util")
  local project_root = util.find_git_ancestor(vim.fn.getcwd()) or vim.fn.getcwd()
  local fvm_dart_path = project_root .. "/.fvm/flutter_sdk/bin/dart"

  -- Check if FVM Dart exists
  if vim.fn.filereadable(fvm_dart_path) == 1 then
    config.cmd = {
      fvm_dart_path,
      "language-server",
      "--protocol=lsp"
    }
  else
    vim.notify("FVM Dart SDK not found at: " .. fvm_dart_path, vim.log.levels.WARN)
    -- Fallback to system Dart if available
    if vim.fn.executable("dart") == 1 then
      config.cmd = { "dart", "language-server", "--protocol=lsp" }
    end
  end

  require('lspconfig')[server_name].setup(config)
end

local on_attach = function(client, bufnr)
  vim.keymap.set("n", "<leader>gd", function()
    vim.lsp.buf.declaration()
  end, { buffer = bufnr, desc = "[g]o to [d]eclaration" })
  vim.keymap.set("n", "<leader>gd", function()
    vim.lsp.buf.definition()
  end, { buffer = bufnr, desc = "[g]o to [d]efinition" })
  vim.keymap.set("n", "<leader>gi", function()
    vim.lsp.buf.implementation()
  end, { buffer = bufnr, desc = "[g]o to [i]mplementation" })
  vim.keymap.set("n", "<leader>k", function()
    vim.lsp.buf.code_action()
  end, { buffer = bufnr, desc = "[c]ode action" })
  vim.api.nvim_buf_create_user_command(bufnr, "format", function(_)
    vim.lsp.buf.format()
  end, { desc = "format current buffer with lsp" })
end

local handlers = {
  ["textdocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
  ["textdocument/signaturehelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local nvim_lsp = require('lspconfig')
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            nvim_lsp[server_name].setup({
              capabilities = capabilities,
              settings = servers[server_name],
              filetypes = (servers[server_name] or {}).filetypes,
              on_attach = on_attach,
              handlers = handlers,
            })
          end,
        },
      })
    end,
  },
}
