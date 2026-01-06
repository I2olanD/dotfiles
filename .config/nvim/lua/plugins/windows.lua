return {
  "anuvyklack/windows.nvim",
  event = "VeryLazy",
  dependencies = {
    "anuvyklack/middleclass",
    "anuvyklack/animation.nvim",
  },
  config = function()
    vim.opt.winwidth = 5
    vim.opt.winminwidth = 5
    vim.opt.equalalways = false

    require("windows").setup({
      animation = {
        duration = 150,
      },
    })
  end,
}
