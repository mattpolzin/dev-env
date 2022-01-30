
# output ls and others in color
export CLICOLOR=1
export LSCOLORS=Cxfxcxdxbxegedabagacad

export EDITOR=nvim

#change input to vi style
set -o vi;

function parse_git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "("${ref#refs/heads/}") "
}
export -f parse_git_branch

ncolors=$(tput colors)
if [ -n "$ncolors" ] && [ $ncolors -ge 8 ]; then
  normal="$(tput sgr0)"
  green="$(tput setaf 2)"
  yellow="$(tput setaf 3)"
  export PS1="\u: ${green}\w ${yellow}\$(parse_git_branch)${normal}$ "
else
  export PS1="\u:\w \$(parse_git_branch)$ "
fi

