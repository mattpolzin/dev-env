##
## Additional initial setup prior to using nix-darwin:
## 1. Install Homebrew (https://brew.sh)
## 2. Clone dev-env and awesome-opal git repos into same parent directory
##

{ pkgs, inputs, config, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.system}.agenix
    pkgs.chez-racket # <- replace with chez once aarch64 support lands in Nix.
    pkgs.circumflex
    pkgs.ddgr
    pkgs.elixir
    pkgs.elmPackages.elm
    pkgs.ghc
    pkgs.glow
    pkgs.jq
    pkgs.k9s
    pkgs.kitty
    pkgs.kubectl
    pkgs.kubectl-tree
    pkgs.neovim
    pkgs.nodejs
    pkgs.yq
  ];

  fonts = {
    fontDir.enable = true;
    fonts = [
      pkgs.jetbrains-mono
    ];
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
  };

  networking = {
    computerName = "Matt Polzin Work Laptop";
    hostName = "MattPolzin-Work-Laptop";
  };

  # TODO: read up on yabai and determine if I want to use it instead of Divvy
  services.yabai = {
    enable = false;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Necessary for using flakes on this system.
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = "nix-command flakes";
  };

  age.secrets.etcHosts.file = ./secrets/etc-hosts.age;
  environment.etc.hosts = {
    copy = true;
    source = config.age.secrets.etcHosts.path;
  };

  system.defaults = {
    # tap-to-click:
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
    # auto-hide the dock:
    dock.autohide = true;
    # dock minimize/maximize effect:
    dock.mineffect = "suck";

    # always show hidden files:
    NSGlobalDomain.AppleShowAllFiles = true;
    # Show hidden files:
    finder.AppleShowAllFiles = true;

    # path breadcrumbs:
    finder.ShowPathbar = true;
    # status bar at bottom:
    finder.ShowStatusBar = true;

    loginwindow.GuestEnabled = false;

    # 0 = Show date
    menuExtraClock.ShowDate = 0;
  };

  time.timeZone = "America/Chicago";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs = {
    hostPlatform = "x86_64-darwin";
    config = {
#      allowUnfree = true;
    };
    overlays = [ ];
  };
}
