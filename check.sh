#!/bin/sh

##
## Check that the dev environment appears set up and
## in sync with these configs.
##

DIFF_OUT=''
EXIT_STATUS=0

if [ "$(which bash)" = '' ]; then
  echo 'System does not have bash. These configs currently only contain a .bashrc file.'
  exit 1
else
  echo '- [x] System has bash.'
fi

if [ "$(which diff)" = '' ]; then
  echo 'System does not have diff. This check script currently relies heavily on diff.'
  exit 1
else
  echo '- [x] diff found in PATH.'
fi

if [ "$(which kitty)" = '' ]; then
  echo '- [ ] kitty found in PATH.'
  EXIT_STATUS=1
else
  echo '- [x] kitty found in PATH.'
fi

if [ "$(which nvim)" = '' ]; then
  echo '- [ ] neovim found in PATH.'
  EXIT_STATUS=1
else
  echo '- [x] neovim found in PATH.'
fi

#
# check ~/.bashrc exists
if [ -f "$HOME/.bashrc" ]; then
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
else
  echo '- [ ] ~/.bashrc file in sync.'
  echo '      ! No .bashrc file found.'
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
# check ~/.config exists
if [ -d "$HOME/.config" ]; then
  echo '- [x] ~/.config directory exists.'
  #
  # check ~/.config/nvim is the same
  DIFF="$(diff -U3 --recursive "$HOME/.config/nvim" ./.config/nvim)"
  if [ "$?" = '1' ]; then
    echo '- [ ] ~/.config/nvim directory in sync.'
    DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
    EXIT_STATUS=1
  else
    echo '- [x] ~/.config/nvim directory in sync.'
  fi
  #
  # check ~/.config/kitty is the same
  DIFF="$(diff -U3 --recursive "$HOME/.config/kitty" ./.config/kitty)"
  if [ "$?" = '1' ]; then
    echo '- [ ] ~/.config/kitty directory in sync.'
    DIFF_OUT="$DIFF_OUT\n\n$DIFF\n"
    EXIT_STATUS=1
  else
    echo '- [x] ~/.config/kitty directory in sync.'
  fi
else
  echo '- [ ] ~/.config directory exists.'
  EXIT_STATUS=1
fi

echo "$DIFF_OUT"
exit $EXIT_STATUS
