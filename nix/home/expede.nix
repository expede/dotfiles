{
  arch,
  homeDirectory,
  hostname,
  pkgs,
  system,
  unstable,
  username,
  ...
}: {
  home = {
    inherit username;

    stateVersion = "22.11";

    packages = [
      pkgs.cachix
      pkgs.coreutils
      pkgs.fastly
      pkgs.fd
      pkgs.ffmpeg
      pkgs.graphviz
      pkgs.mosh
      pkgs.nodejs
      pkgs.opensc
      pkgs.pandoc
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
    ] ++ arch.packages;
  };

  programs = {
    autojump.enable = true;
    bat.enable      = true;
    vscode.enable   = true;

    git  = import ./git.nix { inherit username; };
    fish = import ./fish.nix {
      flake-rebuild-switch = arch.flake-rebuild-switch;
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

        gcloud.disabled = true;
        username.format = "[$user]($style)@";
      };
    };
  } // arch.programs;

  services = arch.services;
}
