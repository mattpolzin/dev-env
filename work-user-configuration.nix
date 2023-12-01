let directFileSources = {
  # source these files directly:
  ".bashrc" = {
    source = ./.bashrc;
  };
  ".zshrc" = {
    surce = ./.zshrc;
  };
  ".vimrc" = {
    surce = ./.vimrc;
  };
  ".ctags" = {
    surce = ./.ctags;
  };
  ".config/nvim" = {
    surce = ./.config/nvim;
    recursive = true;
  };
  ".config/kitty" = {
    surce = ./.config/kitty;
    recursive = true;
  };
  ".config/k9s" = {
    surce = ./.config/k9s;
    recursive = true;
  };
  ".config/ripgrep" = {
    surce = ./.config/ripgrep;
    recursive = true;
  };
  ".config/nix" = {
    surce = ./.config/nix;
    recursive = true;
  };
};
in
{ pkgs }: {
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
