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
}:
let
  neovimApp = import ../../apps/neovim.nix { pkgs = pkgs-edge; };
in
{
  imports = [
    ./user-cfg.nix
    ./all-systems.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit pkgs pkgs-edge neovimApp;
  };

  users.users.${config.users.primary} = {
    home = "/Users/${config.users.primary}";
  };
  system.primaryUser = config.users.primary;

  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.masApps = {
    Keynote = 409183694;
    Numbers = 409203825;
    Pages = 409201541;
    Vimari = 1480933944;
    Xcode = 497799835;
  };
  # chrome via Homebrew:
  customize.googleChrome.enable = true;

  services.yabai = {
    enable = true;
    package = pkgs-edge.yabai;
    config = {
      debug_output = "on";
      layout = "bsp";
    };

    extraConfig = ''
      # cmd + click and drag to move window
      yabai -m config mouse_modifier cmd
      yabai -m config mouse_action1 move

      yabai -m config top_padding 10
      yabai -m config bottom_padding 10
      yabai -m config left_padding 10
      yabai -m config right_padding 10
      yabai -m config window_gap 8

      yabai -m rule --add app='Activity Monitor' manage=off
      yabai -m rule --add app='System Settings' manage=off
      yabai -m rule --add app='1Password 7' manage=off
      yabai -m rule --add app='1Password' manage=off
      yabai -m rule --add app='zoom.us' manage=off
      yabai -m rule --add title='Web Inspector' manage=off
      yabai -m rule --add title='Trash' manage=off
    '';
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
      ctrl + alt + cmd - left : ([[ "$(yabai -m query --windows --window | jq '."is-floating"')" = 'true' ]] || yabai -m window --toggle float); yabai -m window --grid 1:3:0:0:1:1

      # middle third
      ctrl + alt + cmd - down : ([[ "$(yabai -m query --windows --window | jq '."is-floating"')" = 'true' ]] || yabai -m window --toggle float); yabai -m window --grid 1:3:1:0:1:1

      # right third
      ctrl + alt + cmd - right : ([[ "$(yabai -m query --windows --window | jq '."is-floating"')" = 'true' ]] || yabai -m window --toggle float); yabai -m window --grid 1:3:2:0:1:1

      # offset middle focus
      ctrl + alt + cmd - up : ([[ "$(yabai -m query --windows --window | jq '."is-floating"')" = 'true' ]] || yabai -m window --toggle float); yabai -m window --grid 1:6:1:0:3:1

      # full-screen
      ctrl + alt + cmd - m : ([[ "$(yabai -m query --windows --window | jq '."is-floating"')" = 'true' ]] || yabai -m window --toggle float); yabai -m window --grid 1:1:0:0:1:1

      ##
      ## Tiled commands (Xmonad inspired)
      ##

      # resize all windows to share tiled space
      ctrl + alt + cmd - n : yabai -m space --balance

      # toggle between vertical and horizontal split for window
      ctrl + alt + cmd - space : yabai -m window --toggle split

      # toggle float/tiled for window
      ctrl + alt + cmd - t : yabai -m window --toggle float

      # focus previous window
      cmd - k : yabai -m window --focus prev

      # focus next window
      cmd - j : yabai -m window --focus next

      # swap position with previous window
      cmd + shift - k : yabai -m window --swap prev

      # swap position with next window
      cmd + shift - j : yabai -m window --swap next

      # make right split larger
      cmd + shift - h : yabai -m window --ratio rel:-0.1

      # make left split larger
      cmd + shift - l : yabai -m window --ratio rel:0.1

      # zoom-parent
      cmd + shift - up : yabai -m window --toggle zoom-parent
    '';
  };

  customize.postman.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;
    promptInit = ""; # I've got prompt stuff in my ~/.zshrc
  };

  networking = {
    inherit hostName;
    localHostName = hostName;
    computerName = hostName;
  };

  nix = {
    gc.automatic = true;
    gc.interval = {
      Minute = 0;
      Hour = 3;
      Weekday = 6; # Saturday
    };
    optimise.automatic = true;
    optimise.interval = {
      Minute = 0;
      Hour = 3;
      Weekday = 2; # Tuesday
    };
    settings = {
      auto-optimise-store = false;
      # Necessary for using flakes on this system.
      experimental-features = "nix-command flakes";
    };

    nixPath = [ { nixpkgs = "$HOME/staging/nixpkgs"; } ];
  };

  system.defaults = {
    # automatically rearrange spaces based on recently used:
    dock.mru-spaces = false;
    # auto-hide the dock:
    dock.autohide = true;
    # dock minimize/maximize effect:
    dock.mineffect = "suck";
    # show recent applications:
    dock.show-recents = false;
    # default size is 64:
    dock.tilesize = 60;
    # show icons on desktop:
    finder.CreateDesktop = false;

    # tap-to-click:
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
    # swipe to navigate forward/backward (e.g. in web browser):
    NSGlobalDomain.AppleEnableMouseSwipeNavigateWithScrolls = false;
    NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = false;

    # "Dark" or unset for normal:
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = false;

    # always show hidden files:
    NSGlobalDomain.AppleShowAllFiles = true;
    # Show hidden files:
    finder.AppleShowAllFiles = true;
    # path breadcrumbs:
    finder.ShowPathbar = true;
    # status bar at bottom:
    finder.ShowStatusBar = true;
    # warn when changing file extensions:
    finder.FXEnableExtensionChangeWarning = false;
    # prefer list view in Finder:
    finder.FXPreferredViewStyle = "Nlsv";

    loginwindow.GuestEnabled = false;

    # 0 = Show date
    menuExtraClock.ShowDate = 0;

    # Save to iCloud by default:
    NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;

    # Expand save panel by default:
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;

    # always show file extensions
    NSGlobalDomain.AppleShowAllExtensions = true;

    # doesn't create the folder, just uses it if it is there:
    screencapture.location = "~/Documents/screenshots";

    CustomUserPreferences = {
      # don't auto-update Slack
      "com.tinyspeck.slackmacgap" = {
        SlackNoAutoUpdates = true;
      };
    };
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

  # Nix-darwin does not link installed applications to the user environment. This means apps will not show up
  # in spotlight, and when launched through the dock they come with a terminal window. This is a workaround.
  # Upstream issue: https://github.com/LnL7/nix-darwin/issues/214
  # Issue: https://github.com/LnL7/nix-darwin/issues/139
  system.activationScripts.applications.text =
    let
      uname = config.users.primary;
    in
    ''
      echo "setting up ~/Applications..." >&2
      applications="${config.users.users.${uname}.home}/Applications"
      nix_apps="$applications/Nix Apps"

      # Delete the directory to remove old links
      rm -rf "$nix_apps"

      # Needs to be writable so that nix-darwin can symlink into it
      mkdir -p "$nix_apps"
      chown ${uname}: "$nix_apps"
      chmod u+w "$nix_apps"

      find ${config.system.build.applications}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
              # Spotlight does not recognize symlinks, it will ignore directory we link to the applications folder.
              # It does understand MacOS aliases though, a unique filesystem feature. Sadly they cannot be created
              # from bash (as far as I know), so we use the oh-so-great Apple Script instead.
              /usr/bin/osascript -e "
                  set fileToAlias to POSIX file \"$src\"
                  set applicationsFolder to POSIX file \"$nix_apps\"
                  tell application \"Finder\"
                      make alias file to fileToAlias at applicationsFolder
                      # This renames the alias; 'mpv.app alias' -> 'mpv.app'
                      set name of result to \"$(rev <<< "$src" | cut -d'/' -f1 | rev)\"
                  end tell
              " 1>/dev/null
          done
    '';
}
