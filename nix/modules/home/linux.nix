{ config, pkgs, lib, ... }:

let
  polybarOverrides = pkgs.polybarFull.override {
    alsaSupport   = true;
    githubSupport = true;
    mpdSupport    = true;
    pulseSupport  = true;
  };

in {
  home.file.".wallpaper.jpg".source = ../../../wallpaper/lofi-cafe.jpg;

  home.packages = with pkgs; [
    blueberry # Bluetooth
    cider
    conky
    discord
    feh
    guake
    killall
    material-design-icons
    nodejs
    obsidian
    pavucontrol # Audio
    transmission_4
    zoom-us
  ];

  gtk = {
    enable = true;
  };

  services = {
    emacs.enable = true;

    gpg-agent = {
      enable           = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-curses;
    };
  };
}
