execute pathogen#infect()
syntax on
filetype plugin indent on
:set nocompatible
:set wildmenu
:set hidden
:set number

:command -bar Tags :execute ":silent :r !ctags -R >/dev/null"

command! IdrisReload  let leader=get(g:,"mapleader","\\") | exec "normal " . (leader==' '?"1":leader)."r"
noremap <Leader>rr :Tags<ENTER> <bar> :IdrisReload<ENTER>
