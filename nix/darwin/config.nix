{ pkgs, homeDirectory, ... }: {
  homebrew = import ./brew.nix    {};
  nix      = import ../config.nix { inherit pkgs; };

  services.nix-daemon.enable = true;
  environment.systemPackages =
    [ pkgs.vim
      pkgs.fish
      pkgs.home-manager
    ];

  programs.zsh.enable  = true; # Default shell on Catalina
  programs.fish.enable = true;

  users.users.expede = {
    home  = homeDirectory;
    shell = pkgs.fish;
  };

  system = {
    defaults = {
      dock = {
        autohide    = true;
        orientation = "bottom";
      };
    };
  };
}
