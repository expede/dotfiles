{ config, pkgs, ... }:

let
  unstable = import
    (builtins.fetchTarball {
      url = https://github.com/nixos/nixpkgs/tarball/e6d81a9b89e8dd8761654edf9dc744660a6bef0a;
    }) {};

  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url = https://github.com/vlaci/nix-doom-emacs/archive/master.tar.gz;
  }) {
    # Directory containing your config.el, init.el & packages.el files
    doomPrivateDir = ./doom.d; 
  };

in 
  {
    home = {
      packages = [ 
        pkgs.bind
        pkgs.direnv
        pkgs.dotfiles
        pkgs.jump
        pkgs.niv

        # Process
        pkgs.htop
        pkgs.lsof
        pkgs.killall

        # FS
        pkgs.ripgrep
        pkgs.tree

        # Data
        pkgs.ipfs
        pkgs.jq

        # Haskell
        pkgs.ghc
        pkgs.ghcid
        pkgs.stack
        pkgs.stylish-haskell

        pkgs.haskellPackages.ghcide
        pkgs.haskellPackages.hoogle

        # Editor
        doom-emacs
      ];

      file.".emacs.d/init.el".text = ''
        (load "default.el")
      '';
    };

    programs = {
      bat.enable          = true;
      # gpg.enable          = true;
      home-manager.enable = true; 

      fish = {
        enable = true;
        shellAbbrs = {
          "g"    = "git";
          "gpl"  = "git pull";
          "gph"  = "git push";
          "gco"  = "git checkout";
          "gcom" = "git checkout master";
          "gr"   = "git rebase";
          "grm"  = "git rebase master";
        };

        promptInit = ''
          eval (ssh-agent -c)
        '';
      };

      git = {
        enable    = true;
        userName  = "Brooklyn Zelenka";
        userEmail = "hello@brooklynzelenka.com";
 
        #  signing = {
        #    key           = "AE90F6D924874634";
        #    signByDefault = true;
        #  };
      };
    };

    services = {
      lorri.enable = true;
    };
  }
