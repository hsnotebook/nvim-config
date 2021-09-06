if (has("win32"))
	let nvim_home='c:/Users/Administrator/AppData/Local/nvim'
else
	let nvim_home='~/.config/nvim'
endif

call plug#begin(nvim_home . '/plugged')

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

""" Macro
nnoremap Q @@
set lazyredraw

set showmatch
set mat=2

set showcmd
set splitright

Plug 'vim-scripts/DrawIt'

Plug 'christoomey/vim-tmux-navigator'
"}}}

"" Windows and tabs {{{
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap tn :tabn<cr>
nnoremap tp :tabp<cr>
Plug 'gcmt/taboo.vim'
"}}}

"" Terminal {{{
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
if has("nvim")
  au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
  au FileType fzf tunmap <buffer> <Esc>
endif
augroup term_statusline
	au!
	autocmd TermOpen * setlocal statusline=%{b:term_title}
augroup END
nnoremap <leader>tb :vsplit term://zsh<cr>
tnoremap <leader>tb <C-\><C-N>:vsplit term://zsh<cr>
" }}}

"" GUI {{{
Plug 'sheerun/vim-wombat-scheme'
colorscheme wombat

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

Plug 'ntpeters/vim-better-whitespace'
let g:better_whitespace_enabled=0
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

packadd! matchit

Plug 'SirVer/ultisnips'
let g:UltiSnipsEditSplit="vertical"

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-obsession'
Plug 'junegunn/goyo.vim'
let g:goyo_width = 120

Plug 'mg979/vim-visual-multi'

Plug 'Asheq/close-buffers.vim'

Plug 'easymotion/vim-easymotion'
let g:EasyMotion_do_mapping = 0
nmap s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

Plug 'vim-scripts/fcitx.vim'
set ttimeoutlen=100

Plug 'jiangmiao/auto-pairs'
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

" disables search highlighting when you are done searching
" and re-enables it when you search again.
Plug 'romainl/vim-cool'

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
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
nnoremap <leader>fe :NERDTreeToggle<cr>
nnoremap <leader>ff :NERDTreeFind<cr>

set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/target/*,*/node_modules/*
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
let g:fzf_layout = { 'down': '40%' }
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
let g:fzf_commits_log_options = "--graph --color=always --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %Cblue<%an>%Creset' --date=format:'%F %T' --abbrev-commit --all"
nnoremap <silent> <leader>p :Files<CR>
nnoremap <silent> <leader>P :GFiles<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>h :History<CR>

Plug 'tpope/vim-fugitive'
nnoremap <leader>gs :Git<cr>
"}}}

"" Develop {{{

"" Front {{{
Plug 'posva/vim-vue'
Plug 'othree/html5.vim'
Plug 'mattn/emmet-vim' , { 'for': ['xml', 'html', 'jsp', 'js', 'vue'] }
Plug 'pangloss/vim-javascript'
"}}}

Plug 'jpalardy/vim-slime'
let g:slim_python_ipython = 1
let g:slime_target = "tmux"

Plug 'vim-test/vim-test'
let test#java#runner = 'maventest'
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

Plug 'puremourning/vimspector'
augroup vimspector-debug
	au!
	au FileType java nnoremap <buffer> <F1> :CocCommand java.debug.vimspector.start<cr>
	au FileType java nnoremap <buffer> <F5> :call vimspector#StepInto()<cr>
	au FileType java nnoremap <buffer> <F6> :call vimspector#StepOver()<cr>
	au FileType java nnoremap <buffer> <F7> :call vimspector#StepOut()<cr>
	au FileType java nnoremap <buffer> <F8> :call vimspector#Continue()<cr>
	au FileType java nnoremap <buffer> <F9> :call vimspector#ToggleBreakpoint()<cr>
augroup END

"}}}

"" Document {{{
Plug 'vimwiki/vimwiki'
let ctfo = { 'name': 'ctfo', 'path': '~/vimwiki/ctfo', 'auto_toc': 1, 'syntax': 'markdown', 'ext': 'md' }
let IT = { 'name': 'IT', 'path': '~/vimwiki/IT', 'auto_toc': 1, 'syntax': 'markdown', 'ext': 'md' }
let personal = { 'name': 'personal', 'path': '~/vimwiki/personal', 'auto_toc': 1, 'syntax': 'markdown', 'ext': 'md' }
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

Plug 'masukomi/vim-markdown-folding'
Plug 'hotoo/pangu.vim'
"}}}

Plug 'neovim/nvim-lspconfig'
set completeopt-=preview

call plug#end()

lua << EOF
local nvim_lsp = require('lspconfig')
require'lspconfig'.pyright.setup{}
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false
    }
)

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
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

augroup java-lsp
	au FileType java lua require('jdtls').start_or_attach({cmd = {'/home/hs/.config/nvim/java-lsp.sh', '/home/hs/.config/jdtls/workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')}})
	au FileType java nnoremap <leader>ca <Cmd>lua require('jdtls').code_action()<CR>
	au FileType java nnoremap <leader>r <Cmd>lua require('jdtls').code_action(false, 'refactor')<CR>
	au FileType java nnoremap <leader>o <Cmd>lua require'jdtls'.organize_imports()<CR>

	au FileType java nnoremap gD <cmd>lua vim.lsp.buf.declaration()<CR>
	au FileType java nnoremap gd <cmd>lua vim.lsp.buf.definition()<CR>
	au FileType java nnoremap K <cmd>lua vim.lsp.buf.hover()<CR>
	au FileType java nnoremap gi <cmd>lua vim.lsp.buf.implementation()<CR>
	au FileType java nnoremap <leader>D <cmd>lua vim.lsp.buf.type_definition()<CR>
	au FileType java nnoremap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
	au FileType java nnoremap gr <cmd>lua vim.lsp.buf.references()<CR>
	au FileType java nnoremap <leader>e <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
	au FileType java nnoremap [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
	au FileType java nnoremap ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
	au FileType java nnoremap <leader>f <cmd>lua vim.lsp.buf.formatting()<CR>

	au FileType java set omnifunc=v:lua.vim.lsp.omnifunc
augroup end
