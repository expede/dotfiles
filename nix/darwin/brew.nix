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
    "homebrew/cask"
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
    "brave-browser"
    "discord"
    "docker"
    "firefox-developer-edition"
    "github"
    "google-chrome"
    "iterm2"
    "loom"
    "mactex"
    "missive"
    "nordvpn"
    "obsidian"
    "steam"
  ];
}
