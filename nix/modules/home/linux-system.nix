{ pkgs, pkgs-edge, config, ... }:
{
  imports = [
    ../shared/hardware/framework-hardware-configuration.nix
    ../shared/hardware/framework-hardware-extra.nix
  ];

  users.primary = "matt";
  home-manager.users.${config.users.primary} = import ./mattpolzin.nix;
  home-manager.extraSpecialArgs = {
    aercAccountsPath = config.age.secrets.aercAccounts.path;
  };

  # List packages installed in system profile.
  environment.systemPackages = [
    # Shell (only at home)
    pkgs-edge.colima
    pkgs.docker
    pkgs.texliveSmall

    # GUI (only at home)
    pkgs.discord
  ];

  customize.spotify.gui.enable = false;

  age.secrets.wpaSupplicantConfig.file = ../../../secrets/wpa-supplicant-conf.age;

  networking.supplicant."wlp1s0" = {
    configFile.path = config.age.secrets.wpaSupplicantConfig.path;
    userControlled.group = "network";
  };

  age.secrets.aercAccounts = {
    file = ../../../secrets/aerc-accounts.age;
    owner = "${config.users.primary}";
  };

  nix = {
    nixPath = [
      "nixpkgs=flake:nixpkgs:/nix/var/nix/profiles/per-user/root/channels"
      "nixpkgs2=$HOME/staging/nixpkgs"
    ];

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
}
