# I never completed the Sway config because I like River more.
# Leaving this here as a starting place if I ever want to explore again.
{pkgs, ...}: {
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
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
