local metals_config = require("metals").bare_config()

metals_config.capabilities = require("blink.cmp").get_lsp_capabilities()
metals_config.on_attach = require("utils.lsp_attach")

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
