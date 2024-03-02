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

  programs.git = {
    userEmail = "mpolzin@workwithopal.com";
  };
}
