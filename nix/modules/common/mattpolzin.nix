{
  lib,
  pkgs,
  neovimApp,
  ...
}:
let
  commonDirectFileSources = (import ../../common-home-files.nix) // neovimApp.homeManagerConfigs;
  directFileSources =
    commonDirectFileSources
    // lib.optionalAttrs pkgs.stdenv.isLinux (import ../../linux-home-files.nix);
in
{
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        indent_style = "space";
        indent_size = 2;
      };
    };
  };

  home.stateVersion = "23.11";

  # programs to manage configs for:
  programs.neovim = {
    enable = true;
    inherit (neovimApp) package plugins extraLuaPackages;
    extraConfig = neovimApp.homeManagerExtraConfig;
  };

  programs.git = {
    enable = true;
    userName = "Mathew Polzin";
    lfs.enable = lib.mkDefault true;

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      rerere.enabled = true;
    };
  };

  # additional configs to manage:
  home.file = directFileSources;

  targets = lib.optionalAttrs pkgs.stdenv.isDarwin { darwin.search = "DuckDuckGo"; };
}
