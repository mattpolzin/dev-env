let directFileSources = {
  # source these files directly:
  ".bashrc" = {
    source = ./.bashrc;
  };
  ".zshrc" = {
    source = ./.zshrc;
  };
  ".vimrc" = {
    source = ./.vimrc;
  };
  ".ctags" = {
    source = ./.ctags;
  };
  ".config/nvim" = {
    source = ./.config/nvim;
    recursive = true;
  };
  ".config/kitty" = {
    source = ./.config/kitty;
    recursive = true;
  };
  ".config/k9s" = {
    source = ./.config/k9s;
    recursive = true;
  };
  ".config/ripgrep" = {
    source = ./.config/ripgrep;
    recursive = true;
  };
  ".config/nix" = {
    source = ./.config/nix;
    recursive = true;
  };
};
in
{ pkgs, ... }: {
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
  # programs.<...> = { };

  # additional configs to manage:
  home.file = directFileSources;

  targets.darwin.search = "DuckDuckGo";
}
