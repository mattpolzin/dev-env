set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

call plug#begin()

" Silly
"Plug 'seandewar/nvimesweeper'

" Color
"Plug 'cocopon/iceberg.vim' " -- syntax highlighting is too muted
Plug 'joshdick/onedark.vim'

Plug 'PeterRincker/vim-searchlight' "highlight search term cursor is over differently

" Util
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Open files with line number annotations
Plug 'lewis6991/fileline.nvim'

" Tab completion
Plug 'ervandew/supertab'

" Previewing Markdown (:MarkdownPreview)
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" Browsing/Finding
Plug 'stevearc/oil.nvim'
Plug 'BurntSushi/ripgrep'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
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

call plug#end()

lua require('init')
