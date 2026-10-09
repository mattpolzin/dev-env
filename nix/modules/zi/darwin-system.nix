## 1-3: See ../shared/darwin-system.nix
## 5. Set new laptop's hostname to 'MattPolzin-ZI'
##    `sudo scutil --set HostName MattPolzin-ZI`
##    `sudo scutil --set LocalHostName MattPolzin-ZI`
##
## Additional initial setup after using nix-darwin on new computer:
## 6. Install Docker for Mac (not available in app store, brew, or nixpkgs)
## 7. Install Slack via App Store or "SelfService++"
## 8. Optionally create .envrc file in repos (e.g. "use nix")
## 9-xx: See ../shared/darwin-system.nix
##
{
  pkgs,
  pkgs-edge,
  config,
  ...
}:
let
  gcloud = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components;
  [
    gke-gcloud-auth-plugin
  ]);
in
{
  users.primary = "matt.polzin";
  home-manager.users.${config.users.primary} = import ./mattpolzin.nix;

  environment.systemPackages = [
    # Shell (only at work)
    gcloud
    pkgs.claude-code
    pkgs.colima
    pkgs.csvkit
    pkgs.direnv
    pkgs.docker
    pkgs.ffmpeg
    pkgs.go
    pkgs.gofumpt
    pkgs.golangci-lint
    pkgs.gopls
    pkgs.pre-commit
    pkgs.redocly
    pkgs.terraform
  ];

  programs.direnv.enable = true;
  customize.googleChrome.enable = false;

  nix = {
    settings = {
      substituters = [
        "https://gh-harmony.cachix.org"
        "https://gh-nix-idris2-packages.cachix.org"
      ];

      trusted-public-keys = [
        "gh-harmony.cachix.org-1:KX5tTtEt3Y6an8pywe3Cy6jR9bUo+1Cl7hJmh+5eI4I="
        "gh-nix-idris2-packages.cachix.org-1:iOqSB5DrESFT+3A1iNzErgB68IDG8BrHLbLkhztOXfo="
      ];
    };
  };
}
