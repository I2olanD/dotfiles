return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = true,
  ft = { "dart" },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
  },
  cond = function()
    local util = require("utils")
    return util.is_flutter_project()
  end,
  config = function()
    local tools = require("flutter-tools")

    tools.setup({
      decorations = {
        statusline = {
          app_version = true,
          device = true,
          project_config = true
        }
      },
      fvm = true
    })

    tools.setup_project(
      {
        name = "DEV",
        flavor = "dev",
        target = "lib/main.dart",
        dart_define_from_file = "env.dev.json"
      },
      {
        name = "QS",
        flavor = "qs",
        target = "lib/main.dart",
        dart_define_from_file = "env.qs.json"
      },
      {
        name = "PROD",
        flavor = "production",
        target = "lib/main.dart",
        dart_define_from_file = "env.production.json"
      }
    )
  end
}
