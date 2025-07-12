{ ... }:
{
  imports = [ ../shared/mattpolzin.nix ];

  programs.git = {
    userEmail = "mpolzin@workwithopal.com";
  };
}
