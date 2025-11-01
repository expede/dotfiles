{
  description = "expede's Darwin Configuration";

  inputs = {
    nixpkgs.url       = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    unstable-pkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin.url                    = "github:lnl7/nix-darwin/nix-darwin-25.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url                    = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    zjstatus-flake.url = "github:dj95/zjstatus";
  };

  outputs = { self, nixpkgs, unstable-pkgs, darwin, home-manager, zjstatus-flake, ...}@inputs:
    let
      system        = "aarch64-darwin";
      hostname      = "Latte";
      username      = "expede";
      homeDirectory = "/Users/${username}";

      inherit (inputs.nixpkgs.lib) attrValues;
      overlays = with inputs; [
        # ...
        (final: prev: {
          zjstatus = zjstatus-flake.packages.${prev.system}.default;
        })
      ];

      pkgOpts = {
        inherit system overlays;
        config.allowUnfree = true;
      };

      pkgs          = import nixpkgs       pkgOpts;
      unstable      = import unstable-pkgs pkgOpts;
      configuration = import ./config.nix  { inherit pkgs homeDirectory; };

    in {
      darwinConfigurations."${hostname}" = darwin.lib.darwinSystem {
        inherit system;

        # primaryUser = username;

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
