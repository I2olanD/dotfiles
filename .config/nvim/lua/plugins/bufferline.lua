return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    options = {
      separator_style = "slant",
    }
  },
}
