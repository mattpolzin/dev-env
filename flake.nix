{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.11";
    nixpkgs-edge.url = "github:NixOS/nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    harmony.url = "github:mattpolzin/harmony";
    harmony.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-edge, nix-darwin, home-manager, agenix, harmony, nix-index-database }:
  let
    workConfiguration = import ./work-configuration.nix;
    darwinConfig = system: config: nix-darwin.lib.darwinSystem {
      modules = [ 
        home-manager.darwinModules.default
        agenix.darwinModules.default
        nix-index-database.darwinModules.nix-index
        config
      ];
      specialArgs = { inherit system inputs; };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .
    darwinConfigurations."MattPolzin-Work-Laptop-Old" = darwinConfig "x86_64-darwin" workConfiguration;
    darwinConfigurations."MattPolzin-Work-Laptop" = darwinConfig "aarch64-darwin" workConfiguration;

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MattPolzin-Work-Laptop-Old".pkgs;

    # Expose nix-darwin
    packages = nix-darwin.packages;
  };
}
