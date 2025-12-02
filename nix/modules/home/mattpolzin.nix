{ lib, ... }@attrs:
{
  imports = [ ../shared/mattpolzin.nix ];

  # additional configs to manage:
  home.file.".config/ghostty" = {
    source = ../../../.config/ghostty;
    recursive = true;
  };
  home.activation = lib.mkIf (attrs ? aercAccountsPath) {
    createAercAccounts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD rm -f \
        $HOME/.config/aerc/accounts.conf
      $DRY_RUN_CMD ln -s $VERBOSE_ARG \
        ${toString attrs.aercAccountsPath} $HOME/.config/aerc/accounts.conf
    '';
  };

  programs.git = {
    settings = {
      user.email = "matt.polzin@gmail.com";
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
