if !has('nvim')
  execute pathogen#infect()
endif
syntax on
filetype plugin indent on
set nocompatible
set wildmenu
set hidden
set number
set shiftwidth=2 expandtab tabstop=2
set guicursor=i:block
set foldlevel=99
set mouse=
" let g:netrw_liststyle=3

"
" Colors
"
hi Pmenu  ctermbg=black    guibg=black    ctermfg=white guifg=white
hi Visual ctermbg=darkblue guibg=darkblue

hi DiagnosticFloatingError ctermfg=red guifg=red

" -- Letting color scheme set highlight colors
"hi DiffAdd      gui=none    ctermbg=darkgreen     guibg=#e4f1da
"hi DiffChange   gui=none    ctermbg=darkcyan      guibg=#c5d8ec
"hi DiffDelete   gui=none    ctermbg=darkred       guibg=#ffb0b0
"hi DiffText     gui=none    ctermbg=darkblue      guibg=#77a4d4


"
" QuickFix
"
noremap [q :cp<ENTER>
noremap ]q :cn<ENTER>

"
" Tags
"
command -bar Tags :execute ":silent :r !ctags -R >/dev/null"

"
" Idris
"
if !has('nvim')
  " with nvim we are using the Idris 2 LSP
  command! IdrisReload  let leader=get(g:,"mapleader","\\") | exec "normal " . (leader==' '?"1":leader)."r"
  noremap <Leader>rr :Tags<ENTER> <bar> :IdrisReload<ENTER>
endif
au FileType idris2 set foldmethod=indent

"
" Elixir
"
au FileType elixir set makeprg=mix
au FileType elixir set foldmethod=syntax

"
" JSON
"
au FileType json set foldmethod=syntax

"
" YAML
"
au FileType yaml set foldmethod=indent

"
" psql
"
au BufRead /tmp/psql.edit.* set syntax=sql

"
" Ruby
"
augroup ruby_ft
  autocmd!
  au FileType ruby set foldmethod=syntax
augroup END

"
" Shell
"
function! FoldShellPrompts()
  let line = getline(v:lnum)
  if line =~ '.*matt.*: .*\$ .*$'
    " Folds end when the shell prompt is found.
    return '0'
  else
    " Otherwise, within a level 1 fold
    return '1'
  endif
endfunction
function! SetShellFolding()
  au CursorMoved <buffer> setlocal foldmethod=expr foldexpr=FoldShellPrompts()
endfunction
if has('nvim')
  au TermOpen * call SetShellFolding()
else
  au TerminalOpen * call SetShellFolding()
end

"
" Commenting
"
map gc :call Comment()<CR>
map gC :call Uncomment()<CR>

function! Comment()
	let ft = &filetype
	if ft == 'php' || ft == 'ruby' || ft == 'sh' || ft == 'make' || ft == 'python' || ft == 'perl' || ft == 'elixir' || ft == 'yaml' || ft == 'dockerfile' || ft == 'nix'
		silent s/^/\#/
	elseif ft == 'javascript' || ft == 'typescript' || ft == 'c' || ft == 'cpp' || ft == 'java' || ft == 'objc' || ft == 'scala' || ft == 'go' || ft == 'swift'
		silent s:^:\/\/:g
	elseif ft == 'tex'
		silent s:^:%:g
	elseif ft == 'vim'
		silent s:^:\":g
	elseif ft == 'idris2' || ft == 'haskell' || ft == 'lua' || ft == 'sql' || ft == 'elm'
		silent s:^:-- :g
	endif
endfunction

function! Uncomment()
	let ft = &filetype
	if ft == 'php' || ft == 'ruby' || ft == 'sh' || ft == 'make' || ft == 'python' || ft == 'perl' || ft == 'elixir' || ft == 'yaml' || ft == 'dockerfile' || ft == 'nix'
		silent s/^\#//
	elseif ft == 'javascript' || ft == 'typescript' || ft == 'c' || ft == 'cpp' || ft == 'java' || ft == 'objc' || ft == 'scala' || ft == 'go' || ft == 'swift'
		silent s:^\/\/::g
	elseif ft == 'tex'
		silent s:^%::g
	elseif ft == 'vim'
		silent s:^\"::g
	elseif ft == 'idris2' || ft == 'haskell' || ft == 'lua' || ft == 'sql' || ft == 'elm'
		silent s:^-- ::g
	endif
endfunction
