vim.cmd([[
if (has("win32"))
	let nvim_home='c:/Users/Administrator/AppData/Local/nvim'
else
	let nvim_home='~/.config/nvim'
endif

call plug#begin(nvim_home . '/plugged')

Plug 'lilydjwg/fcitx.vim'
Plug 'lambdalisue/suda.vim'
Plug 'romainl/vim-cool'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'mg979/vim-visual-multi'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim'
Plug 'Asheq/close-buffers.vim'
Plug 'phaazon/hop.nvim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-obsession'
Plug 'SirVer/ultisnips'
Plug 'gcmt/taboo.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'christoomey/vim-tmux-navigator'
Plug 'morhetz/gruvbox'
Plug 'vimwiki/vimwiki'
Plug 'hotoo/pangu.vim'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/DrawIt'
Plug 'posva/vim-vue'
Plug 'othree/html5.vim'
Plug 'mattn/emmet-vim' , { 'for': ['xml', 'html', 'jsp', 'js', 'vue'] }
Plug 'pangloss/vim-javascript'
Plug 'vim-test/vim-test'
Plug 'preservim/vimux'
Plug 'jpalardy/vim-slime'
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-jdtls'
Plug 'mfussenegger/nvim-dap'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

call plug#end()
]])

vim.g.mapleader = ' '
vim.g.localleader = ' '

vim.opt.directory = '/tmp'

vim.g.python3_host_prog  = '/usr/bin/python'

vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>q', ':q<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>wq', ':wq<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>m', ':on<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', '<Leader>ev', ':sp $MYVIMRC<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>sv', ':source $MYVIMRC<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', 'Q', '@@', { noremap = true })
vim.opt.lazyredraw = true

vim.opt.showmatch = true
vim.opt.mat = 2

vim.opt.showcmd = true
vim.opt.splitright = true

-- Windows and tabs
vim.api.nvim_set_keymap('n', 'tn', ':tabn<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'tp', ':tabp<CR>', { noremap = true })


vim.cmd('colorscheme gruvbox')

vim.opt.laststatus = 2
-- vim.opt.statusline = '%f%m%r%w\ %{fugitive#statusline()}\ [POS+%04l,%04v]\ [%p%%]\ [LEN=%L]\ [%{&ff}]'

vim.cmd([[
set statusline=%f%m%r%w\ %{fugitive#statusline()}\ [POS+%04l,%04v]\ [%p%%]\ [LEN=%L]\ [%{&ff}]
]])

vim.opt.foldenable = false

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.cmd([[
augroup two_tab_indent
	au!
	autocmd FileType xml,html setlocal tabstop=2 | setlocal shiftwidth=2
    autocmd FileType scss,vue,javascript,yaml,css,json setlocal expandtab | setlocal tabstop=2 | setlocal shiftwidth=2
augroup END
]])

vim.g.autowriteall = true
vim.g.autoread = true
vim.opt.clipboard = { 'unnamedplus' }
vim.opt.scrolloff = 6

vim.api.nvim_set_keymap('n', 'gV', '`[v`]', { noremap = true })

vim.api.nvim_set_keymap('i', '<c-l>', '<esc>b~ea', { noremap = true })

vim.cmd([[
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END
]])

-- ntpeters/vim-better-whitespace
vim.g.better_whitespace_enabled = 0
vim.g.strip_whitespace_on_save = 1
vim.g.strip_whitespace_confirm = 0

-- SirVer/ultisnips
vim.g.UltiSnipsEditSplit = 'vertical'

-- junegunn/goyo.vim
vim.g.goyo_width = 120

require'hop'.setup()
vim.api.nvim_set_keymap('n', 's', "<cmd>lua require'hop'.hint_char2()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>l', "<cmd>lua require'hop'.hint_lines()<cr>", { noremap = true })

-- fcitx.vim
vim.opt.ttimeoutlen = 100

-- tpope/vim-obsession
vim.opt.sessionoptions = vim.opt.sessionoptions + 'globals'

vim.opt.undodir = '~/tmp/vim/undo'
vim.opt.undofile = true

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.wrapscan = false
vim.cmd('hi Search cterm=NONE ctermfg=black ctermbg=gray')

-- search hilight text in visual mode
vim.cmd([[
vnoremap <silent> * :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy/<C-R><C-R>=substitute(
    \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gV:call setreg('"', old_reg, old_regtype)<CR>

vnoremap <silent> # :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy?<C-R><C-R>=substitute(
    \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gV:call setreg('"', old_reg, old_regtype)<CR>
]])

-- scrooloose/nerdtree
vim.api.nvim_set_keymap('n', '<Leader>fe', ':NERDTreeToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>ff', ':NERDTreeFind<CR>', { noremap = true })

-- tpope/vim-fugitive
vim.api.nvim_set_keymap('n', '<Leader>gs', ':Git<CR>', { noremap = true })

-- jpalardy/vim-slime
vim.g.slim_python_ipython = 1
vim.g.slime_target = 'tmux'

-- vim-test/vim-test
vim.cmd([[
let test#java#runner = 'maventest'
let test#strategy = "vimux"
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
]])


-- vimwiki/vimwiki
vim.cmd([[
let ctfo = { 'name': 'ctfo', 'path': '~/wiki/ctfo', 'auto_toc': 1, 'syntax': 'markdown', 'ext': 'md' }
let IT = { 'name': 'IT', 'path': '~/wiki/IT', 'auto_toc': 1, 'syntax': 'markdown', 'ext': 'md' }
let personal = { 'name': 'personal', 'path': '~/wiki/personal', 'auto_toc': 1, 'syntax': 'markdown', 'ext': 'md' }
let g:vimwiki_list = [ctfo, IT, personal]
let g:vimwiki_html_header_numbering = 1
augroup vimwiki
	au!
	au Filetype vimwiki setlocal textwidth=80 | setlocal foldmethod=manual
	au FileType vimwiki nnoremap <leader>tt :VimwikiToggleListItem<cr>
augroup END
]])

vim.cmd([[
set completeopt=menu,menuone,noselect
]])

require('hs-lspconfig').setup()
require('hs-complete').setup()
require('hs-dap').setup()
require('hs-telescope').setup()
require('hs-misc').setup()

vim.cmd([[
augroup java-lsp
	au FileType java lua require('hs-java').setup()
augroup end
]])
