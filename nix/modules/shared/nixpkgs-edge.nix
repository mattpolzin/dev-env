let
  extraNixpkgsEdgePatches = [ ];
  extraNixpkgsEdgeOverlays = [ ];
in
{ nixpkgs-edge, 
  patches ? [],
  overlays ? [],
system }:
let
  nixpkgsEdgePatched = (import nixpkgs-edge { inherit system; }).applyPatches {
    name = "nixpkgs-patched";
    src = nixpkgs-edge;
    patches = patches ++ extraNixpkgsEdgePatches;
  };
in
{ pkgs, ... }:
let
  pkgs-edge = import nixpkgsEdgePatched {
    inherit (pkgs) system config;
    overlays = overlays ++ extraNixpkgsEdgeOverlays;
  };
in
{
  _module.args = {
    inherit pkgs-edge;
  };
}
