vim.cmd [[packadd packer.nvim]]

vim.cmd([[
augroup packer_user_config
	autocmd!
	autocmd BufWritePost init.lua source <afile> | PackerCompile
augroup end
]])

require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'lambdalisue/suda.vim'
	use 'romainl/vim-cool'
	use {
		'windwp/nvim-autopairs',
		config = function ()
			require'nvim-autopairs'.setup()
		end
	}
	use 'Asheq/close-buffers.vim'
	use 'tpope/vim-surround'
	use 'mg979/vim-visual-multi'
	use 'tpope/vim-repeat'
	use 'tpope/vim-abolish'
	use { 'tpope/vim-obsession', config = function () vim.opt.sessionoptions = vim.opt.sessionoptions + 'globals' end}
	use 'christoomey/vim-tmux-navigator'
	use 'gcmt/taboo.vim'
	use 'tpope/vim-commentary'
	use {
		'vim-test/vim-test',
		config = function ()
			vim.cmd([[
			let test#java#runner = 'maventest'
			let test#strategy = "vimux"
			nmap <silent> t<C-n> :TestNearest<CR>
			nmap <silent> t<C-f> :TestFile<CR>
			nmap <silent> t<C-s> :TestSuite<CR>
			nmap <silent> t<C-l> :TestLast<CR>
			nmap <silent> t<C-g> :TestVisit<CR>
			]])
		end
	}
	use 'preservim/vimux'
	use {
		'jpalardy/vim-slime',
		config = function ()
			vim.g.slim_python_ipython = 1
			vim.g.slime_target = 'tmux'
		end
	}
	use { 'posva/vim-vue', ft = 'vue' }
	use 'othree/html5.vim'
	use 'pangloss/vim-javascript'
	use { 'mattn/emmet-vim', ft = {'xml', 'html', 'jsp', 'js', 'vue'} }
	use { 'morhetz/gruvbox', config = function () vim.cmd('colorscheme gruvbox') end }
	use { 'junegunn/goyo.vim', config = function () vim.g.goyo_width = 120 end }
	use { 'lilydjwg/fcitx.vim', config = function () vim.opt.ttimeoutlen = 100 end }
	use { 'SirVer/ultisnips', config = function () vim.g.UltiSnipsEditSplit = 'vertical' end }
	use {
		'vimwiki/vimwiki',
		config = function ()
			vim.cmd([[
			let ctfo = { 'name': 'ctfo', 'path': '~/wiki/ctfo', 'auto_toc': 1, 'syntax': 'markdown', 'ext': 'md' }
			let IT = { 'name': 'IT', 'path': '~/wiki/IT', 'auto_toc': 1, 'syntax': 'markdown', 'ext': 'md' }
			let personal = { 'name': 'personal', 'path': '~/wiki/personal', 'auto_toc': 1, 'syntax': 'markdown', 'ext': 'md' }
			let g:vimwiki_list = [ctfo, IT, personal]
			let g:vimwiki_html_header_numbering = 1
			augroup vimwiki
				au!
				au FileType vimwiki setlocal textwidth=80 | setlocal foldmethod=manual
				au FileType vimwiki nnoremap <leader>tt :VimwikiToggleListItem<cr>
			augroup END
			]])
		end
	}
	use {
		'tpope/vim-fugitive',
		config = function ()
			vim.api.nvim_set_keymap('n', '<Leader>gs', ':Git<CR>', { noremap = true })
		end
	}
	use {
		'phaazon/hop.nvim',
		config = function ()
			require'hop'.setup()
			vim.api.nvim_set_keymap('n', 's', "<cmd>lua require'hop'.hint_char2()<cr>", { noremap = true })
			vim.api.nvim_set_keymap('n', '<Leader>l', "<cmd>lua require'hop'.hint_lines()<cr>", { noremap = true })
		end
	}
	use {
		'ntpeters/vim-better-whitespace',
		config = function ()
			vim.g.better_whitespace_enabled = 0
			vim.g.strip_whitespace_on_save = 1
			vim.g.strip_whitespace_confirm = 0
		end
	}
	use {
		'scrooloose/nerdtree',
		config = function ()
			vim.api.nvim_set_keymap('n', '<Leader>fe', ':NERDTreeToggle<CR>', { noremap = true })
			vim.api.nvim_set_keymap('n', '<Leader>ff', ':NERDTreeFind<CR>', { noremap = true })
		end
	}
	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} },
		config = function ()
			require('hs-telescope').setup()
		end
	}
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use { 'neovim/nvim-lspconfig', config = function () require('hs-lspconfig').setup() end }

	use {
		'mfussenegger/nvim-jdtls',
		config = function ()
			vim.cmd([[
			augroup java-lsp
			au FileType java lua require('hs-java').setup()
			augroup end
			]])
		end
	}
	use { 'mfussenegger/nvim-dap', config = function () require('hs-dap').setup() end }
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use {
		'hrsh7th/nvim-cmp',
		config =function ()
			vim.cmd([[
			set completeopt=menu,menuone,noselect
			]])
			require('hs-complete').setup()
		end
	}
end)

vim.g.mapleader = ' '
vim.g.localleader = ' '

vim.g.python3_host_prog  = '/usr/bin/python'

vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>q', ':q<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>wq', ':wq<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>m', ':on<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', '<Leader>ev', ':sp $MYVIMRC<CR>:lcd %:h<CR>', { noremap = true })
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

vim.opt.laststatus = 2
-- vim.opt.statusline = '%f%m%r%w\ %{fugitive#statusline()}\ [POS+%04l,%04v]\ [%p%%]\ [LEN=%L]\ [%{&ff}]'

vim.cmd([[
set statusline=%f%m%r%w\ %{fugitive#statusline()}\ [POS+%04l,%04v]\ [%p%%]\ [LEN=%L]\ [%{&ff}]
]])

vim.opt.foldenable = false

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.cmd([[
augroup two_tab_indent
	au!
    autocmd FileType html,scss,vue,javascript,yaml,css,json setlocal tabstop=2 | setlocal shiftwidth=2
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

require('hs-misc').setup()

