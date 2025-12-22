{ config, pkgs, lib, ... }:

{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;

    settings = {
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
  };

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
                   format_left  "{mode}#[fg=black,bg=blue,bold]{session}  #[fg=blue,bg=#181825]{tabs}"
                   format_right "#[fg=#181825,bg=#b1bbfa]{datetime}"
                   format_space "#[bg=#181825]"

                   hide_frame_for_single_pane "true"

                   mode_normal  "#[bg=blue] "

                   tab_normal              "#[fg=#181825,bg=#4C4C59] #[fg=#000000,bg=#4C4C59]{index}  {name} #[fg=#4C4C59,bg=#181825]"
                   tab_normal_fullscreen   "#[fg=#6C7086,bg=#181825] {index} {name} [] "
                   tab_normal_sync         "#[fg=#6C7086,bg=#181825] {index} {name} <> "
                   tab_active              "#[fg=#181825,bg=#ffffff,bold] {index}  {name} #[fg=#ffffff,bg=#181825]"
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
}
