{username}:
  {
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
      github.user        = username;
      init.defaultBranch = "main";
      pull.rebase        = true;
      commit.template    = "../../git/gitmessage";

      gpg = {
        format = "ssh";
        ssh    = {
          program            = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          allowedSignersFile = "~/.ssh/allowed_signers";
        };
      };
    };
  }
