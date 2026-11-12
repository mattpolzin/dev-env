{
  ".bashrc" = {
    source = ../.bashrc;
  };
  # ctag language specific configurations
  ".ctags" = {
    source = ../.ctags;
  };
  # not a standard file, set to --global core.excludesFile git configuration option
  ".git_excludes" = {
    source = ../.git_excludes;
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
  ".config/ripgrep" = {
    source = ../.config/ripgrep;
    recursive = true;
  };
}
