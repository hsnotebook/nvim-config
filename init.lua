-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- ui
  use { 'morhetz/gruvbox', config = function () vim.cmd('colorscheme gruvbox') end }

  -- navigation
  use 'christoomey/vim-tmux-navigator'
  use {
    'scrooloose/nerdtree',
    config = function ()
      vim.g.NERDTreeMinimalMenu = 1
      vim.api.nvim_set_keymap('n', '<Leader>fe', ':NERDTreeToggle<CR>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<Leader>ff', ':NERDTreeFind<CR>', { noremap = true })
    end
  }

  -- edit
  use {
    'ntpeters/vim-better-whitespace',
    config = function ()
      vim.g.better_whitespace_enabled = 0
      vim.g.strip_whitespace_on_save = 1
      vim.g.strip_whitespace_confirm = 0
    end
  }
  use 'romainl/vim-cool' -- Disable search highlighting
  use 'mg979/vim-visual-multi'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-abolish'
  use 'tpope/vim-commentary'
  use 'lambdalisue/suda.vim'
  use { 'windwp/nvim-autopairs', config = function () require 'nvim-autopairs'.setup() end }
  use { 'lilydjwg/fcitx.vim', config = function () vim.opt.ttimeoutlen = 100 end }
  use 'gcmt/taboo.vim'

  use 'junegunn/goyo.vim'
  use { 'vimwiki/vimwiki', config = function () require('hs-wiki').setup() end }

  -- git
  use {
    'tpope/vim-fugitive',
    config = function ()
      vim.keymap.set('n', '<Leader>gs', ':Git<CR>', { noremap = true })
    end
  }

  -- telescope
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('hs-telescope').setup() end
  }

  -- LSP Configuration & Plugins
  use {
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
    config = function () require('hs-lsp').setup() end
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'SirVer/ultisnips', 'quangnguyen30192/cmp-nvim-ultisnips' },
    config = function() require('hs-cmp').setup() end
  }

  -- LSP for java
  use {
    'mfussenegger/nvim-jdtls',
    config = function ()
      vim.cmd([[
        augroup java-lsp
        autocmd!
        au FileType java lua require('hs-java').setup_lsp()
        augroup end
      ]])
    end
  }
  use { 'mfussenegger/nvim-dap', config = function () require('hs-java').setup_dap() end }

  -- Test
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

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

vim.g.mapleader = ' '
vim.g.localleader = ' '

vim.keymap.set('n', '<Leader>w', ':w<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>q', ':q<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>m', ':on<CR>', { noremap = true })

vim.keymap.set('n', '<Leader>ev', ':sp $MYVIMRC<CR>:lcd %:h<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>sv', ':source $MYVIMRC<CR>', { noremap = true })

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.splitright = true

vim.opt.clipboard = { 'unnamedplus' }

vim.opt.undofile = true

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Windows and tabs
vim.keymap.set('n', 'tn', ':tabn<CR>', { noremap = true })
vim.keymap.set('n', 'tp', ':tabp<CR>', { noremap = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Tab
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.cmd([[
augroup two_tab_indent
  au!
  autocmd FileType lua,html,scss,vue,javascript,yaml,css,json setlocal tabstop=2 | setlocal shiftwidth=2
augroup END
]])

-- Statusline
vim.cmd([[
  set statusline=%f%m%r%w\ %{fugitive#statusline()}\ [POS+%04l,%04v]\ [%p%%]\ [LEN=%L]\ [%{&ff}]
]])

vim.keymap.set('n', 'gV', '`[v`]', { noremap = true })
