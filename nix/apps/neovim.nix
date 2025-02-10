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
  pkgs ? (import <nixpkgs> { }).pkgs,
  extraPackages ? (ps: [ ]),
}:
let
  package = pkgs.neovim-unwrapped;

  extraLuaPackages = (
    ps: [
    ]
  );

  plugins =
    let
      p = pkgs.vimPlugins;
    in
    [
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
      (p.nvim-treesitter.withPlugins (ts: [
        ts.authzed
        ts.bash
        ts.c
        ts.cpp
        ts.css
        ts.csv
        ts.dhall
        ts.diff
        ts.dockerfile
        ts.dot
        ts.eex
        ts.elixir
        ts.elm
        ts.embedded_template
        ts.git_rebase
        ts.gitcommit
        ts.gitignore
        ts.glimmer
        ts.haskell
        ts.html
        ts.ini
        ts.javascript
        ts.json
        ts.lua
        ts.make
        ts.markdown
        ts.mermaid
        ts.nix
        # ts.norg # <- provided by neorg-overlay
        # ts.norg_meta # <- provided by neorg-overlay
        ts.python
        ts.query
        ts.ruby
        ts.scheme
        ts.scss
        ts.sql
        ts.swift
        ts.tsx
        ts.typescript
        ts.vim
        ts.vimdoc
        ts.yaml
      ]))
      p.nvim-treesitter-context

      # Git
      p.gitsigns-nvim

      # Note Taking
      p.autolist-nvim
      p.neorg
      {
        plugin = p.vim-table-mode;
        config = "let g:table_mode_corner='|' "; # <- markdown compatible tables
      }
    ];

  buildInputs = [ pkgs.ripgrep ] ++ (extraPackages pkgs);

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    inherit plugins extraLuaPackages;
    customRC = ''
      source ${vimrc}
      set runtimepath=${runtimepath},$VIMRUNTIME
      lua require('init')
    '';
  };
  neovim = pkgs.wrapNeovimUnstable package neovimConfig;
in
{
  inherit
    homeManagerConfigs
    homeManagerExtraConfig
    plugins
    extraLuaPackages
    ;
  inherit package neovim;

  shell = pkgs.mkShell { packages = [ neovim ] ++ buildInputs; };
}
