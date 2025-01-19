# Darwin specific modifications to the home manager
{ pkgs, hostname, ... }: {
  packages = [];

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

  flake-rebuild-switch = "nix run nix-darwin -- switch --flake ~/Documents/dotfiles/nix/darwin/";
}
