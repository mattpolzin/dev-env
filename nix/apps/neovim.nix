let
  vimrc = builtins.path {
    path = ../../.vimrc;
    name = "vimrc";
  };
  runtimepath = ../../.config/nvim;

  homeManagerConfigs = {
    ".vimrc" = {
      source = vimrc;
    };
    ".config/nvim/lua" = {
      source = runtimepath + "/lua";
      recursive = true;
    };
  };
  homeManagerExtraConfig = ''
    source ~/.vimrc
    lua require('init')
  '';
in
  # packages: function from pkgs to list of other packages to load into shell (e.g. language servers)
  {
    pkgs ? (import <nixpkgs> {}).pkgs,
    extraPackages ? (ps: []),
  }: let
    package = pkgs.neovim-unwrapped;

    neorg = pkgs.vimUtils.buildVimPlugin rec {
      pname = "neorg";
      version = "8.7.1";
      src = pkgs.fetchFromGitHub {
        owner = "nvim-neorg";
        repo = "neorg";
        rev = "v${version}";
        hash = "sha256-vL/4bZIFlhiWrIiWrRpmMQyYuFKzRrDF1VoLghC3Ia8=";
      };
      dependencies = with pkgs.vimPlugins; [plenary-nvim nui-nvim];
    };

    extraLuaPackages = (
      ps: [
        ps.nvim-nio
        ps.lua-utils-nvim
        ps.pathlib-nvim
      ]
    );

    plugins = let
      p = pkgs.vimPlugins;
    in [
      # colorscheme
      p.onedark-nvim

      # Open files with line number annotation after colon
      p.fileline-nvim

      p.vim-vsnip

      # Tab completion
      p.cmp-nvim-lsp
      p.cmp-buffer
      p.cmp-path
      p.cmp-cmdline
      p.cmp-vsnip
      p.cmp-git
      p.nvim-cmp

      # Previewing documents
      p.markdown-preview-nvim

      # Browsing/Finding
      p.oil-nvim
      p.nvim-web-devicons
      p.telescope-nvim
      p.telescope-fzf-native-nvim # <- might need a buildPhase override to run 'make'
      {
        plugin = p.fzf-vim; # <- faster than telescope for file finding.
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
      p.nvim-lspconfig
      p.idris2-nvim

      # DAP
      p.nvim-dap

      # Treesitter
      (p.nvim-treesitter.withPlugins (
        p: [
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
          p.mermaid
          p.nix
          p.norg
          # p.norg_meta # <- not found
          pkgs.tree-sitter.builtGrammars.tree-sitter-norg-meta
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
      p.nvim-treesitter-context

      # Git
      p.gitsigns-nvim

      # Note Taking
      p.autolist-nvim
      neorg
      {
        plugin = p.vim-table-mode;
        config = "let g:table_mode_corner='|' "; # <- markdown compatible tables
      }
    ];

    buildInputs =
      [
        pkgs.ripgrep
      ]
      ++ (extraPackages pkgs);

    neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
      inherit plugins extraLuaPackages;
      customRC = ''
        source ${vimrc}
        set runtimepath=${runtimepath},$VIMRUNTIME
        lua require('init')
      '';
    };
    neovim = pkgs.wrapNeovimUnstable package neovimConfig;
  in {
    inherit homeManagerConfigs homeManagerExtraConfig plugins extraLuaPackages;
    inherit package neovim;

    shell = pkgs.mkShell {
      packages =
        [
          neovim
        ]
        ++ buildInputs;
    };
  }
