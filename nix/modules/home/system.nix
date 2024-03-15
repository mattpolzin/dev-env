{
  pkgs,
  system,
  inputs,
  config,
  nixpkgs-edge,
  nixpkgs-edge-overlays,
  ...
}: let
  pkgs-edge = import nixpkgs-edge {inherit (pkgs) system config; overlays = nixpkgs-edge-overlays; };
in {
  users.primary = "matt";
  home-manager.users.${config.users.primary} = import ./mattpolzin.nix;

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
