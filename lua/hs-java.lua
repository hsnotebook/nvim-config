local M = {}

local on_attach = function(_, bufnr)
  require 'jdtls'.setup_dap()

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  require('lsp-util').common_setup(bufnr)

  local nmap = require('lsp-util').lsp_map(bufnr, 'n')
  nmap('<leader>o', require'jdtls'.organize_imports, '[O]rganize [I]ports')

  local vmap = require('lsp-util').lsp_map(bufnr, 'v')
  vmap("<leader>dm", function () require('jdtls').extract_method(true) end, '[E]xtract [M]ethod')
end

M.setup_lsp = function()
  local jdtls_home = '/home/hs/.config/jdtls'
  local jdtls_server = jdtls_home .. '/server'

  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local workspace_dir = jdtls_home .. '/workspace/' .. project_name

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  local config = {
    cmd = {
      '/usr/lib/jvm/java-11-openjdk/bin/java',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xms1g',
      '-javaagent:' .. jdtls_home .. '/jar/lombok.jar',
      '--add-modules=ALL-SYSTEM',
      '--add-opens', 'java.base/java.util=ALL-UNNAMED',
      '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
      '-jar', jdtls_server .. '/plugins/org.eclipse.equinox.launcher_1.6.300.v20210813-1054.jar',
      '-configuration', jdtls_server .. '/config_linux',
      '-data', workspace_dir
    },
    capabilities = capabilities,
    init_options = {
      bundles = { jdtls_home .. "/jar/com.microsoft.java.debug.plugin-0.32.0.jar" };
    },
    on_attach = on_attach
  }

  require('jdtls').start_or_attach(config)
end

M.setup_dap = function ()
  local dap = require('dap')

  vim.keymap.set('n', '<F9>', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
  vim.keymap.set('n', '<F8>', '<Cmd>lua require("dap").continue()<CR>', { silent = true })
  vim.keymap.set('n', '<F10>', '<Cmd>lua require("dap").step_over()<CR>', { silent = true })
  vim.keymap.set('n', '<F6>', '<Cmd>lua require("dap").step_into()<CR>', { silent = true })
  vim.keymap.set('n', '<F7>', '<Cmd>lua require("dap").step_out()<CR>', { silent = true })
  vim.keymap.set('n', '<leader>dr', '<Cmd>lua require("dap").repl.toggle()<CR>', { silent = true })
  vim.keymap.set('n', '<F3>', '<Cmd>lua require("dap").toggle_breakpoint()<CR>', { silent = true })
  vim.keymap.set('n', '<leader><F3>', '<Cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', { silent = true })

  dap.configurations.java = {
    {
      type = 'java';
      request = 'attach';
      name = "Debug (Attach) - Remote";
      hostName = "127.0.0.1";
      port = 5005;
    },
  }
  vim.cmd("au FileType dap-repl lua require('dap.ext.autocompl').attach()")
end

return M
