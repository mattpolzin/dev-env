{
  # source these files directly:
  ".bashrc" = {
    source = ../.bashrc;
  };
  ".zshrc" = {
    source = ../.zshrc;
  };
  ".ctags" = {
    source = ../.ctags;
  };
  ".w3m/config" = {
    source = ../.w3m/config;
  };
  ".w3m/keymap" = {
    source = ../.w3m/keymap;
  };
  ".config/kitty" = {
    source = ../.config/kitty;
    recursive = true;
  };
  ".config/k9s" = {
    source = ../.config/k9s;
    recursive = true;
  };
  ".config/ripgrep" = {
    source = ../.config/ripgrep;
    recursive = true;
  };
  ".config/nix" = {
    source = ../.config/nix;
    recursive = true;
  };
  ".config/nixpkgs" = {
    source = ../.config/nixpkgs;
    recursive = true;
  };
}
