{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    nixpkgs-edge.url = "github:NixOS/nixpkgs";

    alejandra.url = "github:kamadorueda/alejandra";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "nix-darwin";
    agenix.inputs.home-manager.follows = "home-manager";

    harmony.url = "github:mattpolzin/harmony";
    harmony.inputs.nixpkgs.follows = "nixpkgs-edge";
    harmony.inputs.alejandra.follows = "alejandra";

    idris.url = "github:idris-lang/Idris2";
    idris.inputs.nixpkgs.follows = "nixpkgs-edge";

    idris-lsp.url = "github:idris-community/idris2-lsp";
    idris-lsp.inputs.nixpkgs.follows = "nixpkgs-edge";
    idris-lsp.inputs.idris.follows = "idris";
    idris-lsp.inputs.alejandra.follows = "alejandra";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    alejandra,
    nix-darwin,
    home-manager,
    agenix,
    nix-index-database,
    nixpkgs,
    nixpkgs-edge,
    ...
  }: let
    lib = nixpkgs.lib;
    commonConfiguration = import ./nix/modules/common/system.nix;
    workConfiguration = import ./nix/modules/work/system.nix;
    homeConfiguration = import ./nix/modules/home/system.nix;
    buildConfig = system: config: let
      pkgs-edge = import ./nix/modules/common/nixpkgs-edge.nix {
        inherit system nixpkgs-edge;
      };
    in {
      modules = [
        home-manager.darwinModules.default
        agenix.darwinModules.default
        nix-index-database.darwinModules.nix-index
        commonConfiguration
        config
        pkgs-edge
      ];
      specialArgs = {inherit system inputs;};
    };
    darwinConfig = system: config:
      nix-darwin.lib.darwinSystem (buildConfig system config);
  in {
    darwinConfigurations."MattPolzin-Home" = darwinConfig "x86_64-darwin" homeConfiguration;

    darwinConfigurations."MattPolzin-Work-Laptop-Old" = darwinConfig "x86_64-darwin" workConfiguration;
    darwinConfigurations."MattPolzin-Work-Laptop" = darwinConfig "aarch64-darwin" workConfiguration;

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MattPolzin-Work-Laptop-Old".pkgs;

    # Expose nix-darwin
    packages = nix-darwin.packages;

    formatter = lib.genAttrs lib.systems.flakeExposed (system: alejandra.packages.${system}.default);
  };
}
