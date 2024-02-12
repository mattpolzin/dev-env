## 1-3: See ../common/system.nix
## 4. Set new laptop's hostname to 'MattPolzin-Work-Laptop'
##    `sudo scutil --set HostName MattPolzin-Work-Laptop`
##    `sudo scutil --set LocalHostName MattPolzin-Work-Laptop`
##
## Additional initial setup after using nix-darwin on new computer:
## 4. Install Docker for Mac (not available in app store, brew, or nixpkgs)
## 5. Install R Studio
## 6. Snag ovpn files from old computer
## 7. Optionally create .envrc file in repos (e.g. "use nix")
## 8-10: See ../common/system.nix
##
##
## NOTE:
## can't store configs or creds in this repo (even encrypted).
## still can use roughly the following to control VPN connection from shell,
## just need to copy the ovpn files and snag the credentials from the old laptop.
##
##    sudo openvpn --config "$(pwd)/openvpn/profiles/whatever.ovpn" \
##                 --auth-user-pass "$(pwd)/openvpn/creds/whatever.creds" \
##                 --auth-retry interact \
##                 --up "$(pwd)/openvpn_up.sh" --down "$(pwd)/openvpn_down.sh" \
##                 --script-security 2
##
{
  pkgs,
  system,
  inputs,
  config,
  ...
}: let
  pkgs-edge = import inputs.nixpkgs-edge {inherit (pkgs) system config;};
in {
  users.users.mattpolzin = {
    home = "/Users/mattpolzin";
  };
  home-manager.users.mattpolzin = import ./mattpolzin.nix;

  # List packages installed in system profile.
  environment.systemPackages = [
    # Shell (only at work)
    pkgs.R
    pkgs.azure-cli
    pkgs.direnv
    pkgs.ffmpeg
    pkgs.kubernetes-helm
    pkgs.kubeseal
    pkgs.mutagen
    pkgs.openvpn
    pkgs.terraform

    # GUI (only at work)
    pkgs.vscode

    # Shell (Disabled)
    # -- Empty --
  ];

  homebrew.taps = [
    "garden-io/garden"
  ];
  homebrew.casks = [
    "1password"
    "1password-cli"
    "google-chrome"
  ];
  homebrew.brews = [
    "garden-cli"
  ];

  networking = rec {
    computerName = "MattPolzin-Work-Laptop";
    hostName = computerName;
    localHostName = computerName;
  };

  age.secrets.etcHosts.file = ../../../secrets/etc-hosts.age;
  environment.etc.hosts = {
    source = config.age.secrets.etcHosts.path;
  };

  # Nix-darwin does not link installed applications to the user environment. This means apps will not show up
  # in spotlight, and when launched through the dock they come with a terminal window. This is a workaround.
  # Upstream issue: https://github.com/LnL7/nix-darwin/issues/214
  # Issue: https://github.com/LnL7/nix-darwin/issues/139
  system.activationScripts.applications.text = ''
    echo "setting up ~/Applications..." >&2
    applications="${config.users.users.mattpolzin.home}/Applications"
    nix_apps="$applications/Nix Apps"

    # Delete the directory to remove old links
    rm -rf "$nix_apps"

    # Needs to be writable so that nix-darwin can symlink into it
    mkdir -p "$nix_apps"
    chown ${config.users.users.mattpolzin.name}: "$nix_apps"
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
