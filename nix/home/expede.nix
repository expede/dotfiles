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

      # AI
      unstable.copilot-language-server
      unstable.claude-code

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

    jujutsu = {
      enable = true;
    };

    jjui = {
        enable = true;
        settings = {
            theme = "catppuccin-mocha";
        };
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
          disabled = false;
          success_symbol = "[❯](bold fg:green)";
          error_symbol = "[❯](bold fg:red)";
          vimcmd_symbol = "[❮](bold fg:green)";
          vimcmd_replace_one_symbol = "[❮](bold fg:lavender)";
          vimcmd_replace_symbol = "[❮](bold fg:lavender)";
          vimcmd_visual_symbol = "[❮](bold fg:yellow)";
        };

        cmd_duration = {
          show_milliseconds = true;
          format = " in $duration ";
          style = "bg:lavender";
          disabled = false;
          show_notifications = true;
          min_time_to_notify = 45000;
        };

        hostname = {
          ssh_only = false;
          style = "bg:#9A348E ${stc}";
          format = "[on $hostname ]($style)";
        };

        palette = "catppuccin_mocha";
        gcloud.disabled = true;

        # format = "[](#9A348E)$os$username$hostname$sudo[](bg:#DA627D fg:#9A348E)$directory[](fg:#DA627D bg:#FCA17D)$git_branch$git_status[](fg:#FCA17D bg:#FDFD96)$nix_shell[](fg:#FDFD96 bg:#86BBD8)$cr$elm$golang$gradle$haskell$java$julia$nodejs$nim$rust$scala[](fg:#86BBD8 bg:#06969A)$docker_context[](fg:#06969A bg:#33658A)$time[ ](fg:#33658A)";

        format = "[](red)$os$username[](bg:peach fg:red)$directory[](bg:yellow fg:peach)$git_branch$git_status[](fg:yellow bg:green)$c$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:green bg:sapphire)$conda[](fg:sapphire bg:lavender)$time[ ](fg:lavender)$cmd_duration$line_break$character";

        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };

        palettes.catppuccin_frappe = {
          rosewater = "#f2d5cf";
          flamingo = "#eebebe";
          pink = "#f4b8e4";
          mauve = "#ca9ee6";
          red = "#e78284";
          maroon = "#ea999c";
          peach = "#ef9f76";
          yellow = "#e5c890";
          green = "#a6d189";
          teal = "#81c8be";
          sky = "#99d1db";
          sapphire = "#85c1dc";
          blue = "#8caaee";
          lavender = "#babbf1";
          text = "#c6d0f5";
          subtext1 = "#b5bfe2";
          subtext0 = "#a5adce";
          overlay2 = "#949cbb";
          overlay1 = "#838ba7";
          overlay0 = "#737994";
          surface2 = "#626880";
          surface1 = "#51576d";
          surface0 = "#414559";
          base = "#303446";
          mantle = "#292c3c";
          crust = "#232634";
        };


        palettes.catppuccin_latte = {
          rosewater = "#dc8a78";
          flamingo = "#dd7878";
          pink = "#ea76cb";
          mauve = "#8839ef";
          red = "#d20f39";
          maroon = "#e64553";
          peach = "#fe640b";
          yellow = "#df8e1d";
          green = "#40a02b";
          teal = "#179299";
          sky = "#04a5e5";
          sapphire = "#209fb5";
          blue = "#1e66f5";
          lavender = "#7287fd";
          text = "#4c4f69";
          subtext1 = "#5c5f77";
          subtext0 = "#6c6f85";
          overlay2 = "#7c7f93";
          overlay1 = "#8c8fa1";
          overlay0 = "#9ca0b0";
          surface2 = "#acb0be";
          surface1 = "#bcc0cc";
          surface0 = "#ccd0da";
          base = "#eff1f5";
          mantle = "#e6e9ef";
          crust = "#dce0e8";
        };

        palettes.catppuccin_macchiato = {
          rosewater = "#f4dbd6";
          flamingo = "#f0c6c6";
          pink = "#f5bde6";
          mauve = "#c6a0f6";
          red = "#ed8796";
          maroon = "#ee99a0";
          peach = "#f5a97f";
          yellow = "#eed49f";
          green = "#a6da95";
          teal = "#8bd5ca";
          sky = "#91d7e3";
          sapphire = "#7dc4e4";
          blue = "#8aadf4";
          lavender = "#b7bdf8";
          text = "#cad3f5";
          subtext1 = "#b8c0e0";
          subtext0 = "#a5adcb";
          overlay2 = "#939ab7";
          overlay1 = "#8087a2";
          overlay0 = "#6e738d";
          surface2 = "#5b6078";
          surface1 = "#494d64";
          surface0 = "#363a4f";
          base = "#24273a";
          mantle = "#1e2030";
        };

        # Disable the blank line at the start of the prompt
        # add_newline = false

        # You can also replace your username with a neat symbol like   or disable this
        # and use the os module below
        username = {
          show_always = true;
          style_user = "bg:red fg:crust";
          style_root = "bg:red fg:crust";
          format = "[ $user]($style)";
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
          style = "bg:red fg:crust";
          disabled = false; # Disabled by default

          symbols = {
            Windows = "";
            Ubuntu = "󰕈";
            SUSE = "";
            Raspbian = "󰐿";
            Mint = "󰣭";
            Macos = "󰀵";
            Manjaro = "";
            Linux = "󰌽";
            Gentoo = "󰣨";
            Fedora = "󰣛";
            Alpine = "";
            Amazon = "";
            Android = "";
            AOSC = "";
            Arch = "󰣇";
            Artix = "󰣇";
            CentOS = "";
            Debian = "󰣚";
            Redhat = "󱄛";
            RedHatEnterprise = "󱄛";
          };
        };

        directory = {
          style = "bg:peach fg:crust";
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
          "Developer" = "󰲋 ";
          # Keep in mind that the order matters. For example:
          # "Important Documents" = " 󰈙 "
          # will not be replaced, because "Documents" was already substituted before.
          # So either put "Important Documents" before "Documents" or use the substituted version:
          # "Important 󰈙 " = " 󰈙 "
        };

        git_branch = {
          symbol = "";
          style = "bg:yellow";
          format = "[[ $symbol $branch ](fg:crust bg:yellow)]($style)";
        };

        git_status = {
          style = "bg:yellow";
          format = "[[($all_status$ahead_behind )](fg:crust bg:yellow)]($style)";
        };

        nix_shell = {
          format = "[ $symbol$state( \($name\)) ]($style)";
          style = "bg:blue";
          symbol = "❄️";
          impure_msg = "impure";
          pure_msg = "pure";
          unknown_msg = "unknown if pure";
          disabled = false;
        };

        nodejs = {
          symbol = "";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        };

        c = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        };

        rust = {
          symbol = "";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        };

        golang = {
          symbol = "";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        };

        haskell = {
          symbol = "";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        };

        python = {
          symbol = "";
          style = "bg:green";
          format = "[[ $symbol( $version)(\(#$virtualenv\)) ](fg:crust bg:green)]($style)";
        };

        docker_context = {
          symbol = "";
          style = "bg:sapphire";
          format = "[[ $symbol( $context) ](fg:crust bg:sapphire)]($style)";
        };

        conda = {
          symbol = "  ";
          style = "fg:crust bg:sapphire";
          format = "[$symbol$environment ]($style)";
          ignore_base = false;
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:lavender";
          format = "[[  $time ](fg:crust bg:lavender)]($style)";
        };

        line_break.disabled = true;
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
