local keymaps = require("keymaps")

return function(client, bufnr)
  keymaps.on_attach(client, bufnr)

  if client.server_capabilities.documentSymbolProvider then
    vim.g.navic_silence = true
    require("nvim-navic").attach(client, bufnr)
  end

  if client:supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end
