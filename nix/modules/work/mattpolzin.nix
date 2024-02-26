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

  programs.direnv = { 
    enable = true;
    nix-direnv.enable = true;
  };
}
