if (has("win32"))
	let nvim_home='c:/Users/Administrator/AppData/Local/nvim'
else
	let nvim_home='~/.config/nvim'
endif

call plug#begin(nvim_home . '/plugged')

"" Misc {{{
let mapleader=" "
let maplocalleader=" "

filetype plugin indent on

set directory=/tmp

nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
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

nnoremap <leader>e :e!<cr>
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
" nnoremap <silent> <C-p> :Files<CR>
nnoremap K :Ag <C-R><C-W><CR>

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


Plug 'neoclide/coc.nvim'

" coc-java
" coc-java-debug
" coc-pyright
" coc-yaml

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

inoremap <silent><expr> <c-d> coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>af  :CocFix<cr>

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
nmap <leader>o  :call CocAction('runCommand', 'editor.action.organizeImport')<cr>:w<cr>

" Use K to show documentation in preview window.
nnoremap <silent> L :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

call plug#end()
