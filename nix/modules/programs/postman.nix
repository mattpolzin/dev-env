{
  lib,
  pkgs,
  config,
  system,
  ...
}: let
  cfg = config.customize.postman;
  dist =
    {
      aarch64-darwin = {
        arch = "arm64";
        sha256 = "sha256-V+JLXl12DnwZlPF0qNs2lQqRpWbSDiPXDTtl4FGcZcM=";
        plat = "osx_";
        fmt = "zip";
      };

      x86_64-darwin = {
        arch = "64";
        sha256 = "sha256-l7J4Rrq+kUyk+0Chq5qo50K1VXC/7E3FC/hQ1DQ0PGA=";
        plat = "osx_";
        fmt = "zip";
      };

      x86_64-linux = {
        arch = "64";
        sha256 = "sha256-fAaxrLZSXGBYr4Vu0Cz2pZwXivSTkaIF5wL217cB9qM=";
        plat = "linux";
        fmt = "tar.gz";
      };
    }
    .${system}
    or (throw "Unsupported system: ${system}");
  postman = pkgs.postman;
  postman' = postman.overrideAttrs rec {
    version = "11.1.0";
    name = "${postman.pname}-${version}";
    src = pkgs.fetchurl {
      url = "https://dl.pstmn.io/download/version/${version}/${dist.plat}${dist.arch}";
      inherit (dist) sha256;
      name = "${postman.pname}-${version}.${dist.fmt}";
    };
  };
in {
  options = {
    customize = {
      postman.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = {
    environment.systemPackages = lib.optionals cfg.enable [
      postman'
    ];
  };
}
