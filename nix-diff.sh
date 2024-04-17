#!/bin/sh

ls /nix/var/nix/profiles | cut -c 8-100 | sort -h -r | head -2 | xargs -I {} echo '/nix/var/nix/profiles/system-{}' | xargs -L 2 nix run nixpkgs#nvd -- diff
