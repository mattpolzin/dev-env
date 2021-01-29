execute pathogen#infect()
syntax on
filetype plugin indent on
:set nocompatible
:set wildmenu
:set hidden
:set number

:command -bar Tags :execute ":silent :r !ctags -R >/dev/null"

"
" Idris
"
command! IdrisReload  let leader=get(g:,"mapleader","\\") | exec "normal " . (leader==' '?"1":leader)."r"
noremap <Leader>rr :Tags<ENTER> <bar> :IdrisReload<ENTER>

"
" Commenting
"
map gc :call Comment()<CR>
map gC :call Uncomment()<CR>

function! Comment()
	let ft = &filetype
	if ft == 'php' || ft == 'ruby' || ft == 'sh' || ft == 'make' || ft == 'python' || ft == 'perl'
		silent s/^/\#/
	elseif ft == 'javascript' || ft == 'c' || ft == 'cpp' || ft == 'java' || ft == 'objc' || ft == 'scala' || ft == 'go'
		silent s:^:\/\/:g
	elseif ft == 'tex'
		silent s:^:%:g
	elseif ft == 'vim'
		silent s:^:\":g
	elseif ft == 'idris2' || ft == 'haskell'
		silent s:^:-- :g
	endif
endfunction

function! Uncomment()
	let ft = &filetype
	if ft == 'php' || ft == 'ruby' || ft == 'sh' || ft == 'make' || ft == 'python' || ft == 'perl'
		silent s/^\#//
	elseif ft == 'javascript' || ft == 'c' || ft == 'cpp' || ft == 'java' || ft == 'objc' || ft == 'scala' || ft == 'go'
		silent s:^\/\/::g
	elseif ft == 'tex'
		silent s:^%::g
	elseif ft == 'vim'
		silent s:^\"::g
	elseif ft == 'idris2' || ft == 'haskell'
		silent s:^-- ::g
	endif
endfunction
