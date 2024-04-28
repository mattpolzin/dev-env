{
  pkgs,
  system,
  inputs,
  config,
  ...
}: {
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
  ];

  nix = {
    nixPath = [
      "nixpkgs2=$HOME/staging/nixpkgs2"
    ];
  };
}
