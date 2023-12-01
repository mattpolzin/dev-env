{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    workConfiguration = import ./work-configuration.nix;
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MattPolzin-MacBook-Pro
    darwinConfigurations."MattPolzin-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ workConfiguration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MattPolzin-MacBook-Pro".pkgs;
  };
}
