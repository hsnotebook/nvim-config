local M = {}

M.setup = function ()
  require('telescope').setup {
    defaults = {
      path_display = { "shorten" },
      file_ignore_patterns = {"node_modules", "target", "dist"},
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        }
      }
    }
  }

  pcall(require('telescope').load_extension, 'fzf')

  vim.keymap.set('n', '<leader>h', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader>b', function() require("telescope.builtin").buffers({only_cwd=true, sort_mru=true}) end)
  vim.keymap.set('n', '<leader>B', function() require("telescope.builtin").buffers({sort_mru=true}) end)
  -- vim.keymap.set('n', '<leader>/', function() require('telescope.builtin').current_buffer_fuzzy_find() end, { desc = '[/] Fuzzily search in current buffer]' })

  vim.keymap.set('n', '<leader>p', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>ag', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
end

return M
