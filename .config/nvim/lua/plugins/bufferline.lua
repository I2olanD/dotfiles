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
  keys = {
    { "<leader>bn", "<cmd>enew<CR>",                  mode = { "n" }, desc = "New empy Buffer" },
    { "<leader>bc", "<cmd>bdelete<CR>",               mode = { "n" }, desc = "Close Buffer" },
    { "<left>",     "<cmd>BufferLineCyclePrev<CR>",   mode = { "n" }, desc = "Goto left buffer" },
    { "<left>",     "<cmd>BufferLineCyclePrev<CR>",   mode = { "n" }, desc = "Goto left buffer" },
    { "<right>",    "<cmd>BufferLineCycleNext<CR>",   mode = { "n" }, desc = "Goto right buffer" },
    { "<up>",       "<cmd>BufferLineCloseOthers<CR>", mode = { "n" }, desc = "Close all other buffers" },
  },
}
