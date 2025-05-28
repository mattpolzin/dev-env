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
  pkgs-edge,
  config,
  ...
}:
let
  dbcooper = pkgs.rPackages.buildRPackage {
    name = "dbcooper";
    src = pkgs.fetchFromGitHub {
      owner = "pipeline-tools";
      repo = "dbcooper";
      rev = "2ad5a005e0d8a1eb4d5a583c5d0a0699ba1a05d9";
      sha256 = "sha256-Nhfa2XddxMj0yb/AZoPnfyLjn4f7OoHuSwDn+n7dABM=";
    };
    propagatedBuildInputs = with pkgs.rPackages; [
      dplyr
      DBI
      purrr
      dbplyr
      snakecase
    ];
  };
  opalr = pkgs.rPackages.buildRPackage {
    name = "opalr";
    src = builtins.fetchGit {
      url = "ssh://git@github.com/opallabs/opalr.git";
      rev = "0c0c01d2866d9f02f6593f9f437ac659ba8ba6ba";
    };
    propagatedBuildInputs =
      (with pkgs.rPackages; [
        dplyr
        ggplot2
        DBI
        odbc
        RPostgres
        magrittr
        stringr
        rlang
      ])
      ++ [ dbcooper ];
  };
  rApp = import ../../apps/R.nix {
    inherit pkgs;
    additionalRPackages = [
      dbcooper
      opalr
    ];
  };
in
{
  users.primary = "mattpolzin";
  home-manager.users.${config.users.primary} = import ./mattpolzin.nix;

  # List packages installed in system profile.
  environment.systemPackages = [
    # Shell (only at work)
#    rApp.R # <- broken
    pkgs-edge.openvpn
    pkgs.azure-cli
    pkgs.azure-storage-azcopy
    pkgs.direnv
    pkgs.drawio
    pkgs.ffmpeg
    pkgs.kubernetes-helm
    pkgs.kubeseal
    pkgs.mutagen
    pkgs.terraform
    pkgs.unixODBC
    pkgs._1password-gui
    pkgs._1password-cli

    # GUI (only at work)
    pkgs.vscode
  ];

  programs.direnv.enable = true;

  homebrew.taps = [ "garden-io/garden" ];
  homebrew.casks = [ ];
  homebrew.brews = [ "garden-cli" ];

  age.secrets.etcHosts.file = ../../../secrets/etc-hosts.age;
  environment.etc.hosts = {
    source = config.age.secrets.etcHosts.path;
  };
}
