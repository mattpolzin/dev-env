{
  # source these files directly:
  ".xmonad" = {
    source = ../.monad;
    recursive = true;
  };
  ".config/fontconfig" = {
    source = ../.config/fontconfig;
    recursive = true;
  };
  ".config/xmobar" = {
    source = ../.config/xmobar;
    recursive = true;
  };
}
