{
  pkgs,
  pkgs-edge,
  neovim,
  ...
}: {
  imports = [
    ../common/mattpolzin.nix
  ];

  # additional configs to manage:
  home.file.".config/ghostty" = {
    source = ../../../.config/ghostty;
    recursive = true;
  };

  programs.git = {
    userEmail = "matt.polzin@gmail.com";

    extraConfig = {
      sendemail = {
        smtpServer = "smtp.gmail.com";
        smtpServerPort = 587;
        smtpEncryption = "tls";
        smtpUser = "matt.polzin@gmail.com";
      };
      credential = {
        helper = "store";
      };
    };
  };
}
