# NixOS specific modifications to the home manager
{ pkgs, pure, ... }:
  let
    impure-flag = if pure then "" else "--impure";

  in {
    packages = [
      pkgs.cider
      pkgs.obsidian
      pkgs.zoom-us
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

    signing-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5QDR5zYVvboJ+SJ5sIBVaRPwOrBv9P/AR6Kj5XBPqO hello@brooklynzelenka.com";

    gpg = {
      format = "ssh";
      commit.gpgsign = true;
      user.signingkey = "~/.ssh/id_ed25519.pub";
      ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };

    flake-rebuild-switch = "nixos-rebuild switch ${impure-flag}";
  }
