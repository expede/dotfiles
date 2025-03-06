{
  description = "expede's Darwin Configuration";

  inputs = {
    nixpkgs.url       = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    unstable-pkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin.url                    = "github:lnl7/nix-darwin/nix-darwin-24.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url                    = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable-pkgs, darwin, home-manager, ...}:
    let
      system        = "aarch64-darwin";
      hostname      = "Latte";
      username      = "expede";
      homeDirectory = "/Users/${username}";

      pkgOpts = {
        inherit system;
        config.allowUnfree = true;
      };

      pkgs          = import nixpkgs       pkgOpts;
      unstable      = import unstable-pkgs pkgOpts;
      configuration = import ./config.nix  { inherit pkgs homeDirectory; };

    in {
      darwinConfigurations."${hostname}" = darwin.lib.darwinSystem {
        inherit system;

        modules = [
          configuration
          darwin.darwinModules.simple

          home-manager.darwinModules.home-manager {
            home-manager = {
              useGlobalPkgs   = true;
              useUserPackages = true;
              backupFileExtension = "backup";
            };

            home-manager.users."${username}" = import ../home/expede.nix {
              arch = import ./home.nix { inherit pkgs hostname; };

              inherit
                homeDirectory
                hostname
                pkgs
                system
                unstable
                username;
            };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."${hostname}".pkgs;
    };
}
