# Darwin specific modifications to the home manager
{ pkgs, pure, hostname, ... }:
  let
    unfree       = "env NIXPKGS_ALLOW_UNFREE=1";
    impure-flag  = if pure then "" else "--impure";
    flake-build  = "${unfree} nix build ~/Documents/dotfiles/nix/darwin#darwinConfigurations.${hostname}.system ${impure-flag}";
    flake-switch = "${unfree} ./result/sw/bin/darwin-rebuild switch --flake ~/Documents/dotfiles/nix/darwin ${impure-flag}";

  in {
    packages = [
      pkgs.pinentry_mac
    ];

    programs = {
      gpg = {
        enable = true;
        settings.default-key = "92A150B1496B3553";
      };
    };

    services = {};

    flake-rebuild-switch = "${flake-build} && ${flake-switch}";
    inherit flake-build flake-switch;
  }
