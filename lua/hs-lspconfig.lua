local M = {}

local function disable_diagnostic_msg()
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics, {
			virtual_text = false
		}
	)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap('n', 'gd', "<Cmd>lua require('telescope.builtin').lsp_definitions()<CR>", opts)
  buf_set_keymap('n', 'gi', "<Cmd>lua require('telescope.builtin').lsp_implementations()<CR>", opts)
  buf_set_keymap('n', 'gr', "<Cmd>lua require('telescope.builtin').lsp_references()<CR>", opts)
  buf_set_keymap('n', '<leader>D', "<Cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>", opts)
  buf_set_keymap('n', '<leader>rn', "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap('n', '<leader>ca', "<Cmd>lua require('telescope.builtin').lsp_code_actions()<CR>", opts)
  buf_set_keymap('n', '[d', "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap('n', ']d', "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap('n', '<leader>cf', "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

local function setup_python()
	local nvim_lsp = require('lspconfig')
	nvim_lsp['pyright'].setup {
		on_attach = on_attach,
		capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
		flags = {
			debounce_text_changes = 150,
		},
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "off",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = 'workspace'
				}
			}
		}
	}
end

function M.setup()
	disable_diagnostic_msg()
	setup_python()
end

return M
