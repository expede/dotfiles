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
    "github"
    "iterm2"
    "loom"
    "mactex"
    "texstudio"
    "missive"
    "monodraw"
    "nordvpn"
    "obs"
    "obsidian"
    "rescuetime"
    "steam"
  ];
}
