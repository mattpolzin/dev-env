{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.11";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, agenix }:
  let
    workConfiguration = import ./work-configuration.nix;
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MattPolzin-MacBook-Pro
    darwinConfigurations."MattPolzin-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
        agenix.darwinModules.default
        workConfiguration
      ];
      specialArgs = { inherit inputs; };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MattPolzin-MacBook-Pro".pkgs;
  };
}
