local M = {}

local wiki_home =  "/home/hs/wiki"

M.wiki_files = function()
	require('telescope.builtin').find_files({
		prompt_title = "< Wiki >",
		cwd = wiki_home
	})
end

M.search_wiki = function()
	require('telescope.builtin').live_grep({
		prompt_title = "< Search In Wiki >",
		cwd = wiki_home
	})
end

M.setup = function()
	vim.api.nvim_set_keymap('n', '<leader>vp', '<Cmd>lua require("hs-misc").wiki_files()<CR>', { silent = true, noremap = true })
	vim.api.nvim_set_keymap('n', '<leader>vg', '<Cmd>lua require("hs-misc").search_wiki()<CR>', { silent = true, noremap = true })
end

return M
