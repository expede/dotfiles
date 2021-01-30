{ config, pkgs, ... }:


let
  unstable = import
    (builtins.fetchTarball {
      url = https://github.com/NixOS/nixpkgs/tarball/495066a47fc259aa4fc5f7548e190fded2c7030e;
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
    nixpkgs.config.allowUnfree = true;

    home = {
      packages = [ 
        pkgs.bind
        pkgs.coreutils
        pkgs.direnv
        pkgs.dotfiles
        pkgs.fd
        # pkgs.lzma
        pkgs.libpqxx
        pkgs.mosh
        pkgs.niv
        pkgs.pinentry_mac
        #pkgs.pkg-config
        pkgs.ripgrep
        pkgs.transmission
        pkgs.unison-ucm
        pkgs.wget

        # Process
        pkgs.htop
        pkgs.lsof

        # FS
        pkgs.ripgrep
        pkgs.tree

        # Data
        unstable.ipfs
        pkgs.jq

        # BEAM
        pkgs.elixir

        # Haskell
        pkgs.ghc
        pkgs.ghcid
        unstable.haskell-language-server
        pkgs.stylish-haskell

        pkgs.haskellPackages.ghcide
        pkgs.haskellPackages.hoogle
        pkgs.haskellPackages.lzma

        # Editor
        doom-emacs
        pkgs.emacs-all-the-icons-fonts 
      ];

      file.".emacs.d/init.el".text = ''
        (load "default.el")
      '';
    };

    programs = {
      autojump.enable = true;
      bat.enable      = true;
      vscode.enable   = true;
      
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
          "gasm" = "git add -A; git commit -m";

          "please" = "sudo";

          "regpg" = "gpg-connect-agent reloadagent /bye";

          "remotenix" = "mosh --ssh='/usr/bin/ssh' expede@64.227.105.246";
        };

        promptInit = ''
         set -U fish_user_paths /Users/expede/.nix-profile/bin $fish_user_paths
         set -U fish_user_paths /run/current-system/sw/bin $fish_user_paths
         set -U fish_user_paths /nix/var/nix/profiles/default/bin $fish_user_paths

         # OpenSSL Compiler Headers
         set -gx LDFLAGS "-L/usr/local/opt/openssl@1.1/lib"
         set -gx CPPFLAGS "-I/usr/local/opt/openssl@1.1/include"
         set -gx PKG_CONFIG_PATH "/usr/local/opt/openssl@1.1/lib/pkgconfig"

         set -gx PATH $PATH ~/.local/bin 
         set -gx NIX_PATH darwin-config=/Users/expede/.nixpkgs/darwin-configuration.nix:/nix/var/nix/profiles/per-user/root/channels:/Users/expede/.nix-defexpr/channels:/Users/expede/.nix-defexpr/channels

         set -gx HOMEBREW_CELLAR /usr/local/Cellar

         eval (ssh-agent -c) ; set -gx GPG_TTY (tty)
         direnv hook fish | source
        '';
      };

      dircolors = {
        enable = true;
        enableFishIntegration = true;
      };

      starship = {
        enable = true;
        enableFishIntegration = true;

        settings = {
          character = {
            success_symbol = "[»](bold green) ";
            error_symbol   = "[✗](bold red) ";
          };

          directory = {
            fish_style_pwd_dir_length = 1;
            truncation_length         = 1;
          };

          hostname = {
            ssh_only = false;
            format = "[$hostname]($style):";
          };

          gcloud = {
            disabled = true;
	        };

	        username = {
	          format = "[$user]($style)@";
	        };
        };
      };

      gpg = {
        enable = true;
        settings = {
          default-key = "92A150B1496B3553";
        };
      };

      git = {
        enable    = true;
        userName  = "Brooklyn Zelenka";
        userEmail = "hello@brooklynzelenka.com";
 
        signing = {
          key           = "92A150B1496B3553";
          signByDefault = true;
        };

        extraConfig = {
          github.user        = "expede";
          init.defaultBranch = "main";
          pull.rebase        = true;
        };
      };
    };

    services = 
      if pkgs.stdenv.isLinux 
        then 
          {
            gpg-agent = {
              enable           = true;
              enableSshSupport = true;
              pinentryFlavor   = "curses";

              extraConfig = ''
                pinentry-program ${pkgs.pinentry.curses}/bin/pinentry
              '';
            };
          }
        else 
          {};
  }
