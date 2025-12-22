{ config, pkgs, lib, ... }:

{
  programs.gpg = {
    enable = true;
    settings.default-key = "92A150B1496B3553";
  };

  services = {};
}
