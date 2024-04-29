{lib, pkgs, pkgs-edge, inputs, config, ...}:
let
  cfg = config.programs;
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
in
{
  options = {
    programs.postman.enable = lib.mkOption {
      type = lib.types.bool;
    };
  };

  config = {
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
    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-language-server
    pkgs.elmPackages.elm-test
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
  ] ++ lib.optionals cfg.postman.enable [
    pkgs.postman
  ];
  };
  }
