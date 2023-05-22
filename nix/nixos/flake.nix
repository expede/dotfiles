{
  description = "expede's NixOS Configuration";

  inputs = {
    nixpkgs.url       = "github:nixos/nixpkgs";
    unstable-pkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url                    = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable-pkgs, home-manager, ...}:
    let
      system        = pkgs.stdenv.system;

      hostname      = "mocha";
      username      = "expede";

      homeDirectory = "/Users/${username}";

      configuration =
        config: import ./config.nix {
          lib = nixpkgs.outputs.lib;
          inherit pkgs config hostname;
        };

      pkgs     = import nixpkgs       { config.allowUnfree = true; };
      unstable = import unstable-pkgs {};

    in {
      nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          configuration

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs   = true;
            home-manager.useUserPackages = true;

            home-manager.users."${username}" = import ../home/expede.nix;
            home-manager.extraSpecialArgs = {
              pure = false;

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
      nixosPackages = self.nixosConfigurations."${hostname}".pkgs;
    };
}
