{ pkgs, config, ... }:
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
    settings = {
      GTK = {
        application_prefer_dark_theme = true;
      };
    };
  };

  programs.river = {
    enable = true;
    extraPackages = with pkgs; [
      wl-clipboard
      tofi
    ];
  };
  programs.waybar.enable = true;
}
