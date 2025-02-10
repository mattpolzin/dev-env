{
  description = "Nixos/Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    nixpkgs-edge.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "nix-darwin";
    agenix.inputs.home-manager.follows = "home-manager";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # don't follow anything for idris2-packages so we can take
    # advantage of the Cachix cache.
    idris2-packageset.url = "github:mattpolzin/nix-idris2-packages";

    harmony.url = "github:mattpolzin/harmony";
    harmony.inputs.nixpkgs.follows = "nixpkgs";
    harmony.inputs.packageset.follows = "idris2-packageset";

    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
    neorg-overlay.inputs.nixpkgs.follows = "nixpkgs-edge";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      agenix,
      nix-index-database,
      nixpkgs,
      nixpkgs-edge,
      neorg-overlay,
      ...
    }:
    let
      lib = nixpkgs.lib;
      extraModuleInputs = [
        home-manager
        agenix
        nix-index-database
      ];
      defaultOrHead =
        dig: modules: modules.${dig}.default or (builtins.head (lib.attrValues modules.${dig}));
      commonConfiguration = {
        darwin = import ./nix/modules/common/darwin-system.nix;
        linux = import ./nix/modules/common/linux-system.nix;
      };
      workConfiguration = {
        darwin = import ./nix/modules/work/darwin-system.nix;
        linux = throw "no linux work machines to configure";
      };
      personalConfiguration = {
        darwin = import ./nix/modules/personal/darwin-system.nix;
        linux = import ./nix/modules/personal/linux-system.nix;
      };
      buildConfig =
        hostName: system: configs:
        let
          pkgs-edge = import ./nix/modules/common/nixpkgs-edge.nix { inherit system nixpkgs-edge; overlays = [ neorg-overlay.overlays.default ]; };
        in
        {
          modules = configs ++ [ pkgs-edge ];
          specialArgs = {
            inherit hostName system inputs;
          };
        };
      darwinConfig =
        hostName: system: config: extraModules:
        nix-darwin.lib.darwinSystem (
          buildConfig hostName system (
            (map (c: c.darwin) [
              commonConfiguration
              config
            ])
            ++ (map (defaultOrHead "darwinModules") extraModuleInputs)
            ++ [ extraModules ]
          )
        );
      nixosConfig =
        hostName: system: config: extraModules:
        nixpkgs.lib.nixosSystem (
          buildConfig hostName system (
            (map (c: c.linux) [
              commonConfiguration
              config
            ])
            ++ (map (defaultOrHead "nixosModules") extraModuleInputs)
            ++ [ extraModules ]
          )
        );

      eachSystem = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      darwinConfigurations = {
        "MattPolzin-Home" =
          darwinConfig "MattPolzin-Home" "x86_64-darwin" personalConfiguration
            { };

        "MattPolzin-Work-Laptop-Old" =
          darwinConfig "MattPolzin-Work-Laptop-Old" "x86_64-darwin" workConfiguration
            { };
        "MattPolzin-Work-Laptop" =
          darwinConfig "MattPolzin-Work-Laptop" "aarch64-darwin" workConfiguration
            { };
      };

      nixosConfigurations."MattPolzin-Scrappy" =
        nixosConfig "MattPolzin-Scrappy" "x86_64-linux" personalConfiguration
          {
            customize.googleChrome.enable = false;
            customize.kubernetes.enable = false;
          };

      # Expose the package set, including overlays, for convenience.
      darwinWorkPackages = self.darwinConfigurations."MattPolzin-Work-Laptop".pkgs;
      darwinHomePackages = self.darwinConfigurations."MattPolzin-Home-Laptop".pkgs;
      nixosHomePackages = self.nixosConfigurations."MattPolzin-Scrappy".pkgs;

      # Expose nix-darwin
      packages = lib.genAttrs lib.platforms.darwin (system: nix-darwin.packages.${system});

      formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
