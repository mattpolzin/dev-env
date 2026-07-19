let
  extraNixpkgsEdgePatches = [ ];
  extraNixpkgsEdgeOverlays = [ ];
in
{ nixpkgs-edge, 
  patches ? [],
  patchCommits ? [], # [{ fork = "mattpolzin"; commit = "97dd352dc415e846fb278b773ff476bb38a80afb"; hash = ""; }]
  overlays ? [],
system }:
let
  nixpkgs = import nixpkgs-edge { inherit system; };
  commitPatches = map ({fork ? "nixos", commit, hash}: nixpkgs.fetchpatch2 {url = "https://github.com/${fork}/nixpkgs/commit/${commit}.patch"; inherit hash;}) patchCommits;
  nixpkgsEdgePatched = nixpkgs.applyPatches {
    name = "nixpkgs-patched";
    src = nixpkgs-edge;
    patches = patches ++ commitPatches ++ extraNixpkgsEdgePatches;
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
