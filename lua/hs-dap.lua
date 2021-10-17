local dap = require('dap')
local api = vim.api
local M = {}

function M.setup()
	api.nvim_set_keymap('n', 'K', '<Cmd>lua require("dap.ui.variables").hover()<CR>', { silent = true })
	api.nvim_set_keymap('n', '<F8>', '<Cmd>lua require("dap").continue()<CR>', { silent = true })
	api.nvim_set_keymap('n', '<F10>', '<Cmd>lua require("dap").step_over()<CR>', { silent = true })
	api.nvim_set_keymap('n', '<F11>', '<Cmd>lua require("dap").step_into()<CR>', { silent = true })
	api.nvim_set_keymap('n', '<F12>', '<Cmd>lua require("dap").step_out()<CR>', { silent = true })
	api.nvim_set_keymap('n', '<leader>dr', '<Cmd>lua require("dap").repl.toggle()<CR>', { silent = true })
	api.nvim_set_keymap('n', '<F3>', '<Cmd>lua require("dap").toggle_breakpoint()<CR>', { silent = true })
	api.nvim_set_keymap('n', '<leader><F3>', '<Cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', { silent = true })

	dap.configurations.java = {
		{
			type = 'java';
			request = 'attach';
			name = "Debug (Attach) - Remote";
			hostName = "127.0.0.1";
			port = 5005;
		},
	}
	dap.defaults.fallback.external_terminal = {
		command = '/usr/bin/alacritty';
		args = {'-e'};
	}
	args = {'-e'};
	vim.cmd("au FileType dap-repl lua require('dap.ext.autocompl').attach()")

end

return M
