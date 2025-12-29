return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", mode = { "n" }, desc = "Toggle Explorer" },
    { "<leader>E", "<cmd>Neotree reveal<CR>", mode = { "n" }, desc = "Reveal current buffer" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    close_if_last_window = true,
    window = {
      mappings = {
        ["O"] = {
          command = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.jobstart({ "open", "-R", path }, { detach = true })
          end,
          desc = "Open in Finder",
        },
      },
    },
    filesystem = {
      filtered_items = {
        visible = true,
      }
    }
  }
}
