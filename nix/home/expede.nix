{
  arch,
  homeDirectory,
  hostname,
  pkgs,
  system,
  unstable,
  username,
  ...
}:
  let
    homeOverrides = if arch ? home then arch.home else {};
    stc = "#252033"; # starship text colour
  in {
  home = {
    inherit username;

    stateVersion = "23.11";

    packages = [
      pkgs.cachix
      pkgs.coreutils
      pkgs.fd
      pkgs.font-awesome
      pkgs.ispell
      pkgs.mosh
      pkgs.speedtest-cli
      pkgs.tokei
      pkgs.wget
      unstable.copilot-language-server

      # Process
      pkgs.btop
      pkgs.lsof

      # FS
      pkgs.ripgrep
      pkgs.tree

      # Editors
      (pkgs.emacs.override { withNativeCompilation = false; })
    ] ++ arch.packages;

    file."Library/Application Support/com.mitchellh.ghostty/config" = {
      force = true;
      text = ''
        theme = dracula

        font-family = Victor Mono
        font-size = 12
        font-thicken = true

        background-opacity = 0.88
        background-blur = 20
        background = 1f1130

        cursor-opacity = 0.5
        cursor-color = 8be9fd

        keybind = global:option+\=toggle_quick_terminal
        quick-terminal-animation-duration = 0
        quick-terminal-size = 100%

        desktop-notifications = true
        clipboard-read = allow
        clipboard-write = allow

        macos-icon = paper
        macos-auto-secure-input = true
        macos-secure-input-indication = true
        macos-option-as-alt = true

        shell-integration = detect
        # command = /run/current-system/sw/bin/fish
      '';
    };
  } // homeOverrides;

  programs = {
    autojump.enable = true;
    bat.enable      = true;

    atuin = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
      # enableZshIntegration = true;

      settings = {
        enter_accept = true;
        inline_height = 40;
        theme.name = "marine";
      };
    };

    kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;
    };

    # TODO currently marked as broken :(
    # ghostty = {
    #   enable = true;
    #   enableFishIntegration = true;
    #   enableZshIntegration = true;
    #   settings = {
    #     theme = "solarized";
    #     # theme = "dracula";
    #     quick-terminal-animation-duration = 0;

    #     font-family = "Victor Mono";
    #     font-size = 12;
    #     font-thicken = true;

    #     background-opacity = 0.88;
    #     background-blur = 20;
    #     background = "1f1130";

    #     cursor-opacity = 0.5;
    #     cursor-color = "8be9fd";

    #     keybind = "global:option+\=toggle_quick_terminal";
    #     macos-option-as-alt = true;

    #     desktop-notifications = true;
    #     clipboard-read = "allow";
    #     clipboard-write = "allow";

    #     macos-icon = "paper";
    #     macos-auto-secure-input = true;
    #     macos-secure-input-indication = true;

    #     shell-integration = "detect";
    #     command = "${pkgs.fish}/bin/fish";
    #   };
    # };

    git  = import ./git.nix {
      inherit username;

      gpg         = arch.gpg;
      signing-key = arch.signing-key;
    };

    zellij = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;

      settings = {
        # theme = "dracula";
        # theme = "tokyo-night";
        theme = "catppuccin-mocha";
        default_shell = "${pkgs.fish}/bin/fish";
      };

      # Source: https://github.com/zellij-org/zellij/blob/main/zellij-utils/assets/themes/catppuccin-mocha.kdl
      themes."catppuccin-mocha" = ''
        themes {
          catppuccin-mocha {
            text_unselected {
              base 205 214 244
              background 24 24 37
              emphasis_0 250 179 135
              emphasis_1 137 220 235
              emphasis_2 166 227 161
              emphasis_3 245 194 231
            }
            text_selected {
              base 205 214 244
              background 88 91 112
              emphasis_0 250 179 135
              emphasis_1 137 220 235
              emphasis_2 166 227 161
              emphasis_3 245 194 231
            }
            ribbon_selected {
              base 24 24 37
              background 166 227 161
              emphasis_0 243 139 168
              emphasis_1 250 179 135
              emphasis_2 245 194 231
              emphasis_3 137 180 250
            }
            ribbon_unselected {
              base 24 24 37
              background 205 214 244
              emphasis_0 243 139 168
              emphasis_1 205 214 244
              emphasis_2 137 180 250
              emphasis_3 245 194 231
            }
            table_title {
              base 166 227 161
              background 0
              emphasis_0 250 179 135
              emphasis_1 137 220 235
              emphasis_2 166 227 161
              emphasis_3 245 194 231
            }
            table_cell_selected {
              base 205 214 244
              background 88 91 112
              emphasis_0 250 179 135
              emphasis_1 137 220 235
              emphasis_2 166 227 161
              emphasis_3 245 194 231
            }
            table_cell_unselected {
              base 205 214 244
              background 24 24 37
              emphasis_0 250 179 135
              emphasis_1 137 220 235
              emphasis_2 166 227 161
              emphasis_3 245 194 231
            }
            list_selected {
              base 205 214 244
              background 88 91 112
              emphasis_0 250 179 135
              emphasis_1 137 220 235
              emphasis_2 166 227 161
              emphasis_3 245 194 231
            }
            list_unselected {
              base 205 214 244
              background 24 24 37
              emphasis_0 250 179 135
              emphasis_1 137 220 235
              emphasis_2 166 227 161
              emphasis_3 245 194 231
            }
            frame_selected {
              base 166 227 161
              background 0
              emphasis_0 250 179 135
              emphasis_1 137 220 235
              emphasis_2 245 194 231
              emphasis_3 0
            }
            frame_highlight {
              base 250 179 135
              background 0
              emphasis_0 245 194 231
              emphasis_1 250 179 135
              emphasis_2 250 179 135
              emphasis_3 250 179 135
            }
            exit_code_success {
              base 166 227 161
              background 0
              emphasis_0 137 220 235
              emphasis_1 24 24 37
              emphasis_2 245 194 231
              emphasis_3 137 180 250
            }
            exit_code_error {
              base 243 139 168
              background 0
              emphasis_0 249 226 175
              emphasis_1 0
              emphasis_2 0
              emphasis_3 0
            }
            multiplayer_user_colors {
              player_1 245 194 231
              player_2 137 180 250
              player_3 0
              player_4 249 226 175
              player_5 137 220 235
              player_6 0
              player_7 243 139 168
              player_8 0
              player_9 0
              player_10 0
            }
          }
        }
      '';

      # NOTE See `xdg` for more config
    };

    # ssh = {
    #   enable = true;
    #   matchBlocks = {
    #     "*" = {
    #       extraOptions = {
    #         IdentityAgent = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    #         AddKeysToAgent = "yes";
    #         UseKeychain   = "yes"; # macOS
    #       };
    #     };
    #   };
    # };

    # jujutsu = {
    #   enable = true;
    #   settings = {
    #     user = {
    #       email = "hello@brooklynzelenka.com";
    #       name = "Brooklyn Zelenka";
    #     };

    #     ui.editor = "vim";
    #     ui.diff-editor = "vimdiff";

    #     signing = {
    #       behavior = "own";
    #       backend = "ssh";

    #       key = arch.signing-key;
    #       sign-all = true;

    #       backends.ssh = {
    #         program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    #       };
    #     };
    #   };
    # };

    fish = import ./fish.nix {
	    flake-rebuild-switch = arch.flake-rebuild-switch;
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    dircolors = {
      enable = true;
      enableFishIntegration = true;
    };

    starship = {
      enable = true;

      enableFishIntegration = true;
      # enableZshIntegration  = true;

      settings = {
        character = {
          success_symbol = "[»](bold green) ";
          error_symbol   = "[✗](bold red) ";
        };

        hostname = {
          ssh_only = false;
          style = "bg:#9A348E ${stc}";
          format = "[on $hostname ]($style)";
        };

        gcloud.disabled = true;

        format = "[](#9A348E)$os$username$hostname$sudo[](bg:#DA627D fg:#9A348E)$directory[](fg:#DA627D bg:#FCA17D)$git_branch$git_status[](fg:#FCA17D bg:#FDFD96)$nix_shell[](fg:#FDFD96 bg:#86BBD8)$cr$elm$golang$gradle$haskell$java$julia$nodejs$nim$rust$scala[](fg:#86BBD8 bg:#06969A)$docker_context[](fg:#06969A bg:#33658A)$time[ ](fg:#33658A)";

        # Disable the blank line at the start of the prompt
        # add_newline = false

        # You can also replace your username with a neat symbol like   or disable this
        # and use the os module below
         username = {
           show_always = true;
           style_user = "bg:#9A348E ${stc}";
           style_root = "bg:#9A348E ${stc}";
           format = "[$user ]($style)";
           disabled = false;
         };

        sudo = {
          style = "bg:#9A348E ${stc}";
          symbol = "🦸‍♀️ ";
          format = "[as $symbol]($style)";
          disabled = false;
        };

       # An alternative to the username module which displays a symbol that
       # represents the current operating system
        os = {
          format = "[$symbol]($style)";
          style = "bg:#9A348E ${stc}";
          disabled = false; # Disabled by default

          symbols = {
            Alpaquita = "🔔 ";
            Alpine = "🏔️ ";
            Amazon = "🙂 ";
            Android = "🤖 ";
            Arch = "🎗️ ";
            Artix = "🎗️ ";
            CentOS = "💠 ";
            Debian = "🌀 ";
            DragonFly = "🐉 ";
            Emscripten = "🔗 ";
            EndeavourOS = "🚀 ";
            Fedora = "🎩 ";
            FreeBSD = "😈 ";
            Garuda = "🦅 ";
            Gentoo = "🗜️ ";
            HardenedBSD = "🛡️ ";
            Illumos = "🐦 ";
            Linux = "🐧 ";
            Mabox = "📦 ";
            Macos = "🍎 ";
            Manjaro = "🥭 ";
            Mariner = "🌊 ";
            MidnightBSD = "🌘 ";
            Mint = "🌿 ";
            NetBSD = "🚩 ";
            NixOS = "❄️ ";
            OpenBSD = "🐡 ";
            OpenCloudOS = "☁️ ";
            openEuler = "🦉 ";
            openSUSE = "🦎 ";
            OracleLinux = "🦴 ";
            Pop = "🍭 ";
            Raspbian = "🍓 ";
            Redhat = "🎩 ";
            RedHatEnterprise = "🎩 ";
            Redox = "🧪 ";
            Solus = "⛵ ";
            SUSE = "🦎 ";
            Ubuntu = "🎯 ";
            Unknown = "❓ ";
            Windows = "🪟 ";
          };
        };

        directory = {
          style = "bg:#DA627D ${stc}";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
        };

        # Here is how you can shorten some long paths by text replacement
        # similar to mapped_locations in Oh My Posh:
        directory.substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
          # Keep in mind that the order matters. For example:
          # "Important Documents" = " 󰈙 "
          # will not be replaced, because "Documents" was already substituted before.
          # So either put "Important Documents" before "Documents" or use the substituted version:
          # "Important 󰈙 " = " 󰈙 "
        };

        c = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        docker_context = {
          symbol = " ";
          style = "bg:#06969A ${stc}";
          format = "[ $symbol $context ]($style) $path";
        };

        elixir = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        elm = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        git_branch = {
          symbol = "";
          style = "bg:#FCA17D ${stc}";
          format = "[ $symbol $branch ]($style)";
        };

        git_status = {
          style = "bg:#FCA17D ${stc}";
          format = "[$all_status$ahead_behind ]($style)";
        };

        golang = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        gradle = {
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        haskell = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        java = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        julia = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        nodejs = {
          symbol = "";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        nim = {
          symbol = "󰆥 ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        rust = {
          symbol = "";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        scala = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        nix_shell = {
          format = "[ $symbol$state( \($name\)) ]($style)";
          style = "bg:#fdfd96 ${stc}";
          symbol = "❄️ ";
          impure_msg = "impure";
          pure_msg = "pure";
          unknown_msg = "unknown if pure";
          disabled = false;
        };

        time = {
          disabled = false;
          time_format = "%R"; # Hour:Minute Format
          style = "bg:#33658A ${stc}";
          format = "[ 🕐 $time ]($style)";
        };
      };
    };
  } // arch.programs;

  xdg.configFile = {
    "zellij/config.kdl".text = ''
      keybinds {
        normal {
          bind "Ctrl Space" { NextSwapLayout; }
          bind "Ctrl Shift Space" { PreviousSwapLayout; }

          bind "Ctrl Shift h" { MoveFocus "Left"; }
          bind "Ctrl Shift l" { MoveFocus "Right"; }
          bind "Ctrl Shift j" { MoveFocus "Down"; }
          bind "Ctrl Shift k" { MoveFocus "Up"; }
        }
      }
    '';

    "zellij/layouts/clean.kdl".text = ''
      layout {
        pane { }
      }
    '';

    "zellij/layouts/minimal.kdl".text = ''
      layout {
          default_tab_template {
              children
              pane size=1 borderless=true {
                  plugin location="https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm" {
                      format_left   "{mode} #[fg=#89B4FA,bold]{session}"
                      format_center "{tabs}"
                      format_right  "{command_git_branch} {datetime}"
                      format_space  ""

                      border_enabled  "false"
                      border_char     "─"
                      border_format   "#[fg=#6C7086]{char}"
                      border_position "top"

                      hide_frame_for_single_pane "true"

                      mode_normal  "#[bg=blue] "
                      mode_tmux    "#[bg=#ffc387] "

                      tab_normal   "#[fg=#6C7086] {name} "
                      tab_active   "#[fg=#9399B2,bold,italic] {name} "

                      command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                      command_git_branch_format      "#[fg=blue] {stdout} "
                      command_git_branch_interval    "10"
                      command_git_branch_rendermode  "static"

                      datetime        "#[fg=#6C7086,bold] {format} "
                      datetime_format "%A, %d %b %Y %H:%M"
                      datetime_timezone "Europe/Berlin"
                  }
              }
          }
      }
    '';

    "zellij/layouts/slanted.kdl".text = ''
       layout {
           pane split_direction="vertical" {
               pane
           }

           pane size=1 borderless=true {
               plugin location="https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm" {
                   format_left  "{mode}#[fg=black,bg=blue,bold]{session}  #[fg=blue,bg=#181825]{tabs}"
                   format_right "#[fg=#181825,bg=#b1bbfa]{datetime}"
                   format_space "#[bg=#181825]"

                   hide_frame_for_single_pane "true"

                   mode_normal  "#[bg=blue] "

                   tab_normal              "#[fg=#181825,bg=#4C4C59] #[fg=#000000,bg=#4C4C59]{index}  {name} #[fg=#4C4C59,bg=#181825]"
                   tab_normal_fullscreen   "#[fg=#6C7086,bg=#181825] {index} {name} [] "
                   tab_normal_sync         "#[fg=#6C7086,bg=#181825] {index} {name} <> "
                   tab_active              "#[fg=#181825,bg=#ffffff,bold] {index}  {name} #[fg=#ffffff,bg=#181825]"
                   tab_active_fullscreen   "#[fg=#9399B2,bg=#181825,bold] {index} {name} [] "
                   tab_active_sync         "#[fg=#9399B2,bg=#181825,bold] {index} {name} <> "

                   datetime          "#[fg=#6C7086,bg=#b1bbfa,bold] {format} "
                   datetime_format   "%A, %d %b %Y %H:%M"
                   datetime_timezone "America/Vancouver"
               }
           }
       }
    '';
  };

  services = arch.services;
}
