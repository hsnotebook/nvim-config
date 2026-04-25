return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      root_dir = function(path)
        return vim.fs.root(path, { ".git" })
          or vim.fs.root(path, vim.lsp.config.jdtls.root_markers)
      end,
    },
  },
}
