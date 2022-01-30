
# output ls and others in color
export CLICOLOR=1
export LSCOLORS=Cxfxcxdxbxegedabagacad

export EDITOR=nvim

#change input to vi style
set -o vi;

function parse_git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "("${ref#refs/heads/}")"
}

export PS1="local:\w \$(parse_git_branch)$ "
