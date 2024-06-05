{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.customize.kubernetes;
in {
  options = {
    customize = {
      kubernetes.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.enable -> !pkgs.stdenv.isDarwin;
        message = "kubernetes config only supports non-Darwin OSes";
      }
    ];

    # packages for administration tasks
    environment.systemPackages = lib.mkIf cfg.enable (with pkgs; [
      kubectl
      kubernetes
    ]);

    environment.variables = lib.optionalAttrs cfg.enable {
      KUBECONFIG = "/etc/${toString config.services.kubernetes.pki.etcClusterAdminKubeconfig}";
    };

    services = lib.optionalAttrs cfg.enable {
      kubernetes = {
        roles = ["master" "node"];
        masterAddress = "localhost";

        kubelet.hostname = lib.toLower config.networking.fqdnOrHostName;

        # needed if you use swap
        kubelet.extraOpts = "--fail-swap-on=false";
      };
    };
  };
}
