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
Plug 'kyazdani42/nvim-web-devicons'

" Tab completion
Plug 'ervandew/supertab'

" Browsing/Finding
Plug 'BurntSushi/ripgrep'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim'

" LSP
Plug 'neovim/nvim-lspconfig'
if executable('idris2')
  Plug 'ShinKage/idris2-nvim'
endif
if executable('elixir')
  Plug 'elixir-editors/vim-elixir'
endif

" Git
Plug 'lewis6991/gitsigns.nvim'

call plug#end()

lua require('init')
