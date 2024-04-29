(final: prev: let
  dist =
    {
      aarch64-darwin = {
        arch = "arm64";
        sha256 = "";
      };

      x86_64-darwin = {
        arch = "64";
        sha256 = "sha256-ZfTLrrzKiWXXe1WR1Z2+dGHV2jX0kSyXystxpSH950c=";
      };
    }
    .${final.system}
    or (throw "Unsupported system: ${final.system}");
in {
  postman = prev.postman.overrideAttrs {
    version = "10.24.16";
    name = "${prev.postman.pname}-${final.postman.version}";
    src = final.fetchurl {
      url = "https://dl.pstmn.io/download/version/${final.postman.version}/osx_${dist.arch}";
      inherit (dist) sha256;
      name = "${prev.postman.pname}-${final.postman.version}.zip";
    };
  };
})
