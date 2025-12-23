{ config, pkgs, lib, ... }:

let
  polybarOverrides = pkgs.polybarFull.override {
    alsaSupport   = true;
    githubSupport = true;
    mpdSupport    = true;
    pulseSupport  = true;
  };


  fifo = "/tmp/cava.fifo";

  H = 320;       # bar height in px
  MAX = 1000;    # MUST match cava ascii_max_range

  cavaToHeights = pkgs.writeShellScript "cavaToHeights" ''
    set -euo pipefail
    FIFO=${fifo}

    [ -p "$FIFO" ] || { rm -f "$FIFO"; mkfifo -m 600 "$FIFO"; }

    awk -F';' -v max="${toString MAX}" -v h="${toString H}" '
      {
        out = ""
        for (i = 1; i <= NF; i++) {
          if ($i == "") continue
          n = $i + 0
          if (n < 0) n = 0
          if (n > max) n = max
          px = int((n * h) / max + 0.5)
          if (px < 0) px = 0
          if (px > h) px = h
          out = out (out=="" ? "" : " ") px
        }
        if (out != "") print out
        fflush()
      }
    ' < "$FIFO"
  '';

  mkfifo = "${pkgs.coreutils}/bin/mkfifo";

  reader = pkgs.writeShellScript "cava-reader" ''
    set -euo pipefail
    while true; do
      [ -p ${fifo} ] || { rm -f ${fifo}; ${mkfifo} -m 600 ${fifo}; }
      cat ${fifo}
      sleep 0.05
    done
  '';

  # Catppuccin
  base     = "#1e1e2e";
  mantle   = "#181825";
  crust    = "#11111b";
  text     = "#cdd6f4";
  subtext  = "#bac2de";
  surface0 = "#313244";
  surface1 = "#45475a";
  blue     = "#89b4fa";
  mauve    = "#cba6f7";
  pink     = "#f5c2e7";
  red      = "#f38ba8";
  green    = "#a6e3a1";
  yellow   = "#f9e2af";

in {
  home.file.".wallpaper.jpg".source = ../../../wallpaper/lofi-cafe.jpg;

  home = {
    packages = [
      pkgs.ashell
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
      pkgs.hypridle
      pkgs.hyprlock
      pkgs.hyprpaper
      pkgs.killall
      pkgs.loupe
      pkgs.material-design-icons
      pkgs.nodejs
      pkgs.obsidian
      pkgs.nautilus
      pkgs.pavucontrol # Audio
      pkgs.playerctl
      pkgs.slurp
      pkgs.swappy
      pkgs.swww
      pkgs.transmission_4
      pkgs.waybar
      pkgs.wofi
      pkgs.wl-clipboard
      pkgs.vlc
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

    theme = {
      name = "Catppucinn-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk;
    };

    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = 1;
    };

    gtk4.extraConfig = {
      "gtk-application-prefer-dark-theme" = 1;
    };
  };

  xdg = {
    enable = true;

    configFile = {
      "ashell/config.toml".text = ''
        [appearance]
        style            = "Islands"
        opacity          = 0.85
        success_color    = "${green}"
        text_color       = "${text}"
        workspace_colors = [ "${mauve}", "${pink}", "${blue}" ]

        [appearance.primary_color]
        base = "#fab387"
        text = "#1e1e2e"

        [appearance.danger_color]
        base = "#f38ba8"
        weak = "#f9e2af"

        [appearance.background_color]
        base   = "#1e1e2e"
        weak   = "#313244"
        strong = "#45475a"

        [appearance.menu]
        opacity  = 0.75
        backdrop = 0.30
      '';

      "eww/eww.yuck".text = ''
        (deflisten heights :initial "0 0 0 0" "${cavaToHeights}")

        (defwidget cava-bg []
          (box
            :class "root"
            :orientation "h"
            :spacing 2
            :valign "end"
            :vexpand true
            (for px in {search(heights, "[0-9]+")}
              (box
                :class "barwrap"
                :width 8
                :height 160
                :clip true
                :valign "end"
                (box
                  :class "bar"
                  :valign "end"
                  :height px)))))

        (defwindow cava_bg
          :monitor 0
          :stacking "bg"
          :layer "background"
          :exclusive false
          :focusable false
          :geometry (geometry :x 0 :y 0 :width "100%" :height "100%")
          (box :class "cava-window" :hexpand true :vexpand true
            (cava-bg)))
      '';

      "eww/eww.scss".text = ''
        * {
          all: unset;
        }

        .cava-window, .root {
          background-color: rgba(0, 0, 0, 0);
          padding: 0px;
        }

        .bar {
          background: rgba(255, 255, 255, 0.25);
        }
      '';

      "eww/eww.xml".text = ''
        <eww>
          <window
            name="cava_bg"
            monitor="0"
            layer="background"
            stacking="bg"
            exclusive="false"
            focusable="false"
            geometry="x=0 y=0 width=100% height=100%"
          >
            <widget>cava-bg</widget>
          </window>
        </eww>
      '';

      "wofi/style.css".text = ''
        window {
          margin: 0px;
          padding: 10px;
          background-color: rgba(30, 30, 46, 0.92);
          border-radius: 16px;
          border: 2px solid rgba(137, 180, 250, 0.60)
          color: #cdd6f4;
          font-size: 15px;
        }

        #input {
          margin: 6px;
          padding: 10px 12px;
          border-radius: 12px;
          border: 1px solid rgba(49, 50, 68, 1.0);
          background-color: rgba(24, 24, 37, 0.75);
          color: #cdd6f4;
        }

        #inner-box {
          margin: 6px;
        }

        #outer-box {
          margin: 0px;
        }

        #entry {
          padding: 8px 10px;
          margin: 2px 6px;
          border-radius: 10px;
          color: #cdd6f4;
        }

        #entry:selected {
          background: rgba(49, 50, 68, 0.85);
          border: 1px solid rgba(203, 166, 247, 0.6);
        }

        text {
          margin-left: 6px;
        }

        #img {
          margin-right: 6px;
        }
      '';

      "wofi/config".text = ''
        show=drun
        prompt=Run
        width=520
        lines=8
        allow_images=true
        image_size=24
        insensitive=true
      '';

     "hypr/hypridle.conf".text = ''
       general {
         lock_cmd = hyprlock
         before_sleep_cmd = hyprlock
         after_sleep_cmd = hyprctl dispatch dpms on
       }

       listener {
         timeout    = 300 # Lock after 5 minutes
         on-timeout = hyprlock
       }

       listener {
         timeout    = 600 # Turn display off after 10 minutes
         on-timeout = hyprctl dispatch dpms off
         on-resume  = hyprctl dispatch dpms on
       }

       listener {
         timeout    = 1200 # Suspend after 20 minutes
         on-timeout = systemctl suspend
       }
     '';

     "hypr/hyprlock.conf".text = ''
       general {
         disable_loading_bar = true
         hide_cursor = true
       }

       background {
         monitor =
         path = screenshot
         blur_passes = 3
         blur_size = 8
         brightness = 0.8
       }

       input-field {
         monitor =
         placeholder_text = Password
         placeholder_color = ${mauve}

         size = 500, 60
         outline_thickness = 2

         dots_size = 0.25
         dots_spacing = 0.15
         dots_center = true

         outer_color = ${pink}
         inner_color = ${base}
         font_color  = ${mauve}

         fade_on_empty = false

         rounding = 12
         position = 0, -100

         halign = center
         valign = center
       }

       label {
         monitior =
         text = cmd[update:1000] date +'%H:%M'
         color = ${text}
         font_size = 64
         position = 0, 120
         halign = center
         valign = center
       }

       label {
         monitor =
         text = Take your time.
         font_size = 18
         position = 0, 60
         halign = center
         valign = center
       }
     '';
    };
  };

  programs = {
    ghostty.enable = true;

    cava = {
      enable = true;
      settings = {
        general = {
          framerate = 30;
          bars = 64;
        };

        input = {
          method = "pulse";
          source = "auto";
        };

        output = {
          method = "raw";
          raw_target = "/tmp/cava.fifo";
          data_format = "ascii";

          # CAVA outputs values 0..ascii_max_range as text
          ascii_max_range = 1000;

          # delimit bars with ';' and frames with newline
          bar_delimiter = 59;
          frame_delimiter = 10;
        };

        smoothing = {
          integral = 75;
          gravity = 120;
        };
      };
    };

    eww = {
      enable = true;
    };

    waybar = {
      enable = true;
      settings = [
        {
          layer = "top";
          positon = "top";
          height = 34;
          spacing = 8;

          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];

          modules-center = [ "clock" ];

          modules-right = [
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "battery"
            "tray"
          ];

          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            format = "{name}";
          };

          "hyprland/window" = {
            max-length = 60;
            separate-outputs = true;
          };

          clock = {
            format = "{:%a %b %d  %H:%M}";
            tooltip-format = "<big>{:%Y-%m-%d}</big>\n<tt>{calendar}</tt>";
          };

          network = {
            format-wifi = "W {signalStrength}%";
            format-ethernet = "E {ipaddr}";
            format-disconnected = "N down";
            tooltip = true;
          };

          cpu = {
            format = "C {usage}%";
          };

          memory = {
            format = "M {percentage}%";
          };

          battery = {
            format = "{capacity}% {icon}";
            # format-icons = []
          };

          tray = {
            spacing = 8;
          };
        }
      ];

       style = ''
         * {
           border: none;
           border-radius: 0;
           min-height: 0;
           font-family: Inter, "JetBrains Mono", "Noto Sans", sans-serif;
           font-size: 13px;
           padding: 0;
           margin: 0;
         }

         window#waybar {
           background: rgba(30, 30, 46, 0.72);
           color: ${text};
           border-bottom: 1px solid rgba(69, 71, 90, 0.55);
         }

         .modules-left, .modules-center, .modules-right {
           margin: 6px 10px;
         }

         #workspaces, #window, #clock, #network, #pulseaudio, #cpu, #memory, #battery, #tray {
           background: rgba(24, 24, 37, 0.70);
           color: ${text};
           margin: 4px 6px;
           padding: 6px 10px;
           border-radius: 12px;
           border: 1px solid rgba(49, 50, 68, 0.80);
         }

         #workspaces {
           padding: 4px 8px;
         }

         #workspaces button {
           background: transparent;
           color: ${subtext};
           padding: 0 8px;
           margin: 2px 3px;
           border-radius: 10px;
           border: 1px solid transparent;
         }

         #workspaces button.active {
           color: ${text};
           border: 1px solid rgba(243, 139, 168, 0.70);
           background: rgba(243, 139, 168, 0.15);
         }

         #workspace button:hover {
           border: 1px solid rgba(203, 166, 247, 0.65);
           background: rgba(203, 166, 247, 0.12);
         }

         #clock {
           border: 1px solid rgba(203, 166, 247, 0.65);
           background: rgba(203, 166, 247, 0.12);
         }

         #pulseaudio {
           border: 1px solid rgba(245, 194, 231, 0.50);
         }

         #network {
           border: 1px solid rgba(137, 180, 250, 0.50);
         }

         #battery {
           border: 1px solid rgba(166, 227, 161, 0.45);
         }

         #tray {
           padding-right: 8px;
         }

         tooltip {
           background: rgba(17, 17, 27, 0.92);
           color: ${text};
           border-radius: 12px;
           border: 1px solid rgba(69, 71, 90, 0.65);
           padding: 8px;
         }
       '';
    };
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
        preload   = [ "${config.home.homeDirectory}/Pictures/Wallpaper/cosy-cabin.jpg" ];
        wallpaper = [ ",${config.home.homeDirectory}/Pictures/Wallpaper/cosy-cabin.jpg" ];
        splash    = false;
      };
    };

    hyprshell = {
      enable = true;
      settings = {
        windows = {
          scale = 1.0;
          switch = {
            modifier = "SUPER";
            switch_workspaces = true;
          };
        };
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
        "ashell"
        "hypridle"
        "eww daemon"
        "eww open cava_bg"
        "cava"
        "mako"
        "wl-paste --type text  --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "swww init"
        "swww img ${config.home.homeDirectory}/Pictures/Wallpaper/cosy-cabin.jpg --transition-type wipe --transition-duration 0.8"
      ];

      # Look & Feel
      general = {
        layout      = "dwindle";
        gaps_in     = 6;
        gaps_out    = 14;
        border_size = 2;
        "col.active_border"   = "rgba(f5c2e7ee) rgba(cba6f7ee) 45deg";
        # "col.active_border"   = "rgba(89b4faee) rgba(cba6f7ee) 45deg";
        "col.inactive_border" = "rgba(45475aaa)";
        resize_on_border = true;
        extend_border_grab_area = 15;
      };

      decoration = {
        rounding = 12;

        blur = {
          enabled = true;
          size    = 6;
          passes  = 3;
          new_optimizations = true;
          ignore_opacity    = false;
          # ignore_opacity    = true;
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
            "windows,    1, 3, easeOut,   slide"
            "windowsOut, 1, 3, easeOut,   slide"
            "border,     1, 4, easeInOut"
            "fade,       1, 3, easeInOut"
            "workspaces, 1, 3, easeOut,   slide"
          ];

          # Keys
          "$mod" = "SUPER";

          bind = [
            # App Control
            "$mod,       SPACE,  exec, sh -lc 'flock -n \"$XDG_RUNTIME_DIR/wofi.lock\" wofi --show drun'"
            "$mod,       Return, exec, ghostty"
            # "$mod,       M,      hyprexpo:expo toggle"
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
            "$mod,       1,     workspace,    1"
            "$mod,       2,     workspace,    2"
            "$mod,       3,     workspace,    3"
            "$mod,       4,     workspace,    4"
            "$mod,       5,     workspace,    5"
            "$mod,       6,     workspace,    6"
            "$mod,       7,     workspace,    7"
            "$mod,       8,     workspace,    8"
            "$mod,       9,     workspace,    9"
            "$mod CTRL,  Left,  workspace,    m-1"
            "$mod CTRL,  Right, workspace,    m+1"

            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
            "$mod SHIFT, 5, movetoworkspace, 5"
            "$mod SHIFT, 6, movetoworkspace, 6"
            "$mod SHIFT, 7, movetoworkspace, 7"
            "$mod SHIFT, 8, movetoworkspace, 8"
            "$mod SHIFT, 9, movetoworkspace, 9"

            # Idle
            "$mod SHIFT, L, exec, hyprlock"

            # Screenshots
            ", Print, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%F-%T).png"
          ];

          bindm = [
            # Resize
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
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
            "opacity 0.92 0.80,class:.*"
          ];

          misc = {};
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
