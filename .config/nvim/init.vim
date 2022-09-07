set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

call plug#begin()

" Silly
Plug 'seandewar/nvimesweeper'

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

" Previewing Markdown (:MarkdownPreview)
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" Note taking
Plug 'phaazon/mind.nvim'
Plug 'gaoDean/autolist.nvim'

" Browsing/Finding
Plug 'BurntSushi/ripgrep'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
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
