{
  pkgs,
  system,
  inputs,
  config,
  ...
}: let
  pkgs-edge = import inputs.nixpkgs-edge {inherit (pkgs) system config;};
in {
  users.users.matt = {
    home = "/Users/matt";
  };
  home-manager.users.matt = import ./mattpolzin.nix;

  # List packages installed in system profile.
  environment.systemPackages = [
    # Shell (only at home)
    # ...

    # GUI (only at home)
    # ...

    # Shell (Disabled)
    # -- Empty --
  ];

  homebrew.masApps = {
    "Pixelmator Pro" = 1289583905;
    "Affinity Publisher" = 881418622;
  };

  networking = rec {
    computerName = "MattPolzin-Home";
    hostName = computerName;
    localHostName = computerName;
  };

  # Nix-darwin does not link installed applications to the user environment. This means apps will not show up
  # in spotlight, and when launched through the dock they come with a terminal window. This is a workaround.
  # Upstream issue: https://github.com/LnL7/nix-darwin/issues/214
  # Issue: https://github.com/LnL7/nix-darwin/issues/139
  system.activationScripts.applications.text = ''
    echo "setting up ~/Applications..." >&2
    applications="${config.users.users.matt.home}/Applications"
    nix_apps="$applications/Nix Apps"

    # Delete the directory to remove old links
    rm -rf "$nix_apps"

    # Needs to be writable so that nix-darwin can symlink into it
    mkdir -p "$nix_apps"
    chown ${config.users.users.matt.name}: "$nix_apps"
    chmod u+w "$nix_apps"

    find ${config.system.build.applications}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read src; do
            # Spotlight does not recognize symlinks, it will ignore directory we link to the applications folder.
            # It does understand MacOS aliases though, a unique filesystem feature. Sadly they cannot be created
            # from bash (as far as I know), so we use the oh-so-great Apple Script instead.
            /usr/bin/osascript -e "
                set fileToAlias to POSIX file \"$src\"
                set applicationsFolder to POSIX file \"$nix_apps\"
                tell application \"Finder\"
                    make alias file to fileToAlias at applicationsFolder
                    # This renames the alias; 'mpv.app alias' -> 'mpv.app'
                    set name of result to \"$(rev <<< "$src" | cut -d'/' -f1 | rev)\"
                end tell
            " 1>/dev/null
        done
  '';
}
