##
## Additional initial setup prior to using nix-darwin on new computer:
## 1. Install Nix
## 2. Profile migration (manual because of ENV vars with secrets in them):
##   * On old computer:
##     - Grab as much of ~/.zprofile as desirable and transfer to new computer.
## 2. Secret decryption preparation:
##   * On new computer:
##     - Create a new ssh key (`ssh-keygen`) on the new computer specifically for this, not the one used for GitHub
##     - Add the new key to ssh-agent (GitHub has a good writeup on this):
##       https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent
##     - Get the computer's host ssh key (`ssh-keyscan`)
##   * On old computer:
##     - Add the new user & host ssh public keys to the list in secrets/secrets.nix
##     - Rekey secret files (`nix run github:ryantm/agenix -- --rekey`)
##     - Commit changes to repo
## [...] (system-specific steps)
## 8. Copy Documents/Downloads folders to new machine.
## 9. Copy ~/notes (Neorg files) to new machine.
## 10. Snag Safari or qutebrowser bookmarks as desired.
{
  hostName,
  pkgs,
  pkgs-edge,
  system,
  inputs,
  config,
  ...
}: let
  neovimApp = import ../../apps/neovim.nix {pkgs = pkgs-edge;};
  iosevka = import ../../fonts/iosevka.nix {pkgs = pkgs-edge;};
in {
  imports = [
    ./user-cfg.nix
    ./common-system-packages.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {inherit pkgs pkgs-edge neovimApp;};

  users.users.${config.users.primary} = {
    home = "/home/${config.users.primary}";
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = ["wheel" "network" "networkmanager" "video" "audio"];
  };

  fonts = {
    fontDir.enable = true;
    packages = [
      (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
      pkgs-edge.pixel-code
      iosevka.nerdFont

      # Common fonts
      pkgs.vistafonts
    ];
  };

  # Linux-specific packages; see common-system-packages.nix for the rest:
  environment.systemPackages = [
    # system
    pkgs.dmenu
    pkgs.gmrun
    pkgs.xclip
    pkgs.xmobar # <- needed to get xmobar bin directory in PATH

    # development
    pkgs.gcc
    pkgs.gnumake

    # network / internet
    pkgs.qutebrowser
  ];

  programs.postman.enable = false;

  # I have nix-index-database handling command-not-found
  programs.command-not-found.enable = false;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;
    promptInit = ""; # I've got prompt stuff in my ~/.zshrc
  };

  xdg.mime.defaultApplications = {
    "text/html" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
  };

  # Auto upgrade nix package and the daemon service.
#  services.nix-daemon.enable = true;
# TODO: ^ is the above unavailable setting simply not relevant for nixos?

  services.displayManager.defaultSession = "none+xmonad";

  services.xserver = {
    enable = true;
    dpi = 180;
    displayManager.lightdm = {
      enable = true;
      extraConfig = ''
        logind-check-graphical = true
      '';
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
    displayManager.gdm.enable = false;
    desktopManager.gnome.enable = false;
  };

  # ssh protection
  services.fail2ban.enable = true;

  services.openssh.enable = true;

  # trackpad
  services.libinput.touchpad = {
    naturalScrolling = true;
  };

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  networking = {
    inherit hostName;
    wireless.enable = true;
    wireless.userControlled.enable = true;
#    firewall.logRefusedPackets = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    package = pkgs-edge.nixVersions.nix_2_20;

    gc.automatic = true;
    gc.dates = "Sat *-*-* 03:00:00";
    optimise.automatic = true;
    optimise.dates = [ "Tue *-*-* 03:00:00" ];
    settings = {
      auto-optimise-store = false;
      # Necessary for using flakes on this system.
      experimental-features = "nix-command flakes";
    };
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = "23.11";

  # The platform the configuration will be used on.
  nixpkgs = {
    hostPlatform = system;
    config = {
      allowUnfree = true;
    };
    overlays = [];
  };
}
