{
  description = "expede's Darwin Configuration";

  inputs = {
    nixpkgs.url       = "github:nixos/nixpkgs";
    unstable-pkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin.url                    = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url                    = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable-pkgs, darwin, home-manager, ...}:
    let
      system        = pkgs.stdenv.system;
      homeDirectory = "/Users/expede";
      hostname      = "Latte";

      pkgs          = import nixpkgs       {};
      unstable      = import unstable-pkgs {};
      configuration = import ./config.nix  { inherit pkgs homeDirectory; };

    in {
      darwinConfigurations."${hostname}" = darwin.lib.darwinSystem {
        inherit system;

        modules = [
          configuration
          darwin.darwinModules.simple

          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs   = true;
            home-manager.useUserPackages = true;

            home-manager.users.expede = import ../home/expede.nix {
              inherit
                pkgs
                unstable
                system
                homeDirectory
                hostname;

              pure = false;
            };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."${hostname}".pkgs;
    };
}
