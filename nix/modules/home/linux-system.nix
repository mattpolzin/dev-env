{
  pkgs,
  system,
  inputs,
  config,
  ...
}: {
  imports = [
    ./framework-hardware-configuration.nix
  ];

  users.primary = "matt";
  home-manager.users.${config.users.primary} = import ./mattpolzin.nix;

  # List packages installed in system profile.
  environment.systemPackages = [
    # Shell (only at home)
    pkgs.colima
    pkgs.docker
    pkgs.texliveSmall

    # GUI (only at home)
    pkgs.discord
    pkgs.spotify
  ];

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  boot.initrd.luks.devices."luks-d99ad198-c36b-4aa6-97e3-7f970030e770".device = "/dev/disk/by-uuid/d99ad198-c36b-4aa6-97e3-7f970030e770";

  # fingerprint reader
  services.fprintd.enable = true;

  age.secrets.wpaSupplicantConfig.file = ../../../secrets/wpa-supplicant-conf.age;

  networking.supplicant."wlp1s0" = {
    configFile.path = config.age.secrets.wpaSupplicantConfig.path;
    userControlled.group = "network";
  };

  nix = {
    nixPath = [
      "nixpkgs=flake:nixpkgs:/nix/var/nix/profiles/per-user/root/channels"
      "nixpkgs2=$HOME/staging/nixpkgs"
    ];
  };
}
