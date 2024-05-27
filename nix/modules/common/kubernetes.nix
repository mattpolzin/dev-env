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

    environment.variables = {
      KUBECONFIG = "/etc/${toString config.services.kubernetes.pki.etcClusterAdminKubeconfig}";
    };

    services.kubernetes = lib.mkIf cfg.enable {
      roles = ["master" "node"];
      masterAddress = "localhost";

      kubelet.hostname = lib.toLower config.networking.fqdnOrHostName;

      # needed if you use swap
      kubelet.extraOpts = "--fail-swap-on=false";
    };
  };
}
