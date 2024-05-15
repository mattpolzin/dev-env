{ pkgs, ... }:
{
  programs.river = {
    enable = true;
    extraPackages = with pkgs; [
#      swaymonad
      wl-clipboard
      tofi
#      wlgreet
    ];
  };
  programs.waybar.enable = true;
}
