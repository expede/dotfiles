{
  description = "expede's NixOS Configuration";

  inputs = {
    nixpkgs.url       = "github:nixos/nixpkgs/nixos-25.11";
    unstable-pkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url                    = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable-pkgs, home-manager, ...}:
    let
      system        = "x86_64-linux";
      hostname      = "mocha";
      username      = "expede";
      homeDirectory = "/home/${username}";

      pkgOpts = {
        inherit system;
        config = {
          allowUnfree = true;
          packageOverrides = pkgs: {
            vaapiIntel = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
          };
        };
      };

      pkgs     = import nixpkgs       pkgOpts;
      unstable = import unstable-pkgs pkgOpts;

      configuration =
        (config: import ./config.nix {
          lib = nixpkgs.outputs.lib;
          inherit pkgs config hostname;
        });

    in {
      nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          configuration

          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs       = true;
              useUserPackages     = true;
              users."${username}" = import ../home/expede.nix;
              extraSpecialArgs    = {
                arch = import ./home.nix { inherit pkgs; };

                inherit
                  homeDirectory
                  hostname
                  pkgs
                  system
                  unstable
                  username;
              };
            };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      nixosPackages = self.nixosConfigurations."${hostname}".pkgs;
    };
}
