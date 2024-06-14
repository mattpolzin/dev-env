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

    lua = package.lua;
    luaPackages = lua.pkgs;

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

    plugins = with pkgs.vimPlugins; [
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
      nvim-web-devicons
      telescope-nvim
      telescope-fzf-native-nvim # <- might need a buildPhase override to run 'make'
      {
        plugin = fzf-vim; # <- faster than telescope for file finding.
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

      # DAP
      nvim-dap

      # Treesitter
      (nvim-treesitter.withPlugins (
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
      nvim-treesitter-context

      # Git
      gitsigns-nvim

      # Note Taking
      autolist-nvim
      neorg
      {
        plugin = vim-table-mode;
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
