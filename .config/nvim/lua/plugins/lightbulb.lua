return {
  "kosayoda/nvim-lightbulb",
  config = function()
    require("nvim-lightbulb").setup({
      autocmd = {
        enabled = true,
        updatetime = 0,
        events = {
          "CursorMoved"
        }
      },
      number = {
        enabled = true,
        hl = "cyan"
      },
      sign = {
        enabled = true,
        text = " ",
        lens_text = " "
      },
    })
  end
}
