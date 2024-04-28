{
  pkgs,
  additionalRPackages ? [],
}: {
  R = pkgs.rWrapper.override {
    packages = with pkgs.rPackages;
      [
        devtools
        usethis
        tidyverse
      ]
      ++ additionalRPackages;
  };
}
