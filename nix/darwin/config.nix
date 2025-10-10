{ pkgs, homeDirectory, ... }: {
  homebrew = import ./brew.nix    {};
  nix      = import ../config.nix { inherit pkgs; };

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
    primaryUser = "expede";
    defaults = {
      dock = {
        autohide    = true;
        orientation = "bottom";
      };
    };
  };
}
