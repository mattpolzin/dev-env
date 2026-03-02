{
  ".bashrc" = {
    source = ../.bashrc;
  };
  # ctag language specific configurations
  ".ctags" = {
    source = ../.ctags;
  };
  # configs that apply to any shell input 
  ".inputrc" = {
    source = ../.inputrc;
  };
  # terminal web browser configuration
  ".w3m" = {
    source = ../.w3m;
    recursive = true;
  };
  ".zshrc" = {
    source = ../.zshrc;
  };
  ".config/k9s" = {
    source = ../.config/k9s;
    recursive = true;
  };
  ".config/kitty" = {
    source = ../.config/kitty;
    recursive = true;
  };
  ".config/nix" = {
    source = ../.config/nix;
    recursive = true;
  };
  ".config/nixpkgs" = {
    source = ../.config/nixpkgs;
    #  ^ TODO: just move this into module settings for nixpkgs
    recursive = true;
  };
  ".config/ripgrep" = {
    source = ../.config/ripgrep;
    recursive = true;
  };
}
