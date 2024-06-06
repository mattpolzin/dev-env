{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.customize.spotify;
in {
  options.customize.spotify = {
    gui.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    cli.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    environment.systemPackages =
      lib.optional cfg.cli.enable pkgs.spotify-player
      ++ lib.optional cfg.gui.enable pkgs.spotify;
  };
}
