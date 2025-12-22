{ pkgs, homeDirectory, hostname, ... }: {
  imports =
    [ ../config.nix
    ];

  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  homebrew = import ./brew.nix {};

  environment.systemPackages =
    [ pkgs.vim
      pkgs.fish
      pkgs.home-manager
    ];

  # programs.zsh.enable  = true; # Default shell on Catalina
  programs.fish.enable = true;

  # As of 25.05, Nix expects this to be 350 by default
  ids.gids.nixbld = 30000;

  users.users.expede = {
    home  = homeDirectory;
    shell = pkgs.fish;
  };

  system = {
    stateVersion = 6;
    primaryUser = "expede";
    defaults = {
      dock = {
        autohide    = true;
        orientation = "bottom";
      };
    };
  };
}
