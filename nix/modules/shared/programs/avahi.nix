{
  lib,
  config,
  ...
}:
let
  cfg = config.customize.avahi;
in
{
  options.customize.avahi = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    services.avahi = {
      enable = cfg.enable;
      nssmdns4 = cfg.enable;
      openFirewall = cfg.enable;
    };
  };
}
