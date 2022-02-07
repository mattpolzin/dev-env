set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

call plug#begin()

" Color
"Plug 'cocopon/iceberg.vim' " -- syntax highlighting is too muted
Plug 'joshdick/onedark.vim'

Plug 'PeterRincker/vim-searchlight' "highlight search term cursor is over differently

" Util
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'tami5/sqlite.lua'
Plug 'kyazdani42/nvim-web-devicons'

" Tab completion
Plug 'ervandew/supertab'

" Browsing/Finding
Plug 'BurntSushi/ripgrep'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'nvim-telescope/telescope.nvim'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'ShinKage/idris2-nvim'
Plug 'elixir-editors/vim-elixir'

" Git
Plug 'lewis6991/gitsigns.nvim'

call plug#end()

lua require('init')
