{
  pkgs,
  pkgs-edge,
  inputs,
  ...
}:
let
  agenix = inputs.agenix.packages.${pkgs.system}.agenix;
  idris2 = inputs.idris2-packageset.packages.${pkgs.system}.idris2;
  idris2Lsp = inputs.idris2-packageset.packages.${pkgs.system}.idris2Lsp;
  harmony = inputs.harmony.packages.${pkgs.system}.harmony;
  neovimApp = import ../../apps/neovim.nix { pkgs = pkgs-edge; };
  iosevka = import ../../fonts/iosevka.nix { pkgs = pkgs-edge; };
in
{
  imports = [
    ../programs/google-chrome.nix
    ../programs/kubernetes.nix
    ../programs/postman.nix
    ../programs/spotify.nix
  ];

  config = {
    nix.package = pkgs-edge.nixVersions.latest;

    fonts = {
      packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        pkgs-edge.pixel-code
        iosevka.nerdFont
      ];
    };

    environment.systemPackages = [
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
      pkgs-edge.elmPackages.elm
      pkgs-edge.elmPackages.elm-language-server
      pkgs-edge.elmPackages.elm-test
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
      pkgs.nix-output-monitor
      pkgs.nodejs
      pkgs.nvd
      pkgs.patch
      pkgs.postgresql
      pkgs.ripgrep
      pkgs.rlwrap
      pkgs.tree
      pkgs.vscode-langservers-extracted
      pkgs.w3m
      pkgs.wget
      pkgs.which
      pkgs.yq

      # GUI (all machines)
      pkgs-edge.bruno
      pkgs-edge.slack
      pkgs-edge.zoom-us
      pkgs.kitty
    ];
  };
}
