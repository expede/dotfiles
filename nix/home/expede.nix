{ pkgs, unstable, homeDirectory, hostname, username, system, pure, ...}:
  let
    impure-flag = if pure then "" else "--impure";
    sys-flake-build = "env NIXPKGS_ALLOW_UNFREE=1 nix build ~/Documents/dotfiles/nix/darwin#darwinConfigurations.${hostname}.system ${impure-flag}";
    sys-flake-switch = "env NIXPKGS_ALLOW_UNFREE=1 ./result/sw/bin/darwin-rebuild switch --flake ~/Documents/dotfiles/nix/darwin ${impure-flag}";
  in
    {
      home = {
        inherit username;

        stateVersion = "22.11";

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
          # FIXME pkgs.pinentry_mac
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

          # Language support
          pkgs.agda
          pkgs.cargo
          pkgs.stack
          pkgs.wasm-bindgen-cli

          # Editors
          unstable.emacs
        ];
      };

      programs = {
        autojump.enable = true;
        bat.enable      = true;
        vscode.enable   = true;

        git  = import ./git.nix { inherit username; };
        fish = import ./fish.nix { inherit  sys-flake-build sys-flake-switch; };

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

            gcloud.disabled = true;
            username.format = "[$user]($style)@";
          };
        };

        gpg = {
          enable = true;
          settings.default-key = "92A150B1496B3553";
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
