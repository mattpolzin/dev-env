" This file is only used when Nix did not install NeoVim.
" For Nix installs, this file, which is entirely about 
" configuring plugins (and loading .vimrc and init.lua)
" is skipped over by an init.lua created by Nix that
" configures all plugins and then also calls .vimrc and
" lua/init.lua.

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

if !empty(glob('${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim')) || !empty(glob('~/.vim/autoload/plug.vim'))
  call plug#begin()

  " Silly
  "Plug 'seandewar/nvimesweeper'

  " Color
  if !has('nvim')
    Plug 'joshdick/onedark.vim'
  else
    Plug 'navarasu/onedark.nvim'
  endif

  " Util
  Plug 'nvim-lua/plenary.nvim'
  Plug 'MunifTanjim/nui.nvim'
  Plug 'kyazdani42/nvim-web-devicons'

  " Open files with line number annotations
  Plug 'lewis6991/fileline.nvim'

  " Tab completion
  if !has('nvim')
    Plug 'ervandew/supertab'   " -- used to use, but not compatible with nvim lsp completion
  else
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'petertriho/cmp-git'
    
    Plug 'hrsh7th/nvim-cmp'

    Plug 'hrsh7th/vim-vsnip'
  endif

  " Previewing Markdown (:MarkdownPreview)
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

  " Browsing/Finding
  Plug 'stevearc/oil.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'junegunn/fzf.vim' " <- faster file picker than telescope currently.
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " <- faster file picker than telescope currently.

  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.85 } }
  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit' }
  let g:fzf_history_dir = '~/.local/share/fzf-history'

  " LSP
  Plug 'neovim/nvim-lspconfig'
  if executable('idris2')
    Plug 'ShinKage/idris2-nvim'
  endif
  if executable('elixir')
    Plug 'elixir-editors/vim-elixir'
  endif

  " DAP
  Plug 'mfussenegger/nvim-dap'

  " Treesitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-context'

  " Git
  Plug 'lewis6991/gitsigns.nvim'

  " Note taking
  Plug 'gaoDean/autolist.nvim'
  Plug 'nvim-neorg/neorg', { 'do': ':Neorg sync-parsers' }
  Plug 'dhruvasagar/vim-table-mode'
  let g:table_mode_corner='|' " <- markdown compatible tables

  call plug#end()
endif

lua require('init')
