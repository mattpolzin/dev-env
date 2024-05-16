{ pkgs, config, ... }:
let
  greetConfig = pkgs.writeText "greetd-sway-config" ''
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"

    bindsym Mod4+Shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'

    include /etc/sway/config.d/*
  '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --config ${greetConfig}";
        user = "${config.users.primary}";
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    river
    sway
    zsh
  '';

  programs.river = {
    enable = true;
    extraPackages = with pkgs; [
      wl-clipboard
      tofi
    ];
  };
  programs.waybar.enable = true;
}
