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

  home.packages = [
    pkgs.blueberry # Bluetooth
    pkgs.brightnessctl
    pkgs.cider
    pkgs.conky
    pkgs.discord
    pkgs.feh
    pkgs.grim
    pkgs.guake
    pkgs.hyprpaper
    pkgs.killall
    pkgs.mako
    pkgs.material-design-icons
    pkgs.nodejs
    pkgs.obsidian
    pkgs.pavucontrol # Audio
    pkgs.playerctl
    pkgs.slurp
    pkgs.transmission_4
    pkgs.waybar
    pkgs.wofi
    pkgs.wl-clipboard
    pkgs.zen-browser
    pkgs.zoom-us
  ];

  gtk = {
    enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # Because already pulled in outside of home manager
    portalPackage = null; # See above
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, SPACE, exec, wofi --show drun"
        ", Print, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%F-%T).png"
      ] ++ (
        builtins.concatLists (
          builtins.genList (i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod, SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
        9)
      );

      "exec-once" = [
        "${pkgs.mako}/bin/mako"
        "${pkgs.waybar}/bin/waybar"
      ];
    };

    plugins = [];
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
