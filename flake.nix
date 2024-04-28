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
    extraModuleInputs = [
      home-manager
      agenix
      nix-index-database
    ];
    defaultOrHead = dig: modules: modules.${dig}.default or (builtins.head (lib.attrValues modules.${dig}));
    commonConfiguration = {
      darwin = import ./nix/modules/common/darwin-system.nix;
      linux = import ./nix/modules/common/linux-system.nix;
    };
    workConfiguration = {
      darwin = import ./nix/modules/work/darwin-system.nix;
      linux = throw "no linux work machines to configure";
    };
    homeConfiguration = {
      darwin = import ./nix/modules/home/darwin-system.nix;
      linux = import ./nix/modules/home/linux-system.nix;
    };
    buildConfig = hostName: system: configs: let
      pkgs-edge = import ./nix/modules/common/nixpkgs-edge.nix {
        inherit system nixpkgs-edge;
      };
    in {
      modules = configs ++ [ pkgs-edge ];
      specialArgs = {inherit hostName system inputs;};
    };
    darwinConfig = hostName: system: config:
      nix-darwin.lib.darwinSystem
      (buildConfig hostName system ((map (c: c.darwin) [commonConfiguration config]) ++ (map (defaultOrHead "darwinModules") extraModuleInputs)));
    nixosConfig = hostName: system: config:
      # I don't think I want to stay on edge, but I am currently
      # using at least one nixos option not available in 23.11:
      nixpkgs-edge.lib.nixosSystem
      (buildConfig hostName system ((map (c: c.linux) [commonConfiguration config]) ++ (map (defaultOrHead "nixosModules") extraModuleInputs)));
  in {
    darwinConfigurations = {
      "MattPolzin-Home" = darwinConfig "MattPolzin-Home" "x86_64-darwin" homeConfiguration;

      "MattPolzin-Work-Laptop-Old" = darwinConfig "MattPolzin-Work-Laptop-Old" "x86_64-darwin" workConfiguration;
      "MattPolzin-Work-Laptop" = darwinConfig "MattPolzin-Work-Laptop" "aarch64-darwin" workConfiguration;
    };

    nixosConfigurations."MattPolzin-Scrappy" = nixosConfig "MattPolzin-Scrappy" "x86_64-linux" homeConfiguration;

    # Expose the package set, including overlays, for convenience.
    darwinWorkPackages = self.darwinConfigurations."MattPolzin-Work-Laptop".pkgs;
    darwinHomePackages = self.darwinConfigurations."MattPolzin-Home-Laptop".pkgs;
    nixosHomePackages = self.nixosConfigurations."MattPolzin-Scrappy".pkgs;

    # Expose nix-darwin
    packages = lib.genAttrs lib.platforms.darwin (system: nix-darwin.packages.${system});

    formatter = lib.genAttrs lib.systems.flakeExposed (system: alejandra.packages.${system}.default);
  };
}
