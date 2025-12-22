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

  home = {
    packages = [
      pkgs.blueberry # Bluetooth
      pkgs.brightnessctl
      pkgs.cider
      pkgs.cliphist
      pkgs.conky
      pkgs.discord
      pkgs.feh
      pkgs.fuzzel
      pkgs.grim
      pkgs.guake
      pkgs.hyprpaper
      pkgs.killall
      pkgs.material-design-icons
      pkgs.nodejs
      pkgs.obsidian
      pkgs.pavucontrol # Audio
      pkgs.playerctl
      pkgs.slurp
      pkgs.swappy
      pkgs.transmission_4
      pkgs.waybar
      pkgs.wofi
      pkgs.wl-clipboard
      pkgs.zen-browser
      pkgs.zoom-us
    ];

    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;

      gtk.enable = true;
      x11.enable = true; # Still needed for Wayland
    };
  };

  gtk = {
    enable = true;
  };

  programs = {
    ghostty.enable = true;
    waybar.enable = true;
  };

  services = {
    emacs.enable = true;

    gpg-agent = {
      enable           = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-curses;
    };

    mako.enable = true;

    hyprpaper = {
      enable = true;
      settings = {
        preload = [ "${config.home.homeDirectory}/Pictures/Wallpaper/z5t6m4jyp1n71.png" ];
        wallpaper = [ "${config.home.homeDirectory}/Pictures/Wallpaper/z5t6m4jyp1n71.png" ];
        splash = false;
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # Because already pulled in outside of home manager
    portalPackage = null; # See above

    settings = {
      # Startup
      "exec-once" = [
        "waybar"
        "mako"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "hyprpaper"
      ];

      # Look & Feel
      general = {
        layout      = "dwindle";
        gaps_in     = 6;
        gaps_out    = 14;
        border_size = 2;
        "col.active_border"   = "rgba(89b4faee) rgba(cba6f7ee) 45deg";
        "col.inactive_border" = "rgba(45475aaa)";
      };

      decoration = {
        rounding = 12;

        blur = {
          enabled = true;
          size    = 6;
          passes  = 3;
          new_optimizations = true;
          ignore_opacity    = true;
        };

        shadow = {
          enabled      = true;
          range        = 18;
          render_power = 3;
        };

        animations = {
          # Fairly restrained
          bezier = [
            "easeOut,   0.16, 1, 0.3,  1"
            "easeInOut, 0.65, 0, 0.35, 1"
          ];

          animation = [
            "windows,    1, 6, easeOut,   slide"
            "windowsOut, 1, 6, easeOut,   slide"
            "border,     1, 8, easeInOut"
            "fade,       1, 6, easeInOut"
            "workspaces, 1, 6, easeOut,   slide"
          ];

          # Keys
          "$mod" = "SUPER";

          bind = [
            # App Control
            "$mod,       SPACE,  exec, sh -lc 'flock -n \"$XDG_RUNTIME_DIR/wofi.lock\" wofi --show drun'"
            "$mod,       Return, exec, ghostty"
            "$mod,       Q,      killactive"
            "$mod SHIFT, F,      fullscreen"
            "$mod,       G,      togglefloating"

            # Focus
            "$mod, H,     movefocus, l"
            "$mod, L,     movefocus, r"
            "$mod, K,     movefocus, u"
            "$mod, J,     movefocus, d"

            "$mod, Left,  movefocus, l"
            "$mod, Right, movefocus, r"
            "$mod, Up,    movefocus, u"
            "$mod, Down,  movefocus, d"

            # Move
            "$mod SHIFT, H,     movewindow, l"
            "$mod SHIFT, L,     movewindow, r"
            "$mod SHIFT, K,     movewindow, u"
            "$mod SHIFT, J,     movewindow, d"

            "$mod SHIFT, Left,  movewindow, l"
            "$mod SHIFT, Right, movewindow, r"
            "$mod SHIFT, Up,    movewindow, u"
            "$mod SHIFT, Down,  movewindow, d"

            # Workspaces
            "$mod,       1, workspace,       1"
            "$mod,       2, workspace,       2"
            "$mod,       3, workspace,       3"
            "$mod,       4, workspace,       4"
            "$mod,       5, workspace,       5"
            "$mod,       6, workspace,       6"
            "$mod,       7, workspace,       7"
            "$mod,       8, workspace,       8"
            "$mod,       9, workspace,       9"
            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
            "$mod SHIFT, 5, movetoworkspace, 5"
            "$mod SHIFT, 6, movetoworkspace, 6"
            "$mod SHIFT, 7, movetoworkspace, 7"
            "$mod SHIFT, 8, movetoworkspace, 8"
            "$mod SHIFT, 9, movetoworkspace, 9"

            # Screenshots
            ", Print, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%F-%T).png"
          ];

          bindl = [
            # Media Keys
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPrev, exec, playerctl previous"
          ];

          bindle = [
            # Volume
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume        @DEFAULT_AUDIO_SINK@ 5%-"

            # Brightness
            ", XF86MonBrightnessUp,   exec, brightnessctl set 5%+"
            ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          ];

          # Rules
          windowrulev2 = [
            "float, class:^(pavucontrol)$"
            "float, class:^(org\\.gnome\\.Calculator)$"
            "suppressevent maximize, class:.*"
          ];
        };
      };

      env = [
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];
    };

    plugins = [];
  };
}
