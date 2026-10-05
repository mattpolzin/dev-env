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
  iosevka = import ../../fonts/iosevka.nix { pkgs = pkgs-edge; };
in
{
  imports = [
    ./programs/google-chrome.nix
    ./programs/ifuse.nix
    ./programs/kubernetes.nix
    ./programs/postman.nix
    ./programs/spotify.nix
  ];

  config = {
    nix.package = pkgs-edge.nixVersions.nix_2_34;
    nix.settings = {
      experimental-features = "nix-command flakes";
    };

    fonts.packages = [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs-edge.pixel-code
      iosevka.nerdFont
    ];

    environment.systemPackages = [
      # Shell (all machines)
      agenix
      harmony
      idris2
      idris2Lsp
#      neovim # <- configured with home files for user so installed within home-manager
      pkgs-edge.ddgr
      pkgs-edge.ijq
      pkgs-edge.k9s
      pkgs-edge.nixd
      pkgs-edge.postgresql
      pkgs-edge.presenterm
      pkgs-edge.tree-sitter
      pkgs.circumflex
      pkgs.cloc
      pkgs.ctags
      pkgs.dict
      pkgs.diffutils
      pkgs.fd
      pkgs.fzf
      pkgs.gh
      pkgs.git
      pkgs.git-lfs
      pkgs.glow
      pkgs.gnupg
      pkgs.graphviz
      pkgs.htop
      pkgs.iftop
      pkgs.jq
      pkgs.kubectl
      pkgs.kubectl-tree
      pkgs.lf
      pkgs.lsof
      pkgs.nix-output-monitor
      pkgs.nodejs
      pkgs.nvd
      pkgs.parallel
      pkgs.patch
      pkgs.ripgrep
      pkgs.rlwrap
      pkgs.tree
      pkgs.w3m
      pkgs.wget
      pkgs.which
      pkgs.yq
      pkgs.vscode-langservers-extracted

      # GUI (all machines)
      pkgs.kitty

      #      pkgs-edge.slack
      #      ^ POS demands to install an updater so I need to install it via Brew MAS (app store) on Darwin
    ];
  };
}
