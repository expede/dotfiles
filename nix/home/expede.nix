{ pkgs, unstable, homeDirectory, hostname, system, pure, ...}:
  let
    impure-flag = if pure then "" else "--impure";
    darwin-flake-build = "env NIXPKGS_ALLOW_UNFREE=1 nix build ~/Documents/dotfiles/nix/darwin#darwinConfigurations.${hostname}.system ${impure-flag}";
    darwin-flake-switch = "env NIXPKGS_ALLOW_UNFREE=1 ./result/sw/bin/darwin-rebuild switch --flake ~/Documents/dotfiles/nix/darwin ${impure-flag}";
  in
    {
      home = {
        stateVersion = "22.11";

        username = "expede";

        packages = [
          # pkgs._1password
          pkgs.cachix
          pkgs.coreutils
          pkgs.fastly
          pkgs.fd
          pkgs.ffmpeg
          pkgs.graphviz
          # pkgs.manim
          pkgs.mosh
          pkgs.nodejs
          pkgs.opensc
          pkgs.pandoc
          pkgs.pinentry_mac
          pkgs.speedtest-cli
          pkgs.trash-cli
          pkgs.wget

          # Process
          pkgs.btop
          pkgs.lsof

          # FS
          pkgs.ripgrep
          pkgs.tree

          # Data
          unstable.kubo

          # Agda
          # pkgs.agda

          # Rust
          pkgs.cargo
          # unstable.cargo-generate
            # unstable.rustc

            # Python
            # pkgs.python3
            # pkgs.pipx

            # Haskell
            pkgs.stack

            # Wasm
            pkgs.wasm-bindgen-cli

            # Editor
            unstable.emacs
          ];
        };

        programs = {
          autojump.enable = true;
          bat.enable      = true;
          vscode.enable   = true;

          # direnv = {
          #   enable = true;
          #   # enableNixDirenvIntegration = true;
          #   nix-direnv = {
          #     enable = true;
          #     enableFlakes = true;
          #   };
          # };

          # doom-emacs = {
          #   enable = true;
          #   doomPrivateDir = ./doom.d;
          # };

          fish = {
            enable = true;

            shellAbbrs = {
              "g"    = "git";
              "gs"   = "git status";
              "gpl"  = "git pull";
              "gph"  = "git push";
              "gco"  = "git checkout";
              "gcom" = "git checkout main";
              "gr"   = "git rebase";
              "grm"  = "git rebase main";
              "gasm" = "git add -A; git commit -m";

              "nic"  = "nix-shell --command";

              "en" = "emacs -nw";
              "1p" = "op";

              "darwin-flake-build" = darwin-flake-build;
              "darwin-flake-switch" = darwin-flake-switch;
              "darwin-flake-rebuild-switch" = "${darwin-flake-build} && ${darwin-flake-switch}";

              "sysinfo" = "nix-shell -p nix-info --run 'nix-info -m'";
              "doom" = "~/.emacs.d/bin/doom";
            };

            interactiveShellInit = ''
              set -U fish_user_paths /Users/expede/.nix-profile/bin $fish_user_paths
              set -U fish_user_paths /run/current-system/sw/bin $fish_user_paths
              set -U fish_user_paths /nix/var/nix/profiles/default/bin $fish_user_paths
              set -U fish_user_paths /opt/homebrew/bin $fish_user_paths

              # OpenSSL Compiler Headers
              set -gx LDFLAGS "-L/usr/local/opt/openssl@1.1/lib"
              set -gx CPPFLAGS "-I/usr/local/opt/openssl@1.1/include"
              set -gx PKG_CONFIG_PATH "/usr/local/opt/openssl@1.1/lib/pkgconfig"

              set -gx PATH $PATH ~/.local/bin
              set -gx NIX_PATH darwin-config=/Users/expede/.nixpkgs/darwin-configuration.nix:/nix/var/nix/profiles/per-user/root/channels:/Users/expede/.nix-defexpr/channels:/Users/expede/.nix-defexpr/channels

              # For mosh
              set -gx LANG     en_US.UTF-8
              set -gx LC_CTYPE en_US.UTF-8

              eval (ssh-agent -c) ; set -gx GPG_TTY (tty)
            '';
          };

          dircolors = {
            enable = true;
            enableFishIntegration = true;
          };

          starship = {
            enable = true;
            enableFishIntegration = true;

            settings = {
              character = {
                success_symbol = "[»](bold green) ";
                error_symbol   = "[✗](bold red) ";
              };

              directory = {
                fish_style_pwd_dir_length = 1;
                truncation_length         = 1;
              };

              hostname = {
                ssh_only = false;
                format = "[$hostname]($style):";
              };

              gcloud = {
                disabled = true;
              };

              username = {
                format = "[$user]($style)@";
              };
            };
          };

          gpg = {
            enable = true;
            settings = {
              default-key = "92A150B1496B3553";
            };
          };

          git = {
            enable    = true;
            userName  = "Brooklyn Zelenka";
            userEmail = "hello@brooklynzelenka.com";

            signing = {
              key           = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5RGNvxkIOd7lbaCUIe4m2fOZeO0tlTvJXzMZZdtBfo hello@brooklynzelenka.com";
              signByDefault = true;
            };

            ignores = [
              # Created by https://www.toptal.com/developers/gitignore/api/macos
              # Edit at https://www.toptal.com/developers/gitignore?templates=macos

              ### macOS ###
              # General
              ".DS_Store"
              ".AppleDouble"
              ".LSOverride"

              # Icon must end with two \r
              "Icon"

              # Thumbnails
              "._*I"

              # Files that might appear in the root of a volume
              ".DocumentRevisions-V100"
              ".fseventsd"
              ".Spotlight-V100"
              ".TemporaryItems"
              ".Trashes"
              ".VolumeIcon.icns"
              ".com.apple.timemachine.donotpresent"

              # Directories potentially created on remote AFP share
              ".AppleDB"
              ".AppleDesktop"
              "Network Trash Folder"
              "Temporary Items"
              ".apdisk"

              # End of https://www.toptal.com/developers/gitignore/api/macos
            ];

            extraConfig = {
              core.editor        = "vim";
              github.user        = "expede";
              init.defaultBranch = "main";
              pull.rebase        = true;
              commit.template    = "~/.config/gitmessage";

              gpg = {
                format = "ssh";
                ssh = {
                  program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
                  allowedSignersFile = "~/.ssh/allowed_signers";
                };
              };
            };
          };
        };

        services =
          if system == "x86_64-linux"
            then
              {
                emacs.enable = true;
                gpg-agent = {
                  enable           = true;
                  enableSshSupport = true;
                  pinentryFlavor   = "curses";

                  extraConfig = ''
                    pinentry-program ${pkgs.pinentry.curses}/bin/pinentry
                  '';
                };
              }
            else
              {};
      }
