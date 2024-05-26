{ lib, config, pkgs, ... }:
let
  cfg = config.personal.kubernetes;
in
{
  options = {
    personal = { 
      kubernetes.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = {
    assertions = [
      { assertion = cfg.enable -> !pkgs.stdenv.isDarwin;
        message = "kubernetes config only supports non-Darwin OSes";
      }
    ];

    # packages for administration tasks
    environment.systemPackages = lib.mkIf cfg.enable (with pkgs; [
      kubectl
      kubernetes
    ]);

    services.kubernetes = lib.mkIf cfg.enable {
      roles = ["master" "node"];
      masterAddress = "localhost";
      easyCerts = true;

      # use coredns
#      addons.dns.enable = true;

      # needed if you use swap
      kubelet.extraOpts = "--fail-swap-on=false";
    };
  };
}
