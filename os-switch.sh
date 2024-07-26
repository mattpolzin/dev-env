#!/bin/sh

set -eu -o pipefail

eval LAST_VERSION_BEFORE=("$(ls /nix/var/nix/profiles | cut -c 8-100 | sort -h | tail -1)")

if [ "$(command -v darwin-rebuild)" = '' ]; then
  rebuild="sudo nixos-rebuild"
else
  rebuild="darwin-rebuild"
fi

$rebuild switch --flake . --keep-going

eval LAST_VERSION_AFTER=("$(ls /nix/var/nix/profiles | cut -c 8-100 | sort -h | tail -1)")

if [ "${LAST_VERSION_BEFORE}" = "${LAST_VERSION_AFTER}" ]; then
  echo ''
  echo 'No system changes needed.'
else
  ./nix-diff.sh
fi
