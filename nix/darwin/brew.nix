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

  taps = [
    "homebrew/cask-drivers"
    "homebrew/cask-versions"
    "homebrew/services"
  ];

  brews = [
    "graphviz"
  ];

  casks = [
    "1password"
    "1password-cli"
    "arc"
    "discord"
    "firefox-developer-edition"
    "github"
    "iterm2"
    "loom"
    "mactex"
    "missive"
    "monodraw"
    "nordvpn"
    "obsidian"
    "rescuetime"
    "steam"
  ];
}
