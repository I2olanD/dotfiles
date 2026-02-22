return {
  "I2olanD/jtt.nvim",
  lazy = false,
  config = function()
    require('jtt').setup()
  end,
  keys = {
    { "<leader>jtt", "<cmd>JsonToTypeScript<cr>", desc = "Copy json to TS" }
  }
}
