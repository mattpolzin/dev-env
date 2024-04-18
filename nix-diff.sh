#!/bin/sh

eval LAST_TWO_VERSIONS=("$(ls /nix/var/nix/profiles | cut -c 8-100 | sort -h -r | head -2 | sort -h)")

if [ ! -z "$1" ]; then
  LOWER_BOUND="/nix/var/nix/profiles/system-$1-link"
else
  LOWER_BOUND="/nix/var/nix/profiles/system-${LAST_TWO_VERSIONS[0]}"
fi

if [ ! -z "$2" ]; then
  UPPER_BOUND="/nix/var/nix/profiles/system-$2-link"
else
  UPPER_BOUND="/nix/var/nix/profiles/system-${LAST_TWO_VERSIONS[1]}"
fi

echo $LOWER_BOUND
echo $UPPER_BOUND

nix run nixpkgs#nvd -- diff "${LOWER_BOUND}" "${UPPER_BOUND}"
