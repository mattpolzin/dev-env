{ pkgs, ... }:
{
  services.displayManager.defaultSession = "none+xmonad";

  services.xserver = {
    enable = true;
    dpi = 180;
    displayManager.lightdm = {
      enable = true;
      extraConfig = ''
        logind-check-graphical = true
      '';
    };
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad
        haskellPackages.xmonad-contrib
        haskellPackages.xmobar
      ];
    };
    displayManager.gdm.enable = false;
    desktopManager.gnome.enable = false;
  };

  environment.systemPackages = [
    pkgs.xmobar # <- needed to get xmobar bin directory in PATH
    pkgs.xclip
    pkgs.dmenu
    pkgs.gmrun
  ];
}
