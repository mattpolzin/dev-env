if !has('nvim')
  execute pathogen#infect()
endif
syntax on
filetype plugin indent on
set nocompatible
set wildmenu
set hidden
set number
set shiftwidth=2
highlight Pmenu ctermbg=darkgray guibg=darkgray ctermfg=white guifg=white
highlight Visual ctermbg=darkblue guibg=darkblue
" let g:netrw_liststyle=3

command -bar Tags :execute ":silent :r !ctags -R >/dev/null"

"
" Idris
"
if !has('nvim')
  " with nvim we are using the Idris 2 LSP
  command! IdrisReload  let leader=get(g:,"mapleader","\\") | exec "normal " . (leader==' '?"1":leader)."r"
  noremap <Leader>rr :Tags<ENTER> <bar> :IdrisReload<ENTER>
endif

"
" psql
"

au BufRead /tmp/psql.edit.* set syntax=sql

"
" Commenting
"
map gc :call Comment()<CR>
map gC :call Uncomment()<CR>

function! Comment()
	let ft = &filetype
	if ft == 'php' || ft == 'ruby' || ft == 'sh' || ft == 'make' || ft == 'python' || ft == 'perl' || ft == 'elixir'
		silent s/^/\#/
	elseif ft == 'javascript' || ft == 'c' || ft == 'cpp' || ft == 'java' || ft == 'objc' || ft == 'scala' || ft == 'go' || ft == 'swift'
		silent s:^:\/\/:g
	elseif ft == 'tex'
		silent s:^:%:g
	elseif ft == 'vim'
		silent s:^:\":g
	elseif ft == 'idris2' || ft == 'haskell' || ft == 'lua'
		silent s:^:-- :g
	endif
endfunction

function! Uncomment()
	let ft = &filetype
	if ft == 'php' || ft == 'ruby' || ft == 'sh' || ft == 'make' || ft == 'python' || ft == 'perl' || ft == 'elixir'
		silent s/^\#//
	elseif ft == 'javascript' || ft == 'c' || ft == 'cpp' || ft == 'java' || ft == 'objc' || ft == 'scala' || ft == 'go' || ft == 'swift'
		silent s:^\/\/::g
	elseif ft == 'tex'
		silent s:^%::g
	elseif ft == 'vim'
		silent s:^\"::g
	elseif ft == 'idris2' || ft == 'haskell' || ft == 'lua'
		silent s:^-- ::g
	endif
endfunction
