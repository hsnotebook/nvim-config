local M = {}

local on_attach = function(client, bufnr)
	require'jdtls'.setup_dap()

	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = { noremap=true, silent=true }
	buf_set_keymap('n', '<leader>ca', "<Cmd>lua require('telescope.builtin').lsp_code_actions()<CR>", opts)
	buf_set_keymap('n', '<leader>o', "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
	buf_set_keymap('n', 'gD', "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap('n', 'gd', "<Cmd>lua require('telescope.builtin').lsp_definitions()<CR>", opts)
	buf_set_keymap('n', 'gi', "<Cmd>lua require('telescope.builtin').lsp_implementations()<CR>", opts)
	buf_set_keymap('n', 'gr', "<Cmd>lua require('telescope.builtin').lsp_references()<CR>", opts)
	buf_set_keymap('n', '<leader>D', "<Cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>", opts)
	buf_set_keymap('n', '<leader>rn', "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap('n', '[d', "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap('n', ']d', "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<leader>dt", "<Cmd>lua require'jdtls'.test_class()<CR>", opts)
	buf_set_keymap("n", "<leader>dn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
	buf_set_keymap("v", "<leader>de", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
	buf_set_keymap("n", "<leader>de", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
	buf_set_keymap("v", "<leader>dm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)

	buf_set_keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

function M.setup()
	local jdtls_home = '/home/hs/.config/jdtls'
	local jdtls_server = jdtls_home .. '/server'
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
	local workspace_dir = jdtls_home .. '/workspace/' .. project_name
	local config = {
		cmd = {
			'/usr/lib/jvm/java-11-openjdk/bin/java',
			'-Declipse.application=org.eclipse.jdt.ls.core.id1',
			'-Dosgi.bundles.defaultStartLevel=4',
			'-Declipse.product=org.eclipse.jdt.ls.core.product',
			'-Dlog.protocol=true',
			'-Dlog.level=ALL',
			'-Xms1g',
			'-javaagent:/home/hs/.config/nvim/java/lombok.jar',
			'--add-modules=ALL-SYSTEM',
			'--add-opens', 'java.base/java.util=ALL-UNNAMED',
			'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
			'-jar', jdtls_server .. '/plugins/org.eclipse.equinox.launcher_1.6.300.v20210813-1054.jar',
			'-configuration', jdtls_server .. '/config_linux',
			'-data', workspace_dir
		},
		capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
		init_options = {
			bundles = { "/home/hs/.config/nvim/java/com.microsoft.java.debug.plugin-0.32.0.jar" };
		},
		on_attach = on_attach
	}

	require('jdtls').start_or_attach(config)
end

return M
