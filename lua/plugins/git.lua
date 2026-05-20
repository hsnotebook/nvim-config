return {
  {
    "tpope/vim-fugitive",
    lazy = true,
    cmd = "Git",
    keys = {
      { "<leader>gs", "<cmd>topleft Git<cr>", desc = "Git Status" },
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gs", false },
    },
  },
}
