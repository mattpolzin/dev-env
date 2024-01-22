# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [(import ./nixos-overlay/overlay.nix)];
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nixos-overlay/modules/wifi-fw-selection.nix
  ];

  # Disable builtin audio
  boot.kernelParams = ["intel_iommu=on" "apple_bce.aaudio_enabled=0"];

  # Custom kernel
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux-mbp;
  boot.extraModulePackages = with pkgs; [apple-bce apple-ib-drv];
  #   boot.kernelModules = [
  #     "kvm-intel"
  #     # "applesmc" # <- won't start up...
  #   ];

  # Load Apple hardware modules early
  boot.initrd.kernelModules = ["apple_bce" "apple-ibridge" "apple-ib-tb"];

  # Include wiki firmware
  hardware.appleWifiFirmware.model = "MacBookPro16,1";
  hardware.firmware = [(pkgs.apple-wifi-firmware.override {macModel = config.hardware.appleWifiFirmware.model;})];

  # Binary cache for t2linux derivations
  nix = {
    binaryCaches = [
      "https://t2linux.cachix.org"
    ];
    binaryCachePublicKeys = [
      "t2linux.cachix.org-1:P733c5Gt1qTcxsm+Bae0renWnT8OLs0u9+yfaK2Bejw="
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  powerManagement.cpuFreqGovernor = "schedutil";

  # networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = false; # wireless support via wpa_supplicant.
  networking.wireless.iwd.enable = true;
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    dpi = 180;
    displayManager = {
      defaultSession = "none+xmonad";
      lightdm = {
        enable = true;
        extraConfig = ''
          logind-check-graphical = true
        '';
      };
    };
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad
        haskellPackages.xmonad-contrib
        haskellPackages.xmobar
      ];
    };
  };

  # Disable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mattpolzin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; let
    unstable =
      import
      (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixpkgs-unstable)
      # reuse the current configuration
      {config = config.nixpkgs.config;};
  in [
    # system
    dmenu
    xmobar # <- needed to get xmobar bin directory in PATH
    xclip

    # development
    gcc
    gnumake

    # general utility
    which
    ripgrep

    # terminal
    kitty

    # editors
    vim
    unstable.neovim

    # network / internet
    wget
    qutebrowser
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.zsh.enable = true;
  programs.git.enable = true;

  xdg.mime.defaultApplications = {
    "text/html" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
  };

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  fonts.fonts = [
    pkgs.jetbrains-mono
  ];

  # List services that you want to enable:

  # suspend/resume is broken
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchDocked = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
