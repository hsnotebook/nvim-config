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
Plug 'easymotion/vim-easymotion'
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

"" Misc {{{
let mapleader=" "
let maplocalleader=" "

let g:python3_host_prog  = '/usr/bin/python'

filetype plugin indent on

set directory=/tmp

nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>wq :wq<cr>
nnoremap <leader>m :on<cr>

nnoremap <leader>ev :sp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Macro
nnoremap Q @@
set lazyredraw

set showmatch
set mat=2

set showcmd
set splitright
"}}}

"" Windows and tabs {{{
nnoremap tn :tabn<cr>
nnoremap tp :tabp<cr>
"}}}

"" GUI {{{
colorscheme gruvbox

set laststatus=2
set statusline=%f%m%r%w\ %{fugitive#statusline()}\ [POS+%04l,%04v]\ [%p%%]\ [LEN=%L]\ [%{&ff}]
" }}}

"" Folding {{{
set nofoldenable
"}}}

"" Tabstop {{{
set tabstop=4
set shiftwidth=4
set noexpandtab
augroup two_tab_indent
	au!
	autocmd FileType xml,html setlocal tabstop=2 | setlocal shiftwidth=2
    autocmd FileType scss,vue,javascript,yaml,css,json setlocal expandtab | setlocal tabstop=2 | setlocal shiftwidth=2
augroup END
"}}}

"" Editing {{{
set autowrite
set autoread
set clipboard+=unnamedplus
set scrolloff=6

nnoremap gV `[v`]

inoremap <C-l> <esc>b~ea

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

" ntpeters/vim-better-whitespace
let g:better_whitespace_enabled=0
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

packadd! matchit

" SirVer/ultisnips
let g:UltiSnipsEditSplit="vertical"

" junegunn/goyo.vim
let g:goyo_width = 120

" easymotion/vim-easymotion
let g:EasyMotion_do_mapping = 0
nmap s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" vim-scripts/fcitx.vim
set ttimeoutlen=100

" tpope/vim-obsession
set sessionoptions+=globals

set undodir=~/tmp/vim/undo
set undofile
"}}}

"" Search {{{
set incsearch
set hlsearch
set ignorecase
set nowrapscan
hi Search cterm=NONE ctermfg=black ctermbg=gray

" search hilight text in visual mode
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

" }}}

"" Project Manager {{{
" scrooloose/nerdtree
nnoremap <leader>fe :NERDTreeToggle<cr>
nnoremap <leader>ff :NERDTreeFind<cr>

" tpope/vim-fugitive
nnoremap <leader>gs :Git<cr>
"}}}

"" Develop {{{
" jpalardy/vim-slime
let g:slim_python_ipython = 1
let g:slime_target = "tmux"

" vim-test/vim-test
let test#java#runner = 'maventest'
let test#strategy = "vimux"
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

"}}}

"" Document {{{
" vimwiki/vimwiki
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

" file:xxx::lineNum to unnamed register
function! VimwikiStoreLink()
	let @" = 'file:'.expand("%:p").'::'.line('.')
endfunction
command! StoreLink :call VimwikiStoreLink()

"}}}

set completeopt=menu,menuone,noselect

lua << EOF
require('hs-lspconfig').setup()
require('hs-complete').setup()
require('hs-dap').setup()
require('hs-telescope').setup()
require('hs-misc').setup()
EOF

augroup java-lsp
	au FileType java lua require('hs-java').setup()
augroup end
