{lib, pkgs, config, options, ...}:
let
  cfg = config.customize.googleChrome;
in
{
  options = {
    customize = { 
      googleChrome.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = {
    networking = lib.optionalAttrs pkgs.stdenv.isLinux {
      firewall = lib.optionalAttrs cfg.enable {
        allowedTCPPorts = [ 8008 8009 ];
        allowedUDPPorts = [ 53 10008 1900 ];
        allowedUDPPortRanges = [ { from = 32768; to = 61000; } ];
      };
    };

  environment.systemPackages = 
    lib.optionals (pkgs.stdenv.isLinux && cfg.enable) [
    pkgs.google-chrome
  ];
  } // lib.optionalAttrs (options ? homebrew) {
    homebrew.casks = lib.optionals cfg.enable [
      "google-chrome"
    ];
  };
}
