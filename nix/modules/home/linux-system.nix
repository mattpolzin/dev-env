{
  pkgs,
  system,
  inputs,
  config,
  ...
}: {
  imports = [
    ./framework-hardware-configuration.nix
    ./framework-hardware-extra.nix
  ];

  users.primary = "matt";
  home-manager.users.${config.users.primary} = import ./mattpolzin.nix;
  home-manager.extraSpecialArgs = { aercAccountsPath = config.age.secrets.aercAccounts.path; };

  # List packages installed in system profile.
  environment.systemPackages = [
    # Shell (only at home)
    pkgs.colima
    pkgs.docker
    pkgs.texliveSmall

    # GUI (only at home)
    pkgs.discord
    pkgs.spotify
  ];

#  programs.googleChrome.enable = true;

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
  };
}
