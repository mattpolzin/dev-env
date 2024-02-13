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
  users.primary = "mattpolzin";
  home-manager.users.${config.users.primary} = import ./mattpolzin.nix;

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
}
