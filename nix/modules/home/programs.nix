{ config, pkgs, lib, username, ... }:

let
  # Platform-specific values
  gpgConfig = if pkgs.stdenv.isDarwin then {
    gpg = {
      format = "ssh";
      ssh = {
        program            = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        allowedSignersFile = "~/.ssh/allowed_signers";
      };
    };
  } else {
    gpg = {
      format = "ssh";
      ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };
    commit.gpgsign = true;
    user.signingkey = "~/.ssh/id_ed25519.pub";
  };

  signingKey = if pkgs.stdenv.isDarwin
    then "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5RGNvxkIOd7lbaCUIe4m2fOZeO0tlTvJXzMZZdtBfo hello@brooklynzelenka.com"
    else "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5QDR5zYVvboJ+SJ5sIBVaRPwOrBv9P/AR6Kj5XBPqO hello@brooklynzelenka.com";

in {
  programs = {
    autojump.enable = true;
    bat.enable      = true;

    atuin = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;

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

    git = {
      enable = true;

      signing = {
        key           = signingKey;
        signByDefault = true;
      };

      settings = gpgConfig // {
        user = {
          name  = "Brooklyn Zelenka";
          email = "hello@brooklynzelenka.com";
        };

        commit.template      = "${../../../git/gitmessage}";
        core.editor          = "vim";
        github.user          = username;
        init.defaultBranch   = "main";
        pull.rebase          = true;
        push.autoSetupRemote = true;
        rerere.enabled       = true;
      };

      ignores = [
        # macOS
        ".DS_Store"
        ".AppleDouble"
        ".LSOverride"
        "Icon"
        "._*I"
        ".DocumentRevisions-V100"
        ".fseventsd"
        ".Spotlight-V100"
        ".TemporaryItems"
        ".Trashes"
        ".VolumeIcon.icns"
        ".com.apple.timemachine.donotpresent"
        ".AppleDB"
        ".AppleDesktop"
        "Network Trash Folder"
        "Temporary Items"
        ".apdisk"

        # AI
        ".claude"

        # Nix
        "result"

        # Jujutsu
        ".jj"
      ];
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    dircolors = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  # Ghostty configuration (not using programs.ghostty as it's marked broken)
  home.file."Library/Application Support/com.mitchellh.ghostty/config" = lib.mkIf pkgs.stdenv.isDarwin {
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
    '';
  };
}
