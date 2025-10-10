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
    "brave-browser"
    "discord"
    "ungoogled-chromium"
    "firefox@developer-edition"
    "ghostty"
    "iterm2"
    "loom"
    "mactex"
    "texstudio"
    "monodraw"
    "obs"
    "proton-mail"
    "proton-mail-bridge"
    "protonvpn"
    "steam"
    "zed"
    "zen"
  ];
}
