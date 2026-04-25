return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = {
        underline = false,
        virtual_text = { current_line = true },
      },
    },
  },
}
