#!/bin/sh

##
## Check that the dev environment appears set up and
## in sync with these configs.
##

DIFF_OUT=''
EXIT_STATUS=0
USE_ZSH='false'

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

if [ "$(command -v diff)" = '' ]; then
  echo 'System does not have diff. This check script currently relies heavily on diff.'
  exit 1
else
  echo '- [x] diff found in PATH.'
fi

if [ "$(command -v kitty)" = '' ]; then
  echo '- [ ] kitty found in PATH.'
  EXIT_STATUS=1
else
  echo '- [x] kitty found in PATH.'
fi

if [ "$(command -v nvim)" = '' ]; then
  echo '- [ ] neovim found in PATH.'
  EXIT_STATUS=1
else
  echo '- [x] neovim found in PATH.'
fi

if [ "$(command -v harmony)" = '' ]; then
  echo '- ( ) harmony found in PATH.'
else
  echo '- (x) harmony found in PATH.'
fi

if [ "$(command -v scheme)" = '' ] && [ "$(command -v chez)" = '' ]; then
  echo '- ( ) scheme found in PATH.'
else
  echo '- (x) scheme found in PATH.'
fi

#
# check ~/.bashrc exists
if [ "$USE_ZSH" = 'false' ] && [ -f "$HOME/.bashrc" ]; then
  #
  # check ~/.bashrc is the same
  DIFF="$(diff -U3 "$HOME/.bashrc" ./.bashrc)"
  if [ "$?" = '1' ]; then
    echo '- [ ] ~/.bashrc file in sync.'
    EXIT_STATUS=1
    DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
  else
    echo '- [x] ~/.bashrc file in sync.'
  fi
elif [ "$USE_ZSH" = 'false' ]; then
  echo '- [ ] ~/.bashrc file in sync.'
  echo '      ! No .bashrc file found.'
  EXIT_STATUS=1
fi

#
# check ~/.zshrc exists
if [ "$USE_ZSH" = 'true' ] && [ -f "$HOME/.zshrc" ]; then
  #
  # check ~/.zshrc is the same
  DIFF="$(diff -U3 "$HOME/.zshrc" ./.zshrc)"
  if [ "$?" = '1' ]; then
    echo '- [ ] ~/.zshrc file in sync.'
    EXIT_STATUS=1
    DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
  else
    echo '- [x] ~/.zshrc file in sync.'
  fi
elif [ "$USE_ZSH" = 'true' ]; then
  echo '- [ ] ~/.zshrc file in sync.'
  echo '      ! No .zshrc file found.'
  EXIT_STATUS=1
fi

#
# check ~/.vimrc exists
if [ -f "$HOME/.vimrc" ]; then
  #
  # check ~/.vimrc is the same
  DIFF="$(diff -U3 "$HOME/.vimrc" ./.vimrc)"
  if [ "$?" = '1' ]; then
    echo '- [ ] ~/.vimrc file in sync.'
    DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
    EXIT_STATUS=1
  else
    echo '- [x] ~/.vimrc file in sync.'
  fi
else
  echo '- [ ] ~/.vimrc file in sync.'
  echo '      ! No .vimrc file found.'
  EXIT_STATUS=1
fi

#
# check ~/.ctags exists
if [ -f "$HOME/.ctags" ]; then
  #
  # check ~/.ctags is the same
  DIFF="$(diff -U3 "$HOME/.ctags" ./.ctags)"
  if [ "$?" = '1' ]; then
    echo '- [ ] ~/.ctags file in sync.'
    DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
    EXIT_STATUS=1
  else
    echo '- [x] ~/.ctags file in sync.'
  fi
else
  echo '- [ ] ~/.ctags file in sync.'
  echo '      ! No .ctags file found.'
  EXIT_STATUS=1
fi

#
# check ~/.config exists
if [ -d "$HOME/.config" ]; then
  echo '- [x] ~/.config directory exists.'
  #
  # check ~/.config/nvim is the same
  if [ -d "$HOME/.config/nvim" ]; then
    DIFF="$(diff -U3 --recursive "$HOME/.config/nvim" ./.config/nvim)"
    if [ "$?" = '1' ]; then
      echo '- [ ] ~/.config/nvim directory in sync.'
      DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
      EXIT_STATUS=1
    else
      echo '- [x] ~/.config/nvim directory in sync.'
    fi
  else
    echo '- [ ] ~/.config/nvim directory in sync.'
    echo '      ! No nvim directory found.'
  fi
  #
  # check ~/.config/kitty is the same
  if [ -d "$HOME/.config/kitty" ]; then
    DIFF="$(diff -U3 --recursive "$HOME/.config/kitty" ./.config/kitty)"
    if [ "$?" = '1' ]; then
      echo '- [ ] ~/.config/kitty directory in sync.'
      DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
      EXIT_STATUS=1
    else
      echo '- [x] ~/.config/kitty directory in sync.'
    fi
  else
    echo '- [ ] ~/.config/kitty directory in sync.'
    echo '      ! No kitty directory found.'
  fi
  #
  # check ~/.config/k9s is the same
  if [ -d "$HOME/.config/k9s" ]; then
    DIFF="$(diff -U3 --recursive "$HOME/.config/k9s" ./.config/k9s)"
    if [ "$?" = '1' ]; then
      echo '- [ ] ~/.config/k9s directory in sync.'
      DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
      EXIT_STATUS=1
    else
      echo '- [x] ~/.config/k9s directory in sync.'
    fi
  else
    echo '- [ ] ~/.config/k9s directory in sync.'
    echo '      ! No k9s directory found.'
  fi
else
  echo '- [ ] ~/.config directory exists.'
  EXIT_STATUS=1
fi

#
# check for Neovim & LSP deps
echo '- Neovim Telescope/LSP'
if [ "$(command -v rg)" != '' ] && [ "$(rg --version | head -n1 | awk '{ print $1 }')" = 'ripgrep' ]; then
  echo '  * [x] ripgrep found in PATH (shell command: rg).'
else
  echo '  * [ ] ripgrep found in PATH (shell command: rg).'
  EXIT_STATUS=1
fi
if [ "$(command -v fd)" != '' ]; then
  echo '  * [x] fd found in PATH.'
else
  echo '  * [ ] fd found in PATH.'
  EXIT_STATUS=1
fi
if [ "$(command -v idris2)" != '' ]; then
  echo '  * [x] idris2 found in PATH.'
else
  echo '  * [ ] idris2 found in PATH.'
  EXIT_STATUS=1
fi
if [ "$(command -v idris2-lsp)" != '' ]; then
  echo '  * [x] idris2-lsp found in PATH.'
else
  echo '  * [ ] idris2-lsp found in PATH.'
  EXIT_STATUS=1
fi
if [ "$(command -v elixir)" != '' ]; then
  echo '  * [x] elixir found in PATH.'
else
  echo '  * [ ] elixir found in PATH.'
  EXIT_STATUS=1
fi
if [ "$(command -v elixir-ls)" != '' ]; then
  echo '  * [x] elixir-ls found in PATH.'
else
  echo '  * [ ] elixir-ls found in PATH.'
  EXIT_STATUS=1
fi
if [ "$(command -v npm)" = '' ]; then
  echo '  * [ ] npm package vscode-langservers-extracted found.'
  echo '  * [ ] npm package typescript found.'
  echo '  * [ ] npm package typescript-language-server found.'
  EXIT_STATUS=1
else
  NPM="$(npm -g ls --parseable)"
  if [ "$(echo "$NPM" | grep 'typescript$')" != '' ]; then
    echo '  * [x] npm package typescript found.'
  else
    echo '  * [ ] npm package typescript found.'
    EXIT_STATUS=1
  fi
  if [ "$(echo "$NPM" | grep 'typescript-language-server$')" != '' ]; then
    echo '  * [x] npm package typescript-language-server found.'
  else
    echo '  * [ ] npm package typescript-language-server found.'
    EXIT_STATUS=1
  fi
  if [ "$(echo "$NPM" | grep 'vscode-langservers-extracted')" != '' ]; then
    echo '  * [x] npm package vscode-langservers-extracted found.'
  else
    echo '  * [ ] npm package vscode-langservers-extracted found.'
    EXIT_STATUS=1
  fi
fi

echo "$DIFF_OUT"
exit $EXIT_STATUS
