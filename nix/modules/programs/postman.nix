{
  lib,
  pkgs,
  config,
  system,
  ...
}:
let
  cfg = config.customize.postman;
  dist =
    {
      aarch64-darwin = {
        arch = "arm64";
        hash = "sha256-S8JCLE+XDG4kGh5GlwZdnwa72FrePnzouWJdhDyHj/k=";
        plat = "osx_";
        fmt = "zip";
      };

      x86_64-darwin = {
        arch = "64";
        hash = "";
        plat = "osx_";
        fmt = "zip";
      };

      x86_64-linux = {
        arch = "64";
        hash = "sha256-vmZYtSygAiEI5EHFr4uvzsJdUyWPwH0Gajl3dfUaeKA=";
        plat = "linux";
        fmt = "tar.gz";
      };
    }
    .${system} or (throw "Unsupported system: ${system}");
  postman = pkgs.postman;
  postman' = postman.overrideAttrs rec {
    version = "11.9.0";
    name = "${postman.pname}-${version}";
    src = pkgs.fetchurl {
      url = "https://dl.pstmn.io/download/version/${version}/${dist.plat}${dist.arch}";
      inherit (dist) hash;
      name = "${postman.pname}-${version}.${dist.fmt}";
    };
  };
in
{
  options = {
    customize = {
      postman.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = {
    environment.systemPackages = lib.optionals cfg.enable [ postman' ];
  };
}
