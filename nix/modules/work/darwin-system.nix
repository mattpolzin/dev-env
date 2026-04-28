## 1-3: See ../shared/darwin-system.nix
## 5. Set new laptop's hostname to 'MattPolzin-Work-Laptop'
##    `sudo scutil --set HostName MattPolzin-Work-Laptop`
##    `sudo scutil --set LocalHostName MattPolzin-Work-Laptop`
##
## Additional initial setup after using nix-darwin on new computer:
## 6. Install Docker for Mac (not available in app store, brew, or nixpkgs)
## 7. Install R Studio
## 8. Install Slack via App Store or "SelfService++"
## 9. Snag ovpn files from old computer
## 10. `source ${HOME}/staging/dev-env/openvpn/connect-util` from `.zprofile`
##     or `.profile` and set up aliases like the following (may just be 
##     copied from old computer):
##       `alias vpn-dev="one_pass_ovpn_connect 123456789.ovpn mpolzin abcd1234"`
## 11. Optionally create .envrc file in repos (e.g. "use nix")
## 12-14: See ../shared/darwin-system.nix
##
##
## NOTE:
## We can't store open-vpn configs or creds in this repo (even encrypted)
## because of company policy.
## We still can use the helpers in .ovpn-connect to connect using open-vpn
## having only copied the VPN profiles from an old laptop and grabbed dev-keys
## for the 1Password entries related to each VPN.
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
    src = fetchGit {
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
    pkgs-edge.postgresql
    pkgs-edge.spicedb
#    pkgs.azure-cli # <- hanging while building a dependency
    pkgs.azure-storage-azcopy
    pkgs.csvkit
    pkgs.direnv
    pkgs.drawio
    pkgs.ffmpeg
    pkgs.kubernetes-helm
    pkgs.kubeseal
    pkgs.mutagen
    pkgs.terraform
    pkgs.unixODBC

    # GUI (only at work)
    pkgs.vscode
  ];

  programs.direnv.enable = true;

  homebrew.taps = [ "garden-io/garden" ];
  homebrew.casks = [
    "1password"
    "1password-cli"
  ];
  homebrew.brews = [ "garden-cli@0.13" ];

  nix = {
    settings = {
      substituters = [
        "https://gh-harmony.cachix.org"
        "https://gh-nix-idris2-packages.cachix.org"
      ];

      trusted-public-keys = [
        "gh-harmony.cachix.org-1:KX5tTtEt3Y6an8pywe3Cy6jR9bUo+1Cl7hJmh+5eI4I="
        "gh-nix-idris2-packages.cachix.org-1:iOqSB5DrESFT+3A1iNzErgB68IDG8BrHLbLkhztOXfo="
      ];
    };
  };

  age.secrets.etcHosts.file = ../../../secrets/etc-hosts.age;
  environment.etc.hosts = {
    source = config.age.secrets.etcHosts.path;
  };
}
