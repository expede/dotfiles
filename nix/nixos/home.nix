# NixOS specific modifications to the home manager
{ pkgs }:
  let
    polybarOverrides = pkgs.polybarFull.override {
      alsaSupport   = true;
      githubSupport = true;
      mpdSupport    = true;
      pulseSupport  = true;
    };

  in {
    home.file.".wallpaper.jpg".source = ../../wallpaper/lofi-cafe.jpg;

    gtk = {
      enable = true;

      # theme = {
      #   name = "Adwaita-dark";
      #   package = pkgs.gnome3.gnome-themes-extra;
      # };

      # cursorTheme = {
      #   name    = "Vanilla-DMZ";
      #   package = pkgs.vanilla-dmz;
      # };

      # iconTheme = {
      #   name    = "Vanilla-DMZ";
      #   package = pkgs.vanilla-dmz; # gnome3.adwaita-icon-theme;
      # };
    };

    packages = [
      pkgs.blueberry # Bluetooth
      pkgs.cider
      pkgs.conky
      pkgs.discord
      pkgs.feh
      pkgs.guake
      pkgs.killall
      pkgs.material-design-icons
      pkgs.obsidian
      pkgs.pavucontrol # Audio
      # pkgs.xdotool # Help Rofi display emoji
      pkgs.zoom-us
    ];

    programs = {
      # rofi = {
      #   enable  = true;
      #   cycle = true;
      #   plugins = [
      #     pkgs.rofi-calc
      #     pkgs.rofi-emoji
      #   ];
      # };
    };

    services = {
      emacs.enable = true;

      # polybar = {
      #   enable = true;
      #   package = polybarOverrides;

      #   settings = {
      #     "global/wm" = {
      #       margin-top    = 0;
      #       margin-bottom = 0;
      #     };

      #     layout = {
      #       module-padding = 1;
      #     } ;

      #     "bar/top" = {
      #       width = "100%";
      #       height = 48; # Pixels
      #       radius = 6.0;
      #       fixed-center = true;
      #       background = "#89dceb";

      #       padding = 20;
      #       module-margin = 2;
      #       locale = "en_GB.UTF-8";

      #       modules-left = "xmonad";
      #       modules-right = "ewnh datetime";
      #     };

      #     "module/datetime" = {
      #       type = "internal/date";
      #       date = "%a %d %b %Y";
      #       time = "%H:%M:%S";
      #       # format = "🕓 <label>";
      #     };

      #     "module/ewmh" = {
      #       type = "internal/xworkspaces";
      #       enable-click = false;
      #       enable-scroll = false;

      #       format = "<label-state>";
      #       label-active = "%icon%";
      #       label-occupied = "%icon%";
      #       label-empty = "%icon%";

      #       label-empty-padding = 1;
      #       label-active-padding = 1;
      #       label-urgent-padding = 1;
      #       label-occupied-padding = 1;

      #       #          label-empty-foreground = "${colors.surface2}";
      #       #          label-active-foreground = "${colors.green}";
      #       #          label-urgent-foreground = "${colors.red}";
      #       #          label-occupied-foreground = "${colors.flamingo}";
      #     };

      #     "module/xmonad" = {
      #       type = "custom/script";
      #       exec = "${pkgs.xmonad-log}/bin/xmonad-log";
      #       tail = true;
      #       format-font = 5;
      #       # format-offset = -20;
      #     };
      #   };

      #   script = "";

      #   # script = ''
      #   #   ${pkgs.polybar}/bin/polybar top &
      #   #   ${pkgs.feh}/bin/feh --bg-fill ${wallpaper} &
      #   # '';
      # };

      # picom = {
      #   enable = true;
      #   fade = true;
      #   inactiveOpacity = 0.9;
      #   backend = "glx";
      #   settings = {
      #     corner-radius = 8;
      #     rounded-borders = 1;
      #     rounded-corners-exclude = ["window_type = 'dock'"];
      #     rounded-borders-exclude = ["window_type = 'dock'"];
      #   };
      # };

      gpg-agent = {
        enable           = true;
        enableSshSupport = true;
        pinentryPackage  = pkgs.pinentry.curses; # "curses";

        #extraConfig = ''
        #  pinentry-program ${pkgs.pinentry.curses}/bin/pinentry
        #'';
      };
    };

    gpg = {
      format                 = "ssh";
      commit.gpgsign         = true;
      user.signingkey        = "~/.ssh/id_ed25519.pub";
      ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };

    signing-key          = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5QDR5zYVvboJ+SJ5sIBVaRPwOrBv9P/AR6Kj5XBPqO hello@brooklynzelenka.com";
    flake-rebuild-switch = "nixos-rebuild switch";
  }
