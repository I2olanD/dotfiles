local keymaps = require("keymaps")

local metals_config = require("metals").bare_config()

metals_config.capabilities = require("blink.cmp").get_lsp_capabilities()

metals_config.on_attach = function(client, bufnr)
  keymaps.on_attach(client, bufnr)

  if client.server_capabilities.documentSymbolProvider then
    vim.g.navic_silence = true
    require("nvim-navic").attach(client, bufnr)
  end

  if client:supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

metals_config.settings = {
  showImplicitArguments = true,
  showInferredType = true,
}

metals_config.init_options.statusBarProvider = "off"

local group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = group,
})
