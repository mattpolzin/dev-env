{
  pkgs,
  additionalRPackages ? [ ],
}:
{
  R = pkgs.rWrapper.override {
    packages =
      let
        p = pkgs.rPackages;
      in
      [
        p.devtools
        p.usethis
        p.tidyverse
      ]
      ++ additionalRPackages;
  };
}
