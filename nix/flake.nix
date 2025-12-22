{
  description = "expede's NixOS & Darwin Configuration";

  inputs = {
    nixpkgs.url       = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    unstable-pkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin.url                    = "github:lnl7/nix-darwin/nix-darwin-25.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

    home-manager.url                    = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    claude-code-flake.url = "github:sadjow/claude-code-nix";
    zjstatus-flake.url    = "github:dj95/zjstatus";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-darwin,
    unstable-pkgs,
    darwin,
    home-manager,
    claude-code-flake,
    zen-browser,
    zjstatus-flake,
    ...
  }@inputs:
    let
      mkSystem = { system, hostname, username, homeDirectory, isDarwin ? false }:
        let
          overlays = with inputs; [
            claude-code-flake.overlays.default
            (final: prev: {
              zjstatus = zjstatus-flake.packages.${prev.system}.default;
            })
          ];

          unstable = import unstable-pkgs {
            inherit system;
            config.allowUnfree = true;
          };

          homeManagerModule = if isDarwin
            then home-manager.darwinModules.home-manager
            else home-manager.nixosModules.home-manager;

          systemBuilder = if isDarwin
            then darwin.lib.darwinSystem
            else nixpkgs.lib.nixosSystem;

          systemConfig = if isDarwin
            then ./darwin/config.nix
            else ./nixos/config.nix;

          nixpkgsConfig = {
            nixpkgs = {
              inherit overlays;
              config = {
                allowUnfree = true;
              } // (if isDarwin then {} else {
                packageOverrides = pkgs: {
                  vaapiIntel = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
                };
              });
            };
          };

          homeManagerConfig = {
            home-manager = {
              useGlobalPkgs   = true;
              useUserPackages = true;
              backupFileExtension = "backup";

              users."${username}" = import ./modules/home;

              extraSpecialArgs = {
                inherit
                  homeDirectory
                  hostname
                  system
                  unstable
                  username;
              };
            };
          };

        in systemBuilder {
          inherit system;

          specialArgs = {
            inherit
              homeDirectory
              hostname;
          };

          modules = [
            nixpkgsConfig
            systemConfig
            homeManagerModule
            homeManagerConfig
          ];
        };

    in {
      darwinConfigurations."Latte" = mkSystem {
        system        = "aarch64-darwin";
        hostname      = "Latte";
        username      = "expede";
        homeDirectory = "/Users/expede";
        isDarwin      = true;
      };

      nixosConfigurations."mocha" = mkSystem {
        system        = "x86_64-linux";
        hostname      = "mocha";
        username      = "expede";
        homeDirectory = "/home/expede";
        isDarwin      = false;
      };
    };
}
