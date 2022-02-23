
# output ls and others in color
export CLICOLOR=1
export LSCOLORS=Cxfxcxdxbxegedabagacad

export EDITOR=nvim

#change input to vi style
bindkey -v

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
  PROMPT="%n: ${green}%~ ${yellow}\${vcs_info_msg_0_}${normal}$ "
else
  PROMPT="%n:%~ \${vcs_info_msg_0_}$ "
fi

