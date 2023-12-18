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
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MattPolzin-MacBook-Pro
    darwinConfigurations."MattPolzin-Work-Laptop" = nix-darwin.lib.darwinSystem {
      modules = [ 
        home-manager.darwinModules.default
        agenix.darwinModules.default
        nix-index-database.darwinModules.nix-index
        workConfiguration
      ];
      specialArgs = { inherit inputs; };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MattPolzin-Work-Laptop".pkgs;
  };
}
