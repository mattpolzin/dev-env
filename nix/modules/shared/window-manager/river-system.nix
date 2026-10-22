{ pkgs, config, pkgs-edge, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "${config.users.primary}";
      };
    };
  };
  programs.regreet = {
    enable = true;
    package = pkgs.regreet;
    settings = {
      background = {
        path = ../../../../images/login-background.jpg;
        fit = "Fill";
      };
      GTK = {
        application_prefer_dark_theme = true;
      };
    };
  };

  programs.river-classic = {
    enable = true;
    extraPackages = [
      pkgs.wl-clipboard
      pkgs.tofi
      pkgs.swaybg
    ];
  };
  programs.waybar.enable = true;

  # required for waybar:
  xdg.portal.wlr.enable = true;
}
