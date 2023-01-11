local M = {}

local function disable_diagnostic_msg()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { virtual_text = false }
  )
end

local on_attach = function(_, bufnr)
  require('lsp-util').common_setup(bufnr)
end

M.setup = function ()
  disable_diagnostic_msg()

  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
  vim.keymap.set('n', '<leader>cq', vim.diagnostic.setloclist)

  -- Enable the following language servers
  local servers = {
    pyright = {},
    sumneko_lua = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  }

  require('neodev').setup()

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  require('mason').setup()

  local mason_lspconfig = require 'mason-lspconfig'
  mason_lspconfig.setup({
    ensure_installed = vim.tbl_keys(servers),
  })

  mason_lspconfig.setup_handlers({
    function(server_name)
      require('lspconfig')[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      })
    end,
  })

  -- Turn on lsp status information
  require('fidget').setup()

end

return M
