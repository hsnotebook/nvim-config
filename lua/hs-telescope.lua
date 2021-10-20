local M = {}

function M.setup()
	require('telescope').setup {
		defaults = {
			file_ignore_patterns = {"node_modules", "target", "dist"}
		},
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
			}
		}
	}
	vim.api.nvim_set_keymap('n', '<leader>p', '<Cmd>lua require("telescope.builtin").find_files()<CR>', { silent = true, noremap = true })
	vim.api.nvim_set_keymap('n', '<leader>ag', '<Cmd>lua require("telescope.builtin").live_grep()<CR>', { silent = true, noremap = true })
	vim.api.nvim_set_keymap('n', '<leader>b', '<Cmd>lua require("telescope.builtin").buffers()<CR>', { silent = true, noremap = true })
	vim.api.nvim_set_keymap('n', '<leader>h', '<Cmd>lua require("telescope.builtin").oldfiles()<CR>', { silent = true, noremap = true })

	require('telescope').load_extension('fzf')
end

return M
