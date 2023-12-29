let 
  directFileSources = {
    # source these files directly:
    ".bashrc" = {
      source = ../../../.bashrc;
    };
    ".zshrc" = {
      source = ../../../.zshrc;
    };
    ".vimrc" = {
      source = ../../../.vimrc;
    };
    ".ctags" = {
      source = ../../../.ctags;
    };
    ".config/nvim/lua" = {
      source = ../../../.config/nvim/lua;
      recursive = true;
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
  };
in
{ pkgs, pkgs-edge, neovim, ... }: 
let 
  idris2-nvim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "idris2-nvim";
    version = "2023-09-05";
    src = pkgs.fetchFromGitHub {
      owner = "ShinKage";
      repo = "idris2-nvim";
      rev = "8bff02984a33264437e70fd9fff4359679d910da";
      hash = "sha256-guEmds98XEBKuJVdB+rQB01G+RmnQaG+RTjM6smccAI=";
    };
    dependencies = with pkgs-edge.vimPlugins; [ nui-nvim plenary-nvim ];
  };
  autolist-nvim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "autolist-nvim";
    version = "2023-07-07";
    src = pkgs.fetchFromGitHub {
      owner = "gaoDean";
      repo = "autolist.nvim";
      rev = "5f70a5f99e96c8fe3069de042abd2a8ed2deb855";
      hash = "sha256-lavDbTFidmbYDOxYPumCExkd27sesZ5uFgwHc1xNuW0=";
    };
  };
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
    package = neovim;
    
    extraConfig = ''
      source ~/.vimrc
      lua require('init')
    '';

    plugins = with pkgs-edge.vimPlugins; [
      # colorscheme
      onedark-nvim

      # Open files with line number annotation after colon
      fileline-nvim

      vim-vsnip

      # Tab completion
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-vsnip
      cmp-git
      nvim-cmp

      # Previewing documents
      markdown-preview-nvim

      # Browsing/Finding
      oil-nvim
      telescope-nvim
      telescope-fzf-native-nvim # <- might need a buildPhase override to run 'make'
      { plugin = fzf-vim; # <- faster than telescope for file finding.
        config = ''
          let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.85 } }
          let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit' }
          let g:fzf_history_dir = '~/.local/share/fzf-history'
        '';
      }

      # LSP
      nvim-lspconfig
      idris2-nvim
      vim-elixir

      # DAP
      nvim-dap
      
      # Treesitter
      (nvim-treesitter.withPlugins (p: [ 

          p.authzed
          p.bash
          p.c
          p.cpp
          p.css
          p.csv
          p.dhall
          p.diff
          p.dockerfile
          p.dot
          p.eex
          p.elixir
          p.elm
          p.embedded_template
          p.git_rebase
          p.gitcommit
          p.gitignore
          p.glimmer
          p.haskell
          p.html
          p.ini
          p.javascript
          p.json
          p.lua
          p.make
          p.markdown
          p.nix
          p.norg
          # p.norg_meta # <- not found
          p.python
          p.query
          p.ruby
          p.scheme
          p.scss
          p.sql
          p.swift
          p.tsx
          p.typescript
          p.vim
          p.vimdoc
          p.yaml

        ]
      ))
      nvim-treesitter-context

      # Git
      gitsigns-nvim

      # Note Taking
      autolist-nvim
      neorg
      { plugin = vim-table-mode;
        config = "let g:table_mode_corner='|' "; # <- markdown compatible tables
      }
      
    ];
  };

  # additional configs to manage:
  home.file = directFileSources;

  targets.darwin.search = "DuckDuckGo";
}
