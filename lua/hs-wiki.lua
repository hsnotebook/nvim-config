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
  vim.cmd([[
    let ctfo = { 'name': 'ctfo', 'path': '~/wiki/ctfo', 'auto_toc': 1, 'syntax': 'markdown', 'ext': 'md' }
    let IT = { 'name': 'IT', 'path': '~/wiki/IT', 'auto_toc': 1, 'syntax': 'markdown', 'ext': 'md' }
    let personal = { 'name': 'personal', 'path': '~/wiki/personal', 'auto_toc': 1, 'syntax': 'markdown', 'ext': 'md' }
    let finance = { 'name': 'finance', 'path': '~/wiki/finance', 'auto_toc': 1, 'syntax': 'markdown', 'ext': 'md' }
    let g:vimwiki_list = [ctfo, IT, personal, finance]
    let g:vimwiki_html_header_numbering = 1
  ]])
  vim.keymap.set('n', '<leader>vf', require('hs-wiki').wiki_files, { desc = 'Search Wiki' })
  vim.keymap.set('n', '<leader>vg', require('hs-wiki').search_wiki, { desc = 'Grep Wiki Content'})
end

M.openWiki = function()
  vim.cmd("TabooRename wiki")
  vim.cmd("lcd ~/wiki")
end

vim.api.nvim_create_user_command("Wiki", M.openWiki, {})

require('hs-wiki-heading').setup()

return M

