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
}:
let
  neovimApp = import ../../apps/neovim.nix { pkgs = pkgs-edge; };
in
{
  imports = [
    ./user-cfg.nix
    ./common-system.nix
    #    ../window-manager/xmonad-system.nix
    #    ../window-manager/sway-system.nix
    ../window-manager/river-system.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit pkgs pkgs-edge neovimApp;
  };

  users.users.${config.users.primary} = {
    home = "/home/${config.users.primary}";
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [
      "audio"
      "input"
      "kubernetes"
      "network"
      "networkmanager"
      "video"
      "wheel"
    ];
  };

  fonts = {
    fontDir.enable = true;
    packages = [
      # Common fonts
      pkgs.vistafonts
    ];
  };

  # Linux-specific packages; see common-system-packages.nix for the rest:
  environment.systemPackages = [
    # image viewer
    pkgs.feh

    # development
    pkgs.gcc
    pkgs.gnumake

    # network / internet
    pkgs.qutebrowser
    pkgs.nbtscan
    pkgs.nmap

    # email
    pkgs.aerc
    pkgs.dante

    # volume & playback control
    pkgs.pamixer
    pkgs.playerctl
  ];

  # I have nix-index-database handling command-not-found
  programs.command-not-found.enable = false;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;
    promptInit = ""; # I've got prompt stuff in my ~/.zshrc
  };
  users.defaultUserShell = pkgs.zsh;

  xdg.mime.defaultApplications = {
    "text/html" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
  };

  # ssh & ssh protection
  services.fail2ban.enable = true;
  services.openssh.enable = true;

  # trackpad
  services.libinput.touchpad = {
    naturalScrolling = true;
    # avoid default behavior of different areas of the trackpad behaving like
    # left/middle/right click. use one, two, and three-finger tap instead.
    middleEmulation = false;
    tappingButtonMap = "lrm";
    clickMethod = "clickfinger";
  };

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
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
    overlays = [ ];
  };
}
