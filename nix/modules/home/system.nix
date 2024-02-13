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
    home = "/Users/matt";
    name = "matt";
  };
  home-manager.users.mattpolzin = import ./mattpolzin.nix;

  # List packages installed in system profile.
  environment.systemPackages = [
    # Shell (only at home)
    pkgs.colima
    pkgs.docker
    pkgs.texliveSmall

    # GUI (only at home)
    pkgs.discord
    pkgs.spotify

    # Shell (Disabled)
    # ...
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
}
