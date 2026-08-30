{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.customize.ifuse;
in
{
  options = {
    customize = {
      ifuse.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = {
    assertions = [ ];

    # packages for administration tasks
    environment.systemPackages = lib.mkIf cfg.enable (
      with pkgs;
      [
        libimobiledevice
        ifuse
      ]
    );

    services = lib.optionalAttrs cfg.enable {
      usbmuxd = {
        enable = true;
        package = pkgs.usbmuxd2;
      };
    };
  };
}
