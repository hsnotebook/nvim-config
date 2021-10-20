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
	local config = {
		cmd = {
			'/home/hs/.config/nvim/java/java-lsp.sh',
			'/home/hs/.config/jdtls/workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
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
