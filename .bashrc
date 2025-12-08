
# Set XDG variables to stop some programs from using ~/Library/Preferences over ~/.config
export XDG_CONFIG_HOME=~/.config
export XCG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share
export XDG_STATE_HOME=~/.local/state

# output ls and others in color
export CLICOLOR=1
export LSCOLORS=Cxfxcxdxbxegedabagacad

export EDITOR=nvim
export BROWSER=w3m

# set a location to look for a ripgrep config file
export RIPGREP_CONFIG_PATH=~/.config/ripgrep/ripgreprc

# use ripgrep in FZF
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='-m --height 85% --border --preview-window up'

#change input to vi style
set -o vi

function parse_git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "("${ref#refs/heads/}") "
}
export -f parse_git_branch

shlvl_prompt_prefix() {
  if [[ $SHLVL -gt 1 ]]; then
    echo "${SHLVL}] "
  fi
}
export -f shlvl_prompt_prefix

ncolors=$(tput colors)
shlvl="\$(shlvl_prompt_prefix)"
if [ -n "$ncolors" ] && [ $ncolors -ge 8 ]; then
  normal="$(tput sgr0)"
  green="$(tput setaf 2)"
  yellow="$(tput setaf 3)"
  export PS1="${shlvl}\u: \[${green}\]\w \[${yellow}\]\$(parse_git_branch)\[${normal}\]$ "
else
  export PS1="${shlvl}\u:\w \$(parse_git_branch)$ "
fi

# git auto-completion
[[ -f ~/bin/git-completion.bash ]] && . $_

