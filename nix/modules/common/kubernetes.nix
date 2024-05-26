{ lib, config, pkgs, ... }:
let
  # When using easyCerts=true the IP Address must resolve to the master on creation.
 # So use simply 127.0.0.1 in that case. Otherwise you will have errors like this https://github.com/NixOS/nixpkgs/issues/59364
  kubeMasterIP = "10.1.1.2";
  kubeMasterHostname = "api.kube";
  kubeMasterAPIServerPort = 6443;

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

    # resolve master hostname
    networking.extraHosts = lib.mkIf cfg.enable "${kubeMasterIP} ${kubeMasterHostname}";

    # packages for administration tasks
    environment.systemPackages = lib.mkIf cfg.enable (with pkgs; [
      kubectl
      kubernetes
    ]);

    services.kubernetes = lib.mkIf cfg.enable {
      roles = ["master" "node"];
      masterAddress = kubeMasterHostname;
      apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
      easyCerts = true;
      apiserver = {
        securePort = kubeMasterAPIServerPort;
        advertiseAddress = kubeMasterIP;
      };

      # use coredns
      addons.dns.enable = true;

      # needed if you use swap
      kubelet.extraOpts = "--fail-swap-on=false";
    };
  };
}
