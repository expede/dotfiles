{...}: {
  enable     = true;
  brewPrefix = "/opt/homebrew/bin";

  global = {
    brewfile  = true;
    lockfiles = false;
  };

  onActivation = {
    autoUpdate = true;
    cleanup    = "zap";
    upgrade    = true;
  };

  brews = [
    "graphviz"
  ];

  casks = [
    "1password"
    "1password-cli"
    "arc"
    "discord"
    "eloston-chromium"
    "firefox@developer-edition"
    "ghostty"
    "github"
    "iterm2"
    "loom"
    "mactex"
    "texstudio"
    "monodraw"
    "nordvpn"
    "obs"
    "proton-mail"
    "proton-mail-bridge"
    "steam"
    "zed"
  ];
}
