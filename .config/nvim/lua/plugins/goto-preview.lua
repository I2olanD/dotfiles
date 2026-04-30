require("goto-preview").setup({
  post_open_hook = function(_, win)
    vim.api.nvim_set_option_value("winhighlight", "Normal:Normal,FloatBorder:FloatBorder", { win = win })
  end,
})
