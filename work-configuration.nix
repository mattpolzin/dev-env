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
## 3. Install Homebrew (https://brew.sh)
## 4. Set new laptop's hostname to 'MattPolzin-Work-Laptop'
##    `sudo scutil --set HostName MattPolzin-Work-Laptop`
##    `sudo scutil --set LocalHostName MattPolzin-Work-Laptop`
##
## Additional initial setup after using nix-darwin on new computer:
## 4. Install Docker for Mac (not available in app store, brew, or nixpkgs)
## 5. Set up OpenVPN Connect (must set up through Ops portal and GUI app, best I can tell)
## 6. Install R Studio
##


##
## NOTE:
## can't store configs or creds in this repo (even encrypted). Still, maybe I will want to keep track of the following
## rough openvpn command that could replace the OpenVPN connect UI.
## 
##    sudo openvpn --config "$(pwd)/openvpn/profiles/azure-dev.ovpn" \
##                 --auth-user-pass "$(pwd)/openvpn/creds/azure-dev.creds" \
##                 --auth-retry interact \
##                 --up "$(pwd)/openvpn_up.sh" --down "$(pwd)/openvpn_down.sh" \
##                 --script-security 2
##

{ pkgs, system, inputs, config, ... }:
let 
  agenix =  inputs.agenix.packages.${pkgs.system}.agenix;
  harmony = inputs.harmony.packages.${pkgs.system}.harmony;
  neovim = pkgs.neovim-unwrapped;
  pkgs-edge = inputs.nixpkgs-edge.legacyPackages.${pkgs.system};
in
{
  users.users.mattpolzin = { };
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = { inherit pkgs neovim pkgs-edge; };
  home-manager.users.mattpolzin = import ./work-user-configuration.nix;

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = [

    # Shell
    agenix
    harmony
    neovim
    pkgs.R
    pkgs.asdf-vm # <- installed to aid in assisting co-workers using asdf
    pkgs.azure-cli
    pkgs.chez-racket # <- replace with chez once aarch64 support lands in Nix.
    pkgs.circumflex
    pkgs.cloc
    pkgs.ctags
    pkgs.ddgr
    pkgs.diffutils
    pkgs.direnv
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
    pkgs.nodejs
    pkgs.openvpn
    pkgs.patch
    pkgs.ripgrep
    pkgs.rlwrap
    pkgs.rnix-lsp
    pkgs.terraform
    pkgs.tree
    pkgs.tree-sitter
    pkgs.yq

    # GUI
    pkgs.kitty
    pkgs.slack
    pkgs.vscode
    pkgs.zoom-us

    # Shell (Disabled)
    # -- Empty --
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
      Vimari = 1480933944;
      Xcode = 497799835;
    };
  };

  networking = {
    computerName = "Matt Polzin Work Laptop";
    hostName = "MattPolzin-Work-Laptop";
  };

  # TODO: determine if I want to use yabai instead of Divvy
  services.yabai = {
    enable = true;
    # !! only using edge yabai because of build failure for x86_64-darwin
    # on nixpkgs 23.11
    package = pkgs-edge.yabai;
  };

  services.skhd = {
    enable = true;
    # !! only using edge skhd because of build failure for x86_64-darwin
    # on nixpkgs 23.11
    package = pkgs-edge.skhd;
    skhdConfig = ''
      ##
      ## Float commands (Divvy inspired)
      ##

      # left third
      ctrl + alt + cmd + left : yabai -m window --grid 1:3:0:0:1:1

      # middle third
      ctrl + alt + cmd + down : yabai -m window --grid 1:3:1:0:1:1

      # right third
      ctrl + alt + cmd + right : yabai -m window --grid 1:3:2:0:1:1

      # offset middle focus
      ctrl + alt + cmd + up : yabai -m window --grid 1:6:1:0:3:1

      # full-screen
      ctrl + alt + cmd + m : yabai -m window --grid 1:1:0:0:1:1

      ##
      ## Tiled commands (Xmonad inspired)
      ##

      # resize all windows to share tiled space
      ctrl + alt + cmd + n : yabai -m space --balance

      # toggle between vertical and horizontal split for window
      ctrl + alt + cmd + space : yabai -m window --toggle split

      # toggle float/tiled for window
      ctrl + alt + cmd + t : yabai -m window --toggle float

      # swap focus with previous window
      cmd + shift + j : yabai -m window --swap prev

      # swap focus with next window
      cmd + shift + k : yabai -m window --swap next
    '';
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

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
    hostPlatform = system;
    config = {
      allowUnfree = true;
    };
    overlays = [ ];
  };
}
