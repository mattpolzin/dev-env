{ ... }:
{
  imports = [ ../shared/mattpolzin.nix ];

  programs.git.settings.user = {
    email = "matt.polzin@zoominfo.com";
  };
}
