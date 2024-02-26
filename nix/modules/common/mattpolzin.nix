{
  pkgs,
  pkgs-edge,
  neovimApp,
  ...
}: let
  directFileSources = {
    # source these files directly:
    ".bashrc" = {
      source = ../../../.bashrc;
    };
    ".zshrc" = {
      source = ../../../.zshrc;
    };
    ".ctags" = {
      source = ../../../.ctags;
    };
    ".w3m/config" = {
      source = ../../../.w3m/config;
    };
    ".w3m/keymap" = {
      source = ../../../.w3m/keymap;
    };
    ".config/kitty" = {
      source = ../../../.config/kitty;
      recursive = true;
    };
    ".config/k9s" = {
      source = ../../../.config/k9s;
      recursive = true;
    };
    ".config/ripgrep" = {
      source = ../../../.config/ripgrep;
      recursive = true;
    };
    ".config/nix" = {
      source = ../../../.config/nix;
      recursive = true;
    };
    ".config/nixpkgs" = {
      source = ../../../.config/nixpkgs;
      recursive = true;
    };
  } // neovimApp.homeManagerConfigs;
  in {
    editorconfig = {
      enable = true;
      settings = {
        "*" = {
          indent_style = "space";
          indent_size = 2;
        };
      };
    };

    home.stateVersion = "23.11";

    # programs to manage configs for:
    programs.neovim = {
      enable = true;
      inherit (neovimApp) package plugins;
      extraConfig = neovimApp.homeManagerExtraConfig;
    };

    # additional configs to manage:
    home.file = directFileSources;

    targets.darwin.search = "DuckDuckGo";
  }
