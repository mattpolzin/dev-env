##
## Additional initial setup prior to using nix-darwin on new computer:
## 1. Install Nix
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
## 3. Install Homebrew (https://brew.sh)
##
## Additional initial setup after using nix-darwin on new computer:
## 4. Install Docker for Mac (not available in app store, brew, or nixpkgs)
## 5. Set up OpenVPN Connect (must set up through Ops portal and GUI app, best I can tell)
## 6. Install R Studio
##

{ pkgs, inputs, config, ... }: {
  users.users.mattpolzin = { };
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = { inherit pkgs; };
  home-manager.users.mattpolzin = import ./work-user-configuration.nix;

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = [
   # Shell
    inputs.agenix.packages.${pkgs.system}.agenix
    inputs.harmony.packages.${pkgs.system}.harmony
    pkgs.azure-cli
    pkgs.chez-racket # <- replace with chez once aarch64 support lands in Nix.
    pkgs.circumflex
    pkgs.cloc
    pkgs.ctags
    pkgs.ddgr
    pkgs.diffutils
    pkgs.elixir
    pkgs.elmPackages.elm
    pkgs.fd
    pkgs.ffmpeg
    pkgs.gh
    pkgs.ghc
    pkgs.git
    pkgs.git-lfs
    pkgs.glow
    pkgs.graphviz
    pkgs.idris2
    pkgs.jq
    pkgs.k9s
    pkgs.kind
    pkgs.kubectl
    pkgs.kubectl-tree
    pkgs.kubernetes-helm
    pkgs.kubeseal
    pkgs.mutagen
    pkgs.neovim
    pkgs.nodejs
    pkgs.patch
    pkgs.ripgrep
    pkgs.rlwrap
    pkgs.terraform
    pkgs.tree-sitter
    pkgs.yq
    pkgs.R

    # GUI
    pkgs.kitty
    pkgs.vscode
    pkgs.zoom-us

    # Shell (Disabled)
    # pkgs.asdf-vm
  ];

  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [
      "garden-io/garden"
    ];
    brews = [
      "garden-cli"
    ];
    masApps = {
      "1Password 7 - Passwordd Manager" = 1333542190;
      Keynote = 409183694;
      Numbers = 409203825;
      Pages = 409201541;
      "Slack for Desktop" = 803453959;
      Vimari = 1480933944;
      Xcode = 497799835;
    };
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
  nix.package = pkgs.nix;

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
      allowUnfree = true;
    };
    overlays = [ ];
  };
}
