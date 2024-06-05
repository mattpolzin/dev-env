{
  lib,
  pkgs,
  pkgs-edge,
  inputs,
  config,
  ...
}: let
  cfg = config.customize;
  agenix = inputs.agenix.packages.${pkgs.system}.agenix;
  idris2 = inputs.idris-lsp.packages.${pkgs.system}.idris2;
  idris2Lsp = inputs.idris-lsp.packages.${pkgs.system}.idris2Lsp;
  buildIdris = inputs.idris.buildIdris.${pkgs.system};
  harmony =
    inputs
    .harmony
    .packages
    .${pkgs.system}
    .harmony
    .override {idris2Packages = {inherit buildIdris;};};
  neovimApp = import ../../apps/neovim.nix {pkgs = pkgs-edge;};
in {
  options = {
    customize = {
      postman.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  imports = [
    ../programs/kubernetes.nix
    ../programs/google-chrome.nix
  ];

  config = {
    nix.package = pkgs-edge.nixVersions.nix_2_21;

    environment.systemPackages =
      [
        # Shell (all machines)
        agenix
        harmony
        idris2
        idris2Lsp
        neovimApp.package
        pkgs-edge.chez
        pkgs-edge.ddgr
        pkgs-edge.ijq
        pkgs-edge.k9s
        pkgs-edge.nixd
        pkgs-edge.presenterm
        pkgs-edge.tree-sitter
        pkgs.circumflex
        pkgs.cloc
        pkgs.ctags
        pkgs.diffutils
        pkgs.elixir
        pkgs.elixir-ls
        # elm broken for OSX temporarily -- will re-enable in near future
        # https://github.com/NixOS/nixpkgs/pull/315141
        #    pkgs.elmPackages.elm
        #    pkgs.elmPackages.elm-language-server
        #    pkgs.elmPackages.elm-test
        pkgs.erlang
        pkgs.fd
        pkgs.fzf
        pkgs.gh
        pkgs.ghc
        pkgs.git
        pkgs.git-lfs
        pkgs.glow
        pkgs.gnupg
        pkgs.graphviz
        pkgs.htop
        pkgs.iftop
        pkgs.jq
        pkgs.kind
        pkgs.kubectl
        pkgs.kubectl-tree
        pkgs.nvd
        pkgs.nix-output-monitor
        pkgs.nodejs
        pkgs.patch
        pkgs.postgresql
        pkgs.ripgrep
        pkgs.rlwrap
        pkgs.tree
        pkgs.w3m
        pkgs.wget
        pkgs.which
        pkgs.yq

        # GUI (all machines)
        pkgs-edge.bruno # <- considering replacing Postman with this
        pkgs-edge.slack
        pkgs-edge.zoom-us
        pkgs.kitty
      ]
      ++ lib.optionals cfg.postman.enable [
        pkgs.postman
      ];
  };
}