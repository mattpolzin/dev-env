let
  nixpkgs-edge-patches = [];
  nixpkgs-edge-overlays = [];
in
  {
    nixpkgs-edge,
    system,
  }: let
    nixpkgs-edge-patched = (import nixpkgs-edge {inherit system;}).applyPatches {
      name = "nixpkgs-patched";
      src = nixpkgs-edge;
      patches = nixpkgs-edge-patches;
    };
  in
    {pkgs, ...}: let
      pkgs-edge = import nixpkgs-edge-patched {
        inherit (pkgs) system config;
        overlays = nixpkgs-edge-overlays;
      };
    in {
      _module.args = {inherit pkgs-edge;};
    }
