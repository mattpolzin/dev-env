{pkgs ? (import <nixpkgs> {}).pkgs}: let
  inherit (pkgs) stdenv lib;
in rec {
  custom = pkgs.iosevka.override {
    privateBuildPlan = {
      family = "Iosevka Custom";
      spacing = "term";
      serifs = "sans";
      noCvSs = true;
      exportGlyphNames = true;

      # JetBrains Mono:
      # variants.inherits = "ss14";

      ligations = {
        inherits = "dlig";
        enables = ["slasheq"];
      };

      widths = {
        Normal = {
          shape = 548;
          menu = 5;
          css = "normal";
        };
      };

      weights = let
        weight = n: {
          shape = n;
          menu = n;
          css = n;
        };
      in {
        Thin = weight 100;
        ExtraLight = weight 200;
        Light = weight 300;
        Regular = weight 400;
        Medium = weight 500;
        SemiBold = weight 600;
        Bold = weight 700;
        ExtraBold = weight 800;
      };
    };
    set = "Custom";
  };

  nerdFont = stdenv.mkDerivation {
    name = "iosevka-custom-nerd";
    src = custom;
    nativeBuildInputs = [
      pkgs.parallel
      pkgs.nerd-font-patcher
    ];
    buildPhase = ''
      parallel --will-cite nerd-font-patcher --careful ::: ./share/fonts/truetype/*.ttf
      mkdir -p $out/share/fonts/truetype
      cp *.ttf $out/share/fonts/truetype/
    '';
    noInstall = true;
  };
}
