{ ... }:
{
  imports = [ ../shared/mattpolzin.nix ];

  programs.git.settings.user = {
    email = "mpolzin@workwithopal.com";
  };
}
