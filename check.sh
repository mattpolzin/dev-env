#!/bin/sh

##
## Check that the dev environment appears set up and
## in sync with these configs.
##

DIFF_OUT=''
EXIT_STATUS=0
USE_ZSH='false'
MAC_OS='false'

if [ "$(command -v zsh)" = '' ]; then
  echo '- [ ] System has zsh.'
else
  echo '- [x] System has zsh (preferring over bash).'
  USE_ZSH='true'
fi

if [ "$USE_ZSH" = 'true' ] && [ "${SHELL/zsh/}" == "$SHELL" ]; then
  echo "- [ ] SHELL env var points at zsh (actually found $SHELL)."
  echo '      ! Falling back to bash.'
  USE_ZSH='false'
else
  echo '- [x] SHELL env var points at zsh.'
fi

if [ "$USE_ZSH" = 'false' ] && [ "$(command -v bash)" = '' ]; then
  echo 'System does not have bash. Only zsh and bash are supported by these configs, exiting.'
  exit 1
else
  echo '- [x] System has bash.'
fi

if [[ "$(command -v uname && uname -v)" =~ 'Darwin' ]]; then
  MAC_OS='true'
fi

function optionalProgramCheck() {
  found="$(command -v $1)"
  if [ "$found" = '' ]; then
    echo "  * ( ) $2 found in PATH."
  else
    echo "  * (x) $2 found in PATH."
  fi
}

echo '- Programs'
if [ "$(command -v diff)" = '' ]; then
  echo 'System does not have diff. This check script currently relies heavily on diff.'
  exit 1
else
  echo '  * [x] diff found in PATH.'
fi

if [ "$(command -v kitty)" = '' ]; then
  echo '  * [ ] kitty found in PATH.'
  EXIT_STATUS=1
else
  echo '  * [x] kitty found in PATH.'
fi

if [ "$(command -v nvim)" = '' ]; then
  echo '  * [ ] neovim found in PATH.'
  EXIT_STATUS=1
else
  echo '  * [x] neovim found in PATH.'
fi

optionalProgramCheck 'clx'     'circumflex'
optionalProgramCheck 'ddgr'    'duck duck go CLI'
optionalProgramCheck 'glow'    'glow'
optionalProgramCheck 'harmony' 'harmony'
optionalProgramCheck 'ijq'     'ijq'
optionalProgramCheck 'jq'      'jq'
optionalProgramCheck 'k9s'     'k9s'
optionalProgramCheck 'kubectl' 'kubectl'
optionalProgramCheck 'yq'      'yq'
optionalProgramCheck 'tree'    'tree'
optionalProgramCheck 'w3m'     'w3m'

if [ "$(command -v scheme)" = '' ] && [ "$(command -v chez)" = '' ]; then
  echo '  * ( ) scheme found in PATH.'
else
  echo '  * (x) scheme found in PATH.'
fi

echo '- Languages'
if [ "$(command -v idris2)" != '' ]; then
  echo '  * (x) idris2 found in PATH.'
  echo "        > $(idris2 --version)"
else
  echo '  * ( ) idris2 found in PATH.'
fi
if [ "$(command -v elixir)" != '' ]; then
  echo '  * (x) elixir found in PATH.'
  echo "        > $(elixir --version | tail -n1)"
else
  echo '  * ( ) elixir found in PATH.'
fi
if [ "$(command -v nix)" != '' ]; then
  echo '  * (x) nix found in PATH.'
  echo "        > $(nix --version)"
else
  echo '  * ( ) nix found in PATH.'
fi
if [ "$(command -v elm)" != '' ]; then
  echo '  * (x) elm found in PATH.'
  echo "        > $(elm --version)"
else
  echo '  * ( ) elm found in PATH.'
fi
if [ "$(command -v node)" != '' ]; then
  echo '  * (x) nodejs found in PATH.'
  echo "        > $(node --version)"
else
  echo '  * ( ) nodejs found in PATH.'
fi
if [ "$(command -v ghc)" != '' ]; then
  echo '  * (x) haskell found in PATH.'
  echo "        > $(ghc --version)"
else
  echo '  * ( ) haskell found in PATH.'
fi
if [ "$(command -v swift)" != '' ]; then
  echo '  * (x) swift found in PATH.'
else
  echo '  * ( ) swift found in PATH.'
fi

echo '- Configs'
#
# check ~/.bashrc exists
if [ "$USE_ZSH" = 'false' ] && [ -f "$HOME/.bashrc" ]; then
  #
  # check ~/.bashrc is the same
  DIFF="$(diff -U3 "$HOME/.bashrc" ./.bashrc)"
  if [ "$?" = '1' ]; then
    echo '  * [ ] ~/.bashrc file in sync.'
    EXIT_STATUS=1
    DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
  else
    echo '  * [x] ~/.bashrc file in sync.'
  fi
elif [ "$USE_ZSH" = 'false' ]; then
  echo '  * [ ] ~/.bashrc file in sync.'
  echo '        ! No .bashrc file found.'
  EXIT_STATUS=1
fi

#
# check ~/.zshrc exists
if [ "$USE_ZSH" = 'true' ] && [ -f "$HOME/.zshrc" ]; then
  #
  # check ~/.zshrc is the same
  DIFF="$(diff -U3 "$HOME/.zshrc" ./.zshrc)"
  if [ "$?" = '1' ]; then
    echo '  * [ ] ~/.zshrc file in sync.'
    EXIT_STATUS=1
    DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
  else
    echo '  * [x] ~/.zshrc file in sync.'
  fi
elif [ "$USE_ZSH" = 'true' ]; then
  echo '  * [ ] ~/.zshrc file in sync.'
  echo '        ! No .zshrc file found.'
  EXIT_STATUS=1
fi

#
# check ~/.vimrc exists
if [ -f "$HOME/.vimrc" ]; then
  #
  # check ~/.vimrc is the same
  DIFF="$(diff -U3 "$HOME/.vimrc" ./.vimrc)"
  if [ "$?" = '1' ]; then
    echo '  * [ ] ~/.vimrc file in sync.'
    DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
    EXIT_STATUS=1
  else
    echo '  * [x] ~/.vimrc file in sync.'
  fi
else
  echo '  * [ ] ~/.vimrc file in sync.'
  echo '        ! No .vimrc file found.'
  EXIT_STATUS=1
fi

#
# check ~/.ctags exists
if [ -f "$HOME/.ctags" ]; then
  #
  # check ~/.ctags is the same
  DIFF="$(diff -U3 "$HOME/.ctags" ./.ctags)"
  if [ "$?" = '1' ]; then
    echo '  * [ ] ~/.ctags file in sync.'
    DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
    EXIT_STATUS=1
  else
    echo '  * [x] ~/.ctags file in sync.'
  fi
else
  echo '  * [ ] ~/.ctags file in sync.'
  echo '        ! No .ctags file found.'
  EXIT_STATUS=1
fi

#
# check ~/.xmonad is the same
if [ "$MAC_OS" == 'false' ]; then
  if [ -f "$HOME/.xmonad/xmonad.hs" ]; then
    DIFF="$(diff -U3 "$HOME/.xmonad/xmonad.hs" ./.xmonad/xmonad.hs)"
    if [ "$?" = '1' ]; then
      echo '  * ( ) ~/.xmonad/xmonad.hs file in sync.'
      DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
      EXIT_STATUS=1
    else
      echo '  * (x) ~/.xmonad/xmonad.hs file in sync.'
    fi
  else
    echo '  * ( ) ~/.xmonad/xmonad.hs file in sync.'
    echo '        > No xmonad.hs file found.'
  fi
fi

#
# check if /etc/nixos exists
if [ -d '/etc/nixos' ]; then
  #
  # check if directory contents are the same
  DIFF1="$(diff -U3 /etc/nixos/configuration.nix ./etc/nixos/configuration.nix)"
  E1="$?"
  DIFF2="$(diff -U3 /etc/nixos/hardware-configuration.nix ./etc/nixos/hardware-configuration.nix)"
  E2="$?"
  if [ "$E1" = '1' ] || [ "$E2" = '1' ]; then
    echo '  * [ ] /etc/nixos directory in sync.'
    DIFF_OUT="$DIFF_OUT\n\n$DIFF1\n$DIFF2\n"
    EXIT_STATUS=1
  else
    echo '  * [x] /etc/nixos directory in sync.'
  fi
fi

#
#
# check ~/.w3m is the same
if [ -d "$HOME/.w3m" ]; then
  DIFF="$(diff -U3 --recursive "$HOME/.w3m" ./.w3m)"
  RES="$?"
  DIFF="$(echo "$DIFF" | grep --invert-match --regexp 'cookie')"
  INVERSE_RES="$?"
  if [ "$RES" = '1' ] && [ "$INVERSE_RES" = '0' ]; then
    echo '  * [ ] ~/.w3m directory in sync.'
    DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
    EXIT_STATUS=1
  else
    echo '  * [x] ~/.w3m directory in sync.'
  fi
else
  echo '  * [ ] ~/.w3m directory in sync.'
  echo '        ! No .w3m directory found.'
fi

#
# check ~/.config exists
if [ -d "$HOME/.config" ]; then
  echo '  * [x] ~/.config directory exists.'
  #
  # check ~/.config/nvim is the same
  if [ -d "$HOME/.config/nvim" ]; then
    DIFF="$(diff -U3 --recursive "$HOME/.config/nvim" ./.config/nvim)"
    if [ "$?" = '1' ]; then
      echo '  * [ ] ~/.config/nvim directory in sync.'
      DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
      EXIT_STATUS=1
    else
      echo '  * [x] ~/.config/nvim directory in sync.'
    fi
  else
    echo '  * [ ] ~/.config/nvim directory in sync.'
    echo '        ! No nvim directory found.'
  fi
  #
  # check ~/.config/kitty is the same
  if [ -d "$HOME/.config/kitty" ]; then
    DIFF="$(diff -U3 --recursive "$HOME/.config/kitty" ./.config/kitty)"
    if [ "$?" = '1' ]; then
      echo '  * [ ] ~/.config/kitty directory in sync.'
      DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
      EXIT_STATUS=1
    else
      echo '  * [x] ~/.config/kitty directory in sync.'
    fi
  else
    echo '  * [ ] ~/.config/kitty directory in sync.'
    echo '        ! No kitty directory found.'
  fi
  #
  # check ~/.config/ghostty is the same
  if [ -d "$HOME/.config/ghostty" ]; then
    DIFF="$(diff -U3 --recursive "$HOME/.config/ghostty" ./.config/ghostty)"
    if [ "$?" = '1' ]; then
      echo '  * [ ] ~/.config/ghostty directory in sync.'
      DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
      EXIT_STATUS=1
    else
      echo '  * [x] ~/.config/ghostty directory in sync.'
    fi
  else
    echo '  * [ ] ~/.config/ghostty directory in sync.'
    echo '        ! No ghostty directory found.'
  fi
  #
  # check ~/.config/k9s is the same
  if [ -d "$HOME/.config/k9s" ]; then
    DIFF="$(diff -U3 --recursive "$HOME/.config/k9s" ./.config/k9s)"
    if [ "$?" = '1' ]; then
      echo '  * ( ) ~/.config/k9s directory in sync.'
      DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
      EXIT_STATUS=1
    else
      echo '  * (x) ~/.config/k9s directory in sync.'
    fi
  else
    echo '  * ( ) ~/.config/k9s directory in sync.'
    echo '        > No k9s directory found.'
  fi
  #
  # check ~/.config/ripgrep is the same
  if [ -d "$HOME/.config/ripgrep" ]; then
    DIFF="$(diff -U3 --recursive "$HOME/.config/ripgrep" ./.config/ripgrep)"
    if [ "$?" = '1' ]; then
      echo '  * ( ) ~/.config/ripgrep directory in sync.'
      DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
      EXIT_STATUS=1
    else
      echo '  * (x) ~/.config/ripgrep directory in sync.'
    fi
  else
    echo '  * ( ) ~/.config/ripgrep directory in sync.'
    echo '        ! No ripgrep directory found.'
  fi
  #
  # check ~/.config/xmobar is the same
  if [ "$MAC_OS" == 'false' ]; then
    if [ -d "$HOME/.config/xmobar" ]; then
      DIFF="$(diff -U3 --recursive "$HOME/.config/xmobar" ./.config/xmobar)"
      if [ "$?" = '1' ]; then
        echo '  * ( ) ~/.config/xmobar directory in sync.'
        DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
        EXIT_STATUS=1
      else
        echo '  * (x) ~/.config/xmobar directory in sync.'
      fi
    else
      echo '  * ( ) ~/.config/xmobar directory in sync.'
      echo '        > No xmobar directory found.'
    fi
  fi
  #
  # check ~/.config/nix is the same
  if [ -d "$HOME/.config/nix" ]; then
    DIFF="$(diff -U3 --recursive "$HOME/.config/nix" ./.config/nix)"
    if [ "$?" = '1' ]; then
      echo '  * ( ) ~/.config/nix directory in sync.'
      DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
      EXIT_STATUS=1
    else
      echo '  * (x) ~/.config/nix directory in sync.'
    fi
  else
    echo '  * ( ) ~/.config/nix directory in sync.'
    echo '        > No nix directory found.'
  fi
else
  echo '  * [ ] ~/.config directory exists.'
  EXIT_STATUS=1
fi

#
# check for Neovim & LSP deps
function optionalLSPCheck() {
  found="$(command -v $1)"
  if [ "$found" != '' ]; then
    echo "  * (x) $1 found in PATH."
  else
    echo "  * ( ) $1 found in PATH."
  fi
}

echo '- Neovim Telescope/LSP'
if [ "$(command -v rg)" != '' ] && [ "$(rg --version | head -n1 | awk '{ print $1 }')" = 'ripgrep' ]; then
  echo '  * (x) ripgrep found in PATH (shell command: rg).'
else
  echo '  * ( ) ripgrep found in PATH (shell command: rg).'
fi

optionalLSPCheck 'fd'
optionalLSPCheck 'idris2-lsp'
optionalLSPCheck 'elixir-ls'
optionalLSPCheck 'rnix-lsp'
optionalLSPCheck 'elm-language-server'
optionalLSPCheck 'haskell-language-server-wrapper'

NPM=''
if [ "$(command -v npm)" = '' ]; then
  NPM="$(npm -g ls --parseable)"
fi

if [ "$(command -v typescript)" != '' ] || [ "$(echo "$NPM" | grep 'typescript$')" != '' ]; then
  echo '  * (x) npm package or standalone typescript.'
else
  echo '  * ( ) npm package or standalone typescript.'
fi
if [ "$(command -v typescript-language-server)" != '' ] || [ "$(echo "$NPM" | grep 'typescript-language-server$')" != '' ]; then
  echo '  * (x) npm package or standalone typescript-language-server.'
else
  echo '  * ( ) npm package or standalone typescript-language-server.'
fi
if [ "$(command -v vscode-langservers-extracted)" != '' ] || [ "$(echo "$NPM" | grep 'vscode-langservers-extracted')" != '' ]; then
  echo '  * (x) npm package or standalone vscode-langservers-extracted.'
else
  echo '  * ( ) npm package or standalone vscode-langservers-extracted.'
fi
if [ "$(command -v diagnostic-languageserver)" != '' ] || [ "$(echo "$NPM" | grep 'diagnostic-languageserver')" != '' ]; then
  echo '  * (x) npm package or standalone diagnostic-languageserver.'
else
  echo '  * ( ) npm package or standalone diagnostic-languageserver.'
fi

if [ "$MAC_OS" == 'true' ]; then
  echo "$DIFF_OUT"
else
  echo -e "$DIFF_OUT"
fi
exit $EXIT_STATUS
