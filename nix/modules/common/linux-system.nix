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
## [...] (system-specific steps)
## 8. Copy Documents/Downloads folders to new machine.
## 9. Copy ~/notes (Neorg files) to new machine.
## 10. Snag Safari bookmarks as desired.
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
    home = "/Users/${config.users.primary}";
  };

  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
      pkgs-edge.pixel-code
      iosevka.nerdFont
    ];
  };

  # Auto upgrade nix package and the daemon service.
#  services.nix-daemon.enable = true;
# TODO: ^ is the above unavailable setting simply not relevant for nixos?

  programs.postman.enable = false;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;
    promptInit = ""; # I've got prompt stuff in my ~/.zshrc
  };

  networking = {
    hostName = hostName;
  };

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
