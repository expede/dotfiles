# Darwin specific modifications to the home manager
{ pkgs, hostname, ... }:
  let
    flake-build  = "nix build ~/Documents/dotfiles/nix/darwin#darwinConfigurations.${hostname}.system";
    flake-switch = "./result/sw/bin/darwin-rebuild switch --flake ~/Documents/dotfiles/nix/darwin";

  in {
    packages = [
      # pkgs.pinentry_mac
      pkgs.zoom-us
    ];

    programs = {
      gpg = {
        enable = true;
        settings.default-key = "92A150B1496B3553";
      };
    };

    services = {};

    signing-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5RGNvxkIOd7lbaCUIe4m2fOZeO0tlTvJXzMZZdtBfo hello@brooklynzelenka.com";

    gpg = {
      format = "ssh";
      ssh    = {
        program            = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        allowedSignersFile = "~/.ssh/allowed_signers";
      };
    };

    flake-rebuild-switch = "${flake-build} && ${flake-switch}";
    inherit flake-build flake-switch;
  }
