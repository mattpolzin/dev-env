{
  pkgs,
  pkgs-edge,
  neovim,
  ...
}:
{
  imports = [
    ../common/mattpolzin.nix
  ];

  # additional configs to manage:
  home.file.".config/ghostty" = {
    source = ../../../.config/ghostty;
    recursive = true;
  };
}
