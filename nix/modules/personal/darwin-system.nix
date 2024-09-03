{
  pkgs,
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
  ];

  customize.spotify.gui.enable = true;

  homebrew.masApps = {
    "Pixelmator Pro" = 1289583905;
    "Affinity Publisher" = 881418622;
  };

  nix = {
    nixPath = [
      {nixpkgs2 = "$HOME/staging/nixpkgs2";}
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
