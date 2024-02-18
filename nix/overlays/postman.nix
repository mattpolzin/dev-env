(final: prev: let
  dist =
    {
      aarch64-darwin = {
        arch = "arm64";
        sha256 = "sha256-8fYnIOhIxaJkFcbrHG4GJ9FiRttPg92er8WMSatQTDk=";
      };

      x86_64-darwin = {
        arch = "64";
        sha256 = "";
      };
    }
    .${final.system}
    or (throw "Unsupported system: ${final.system}");
in {
  postman = prev.postman.overrideAttrs {
    version = "10.23.0";
    name = "${prev.postman.pname}-${final.postman.version}";
    src = final.fetchurl {
      url = "https://dl.pstmn.io/download/version/${final.postman.version}/osx_${dist.arch}";
      inherit (dist) sha256;
      name = "${prev.postman.pname}-${final.postman.version}.zip";
    };
  };
})
