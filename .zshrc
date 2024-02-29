
# Set XDG variables to stop some programs from using ~/Library/Preferences over ~/.config
export XDG_CONFIG_HOME=~/.config

# output ls and others in color
export CLICOLOR=1
export LSCOLORS=Cxfxcxdxbxegedabagacad
export LS_COLORS='di=1;32'

export EDITOR=nvim
export BROWSER=w3m

# set a location to look for a ripgrep config file
export RIPGREP_CONFIG_PATH=~/.config/ripgrep/ripgreprc

# use ripgrep in FZF
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='-m --height 85% --border --preview-window up'

#change input to vi style
bindkey -v

#support ctrl+r command history search
bindkey "^R" history-incremental-pattern-search-backward

# autocompletion
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
test -f ~/bin/git-completion.zsh && . ~/bin/git-completion.zsh
command -v harmony >/dev/null 2>&1 && eval "$(harmony --bash-completion-script)"
# note location for adding completion handlers: /usr/local/etc/bash_completion.d
test -r "/usr/local/etc/profile.d/bash_completion.sh" && . "/usr/local/etc/profile.d/bash_completion.sh"

# Load version control information
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '(%b) '

setopt prompt_subst

ncolors=$(tput colors)
if [ -n "$ncolors" ] && [ $ncolors -ge 8 ]; then
  normal="$(tput sgr0)"
  green="$(tput setaf 2)"
  yellow="$(tput setaf 3)"
  PROMPT="%n: %{${green}%}%~ %{${yellow}%}\${vcs_info_msg_0_}%{${normal}%}$ "
else
  PROMPT="%n:%~ \${vcs_info_msg_0_}$ "
fi

# SSH agent for Linux
if [ -z "$SSH_AUTH_SOCK" ] && [ "$(uname)" = 'Linux' ]; then
  eval `ssh-agent -s` >/dev/null
  ssh-add >/dev/null 2>&1 
fi

# direnv integration
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
#
##
## aliases
##

# fuzzy find against GitHub website. works really well with e.g.
# ghp mattpolzin dev-env -> github.com/mattpolzin/dev-env
# ghp mattpolzin ncurses -> github.com/mattpolzin/ncurses-idris
command -v ddgr >/dev/null 2>&1 && alias ghp='ddgr -jw github.com'
