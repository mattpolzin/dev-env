{ pkgs, ... }:
{
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
#      swaymonad
      wl-clipboard
      wmenu
#      wlgreet
    ];
  };
  programs.waybar.enable = true;

  environment.systemPackages = [
    pkgs.foot
  ];
}
