# NixOS specific modifications to the home manager
{ pkgs, pure, ... }:
  let
    impure-flag = if pure then "" else "--impure";

  in {
    packages = [
      pkgs.obsidian
    ];

    programs = {};

    services = {
      emacs.enable = true;
      gpg-agent = {
        enable           = true;
        enableSshSupport = true;
        pinentryFlavor   = "curses";

        extraConfig = ''
          pinentry-program ${pkgs.pinentry.curses}/bin/pinentry
        '';
      };
    };

    flake-rebuild-switch = "nixos-rebuild switch ${impure-flag}";
  }
