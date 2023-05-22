{ username, gpg, signing-key }:
  {
    enable    = true;
    userName  = "Brooklyn Zelenka";
    userEmail = "hello@brooklynzelenka.com";

    signing = {
      key           = signing-key;
      signByDefault = true;
    };

    extraConfig = {
      inherit gpg;

      core.editor        = "vim";
      github.user        = username;
      init.defaultBranch = "main";
      pull.rebase        = true;
      commit.template    = "./git/gitmessage";
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
  }
