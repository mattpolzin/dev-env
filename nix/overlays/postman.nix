(final: prev: let
    dist = {
      aarch64-darwin = {
        arch = "arm64";
        sha256 = "sha256-+iXE0b9McyhDNhHC+MYw7PSj1EGoj38o0H5mnmCKo68=";
      };

      x86_64-darwin = {
        arch = "64";
        sha256 = ""; # will fix next time I build on non-aarch64
      };
    }.${final.system} or (throw "Unsupported system: ${final.system}");
  in {
    postman = prev.postman.overrideAttrs {
      version = "10.21.0";
      name = "${prev.postman.pname}-${final.postman.version}";
      src = final.fetchurl {
        url = "https://dl.pstmn.io/download/version/${final.postman.version}/osx_${dist.arch}";
        inherit (dist) sha256;
        name = "${prev.postman.pname}-${final.postman.version}.zip";
      };
    };
})
