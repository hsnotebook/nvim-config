return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        win = {
          input = {
            keys = {
              ["<C-x>"] = { "edit_split", mode = { "i", "n" } },
              ["<C-v>"] = { "edit_vsplit", mode = { "i", "n" } },
              ["<C-s>"] = false,
            },
          },
          list = {
            keys = {
              ["<C-x>"] = "edit_split",
              ["<C-v>"] = "edit_vsplit",
              ["<C-s>"] = false,
            },
          },
        },
      },
    },
  },
}
