{ config, pkgs, ... }:

let
  unstable = import
    (builtins.fetchTarball {
      # url = https://github.com/nixos/nixpkgs/tarball/c59ea8b8a0e7f927e7291c14ea6cd1bd3a16ff38;
      url = https://github.com/nixos/nixpkgs/tarball/84d74ae9c9cbed73274b8e4e00be14688ffc93fe;
    }) {
      config.allowBroken = true;
    };

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
        pkgs.pinentry
        pkgs.pinentry-curses
        pkgs.screen
        pkgs.tmux
        pkgs.wget

        # Process
        pkgs.htop
        pkgs.lsof
        pkgs.killall

        # FS
        pkgs.ripgrep
        pkgs.tree

        # Data
        unstable.ipfs
        pkgs.jq

        # BEAM
        pkgs.elixir_1_9

        # Haskell
        pkgs.ghc
        pkgs.ghcid
        pkgs.stack
        pkgs.stylish-haskell

        pkgs.haskellPackages.ghcide
        pkgs.haskellPackages.hoogle
        unstable.haskellPackages.summoner-tui

        # Editor
        doom-emacs
        pkgs.emacs-all-the-icons-fonts 
      ];

      file.".emacs.d/init.el".text = ''
        (load "default.el")
      '';
    };

    programs = {
      bat.enable          = true;
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

          "regpg" = "gpg-connect-agent reloadagent /bye";
        };

        promptInit = ''
          set -gx PATH $PATH ~/.local/bin
          eval (ssh-agent -c) ; set -gx GPG_TTY (tty)
        '';
      };

      git = {
        enable    = true;
        userName  = "Brooklyn Zelenka";
        userEmail = "hello@brooklynzelenka.com";
 
        signing = {
          key           = "6E1E0F15E47C02D7";
          signByDefault = true;
        };
      };

      gpg = {
        enable = true;
        settings = {
          default-key = "6E1E0F15E47C02D7";
        };
      };
    };

    services = {
      lorri.enable = true;

      gpg-agent = {
        enable           = true;
        # defaultCacheTtl  = 36000;
        enableSshSupport = true;
        pinentryFlavor   = "curses";

        # extraConfig = ''
        #  pinentry-program ${pkgs.pinentry.curses}/bin/pinentry
        # '';
      };
    };
  }
