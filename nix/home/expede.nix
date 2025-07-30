{
  arch,
  homeDirectory,
  hostname,
  pkgs,
  system,
  unstable,
  username,
  ...
}:
  let
    homeOverrides = if arch ? home then arch.home else {};
    stc = "#252033"; # starship text colour
  in {
  home = {
    inherit username;

    stateVersion = "23.11";

    packages = [
      pkgs.cachix
      pkgs.coreutils
      pkgs.fd
      pkgs.font-awesome
      pkgs.ispell
      # pkgs.lazyjj
      pkgs.mosh
      # pkgs.nodejs
      pkgs.speedtest-cli
      pkgs.tokei
      pkgs.wget
      unstable.copilot-language-server
      unstable.radicle-node

      # Process
      pkgs.btop
      pkgs.lsof

      # FS
      pkgs.ripgrep
      pkgs.tree

      # Editors
      (pkgs.emacs.override { withNativeCompilation = false; })
    ] ++ arch.packages;
  } // homeOverrides;

  programs = {
    autojump.enable = true;
    bat.enable      = true;

    atuin = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;

      settings = {
        enter_accept = true;
        inline_height = 40;
        theme.name = "marine";
      };
    };

    kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;
    };

    git  = import ./git.nix {
      inherit username;

      gpg         = arch.gpg;
      signing-key = arch.signing-key;
    };

    # jujutsu = {
    #   enable = true;
    #   settings = {
    #     user = {
    #       email = "hello@brooklynzelenka.com";
    #       name = "Brooklyn Zelenka";
    #     };

    #     ui.editor = "vim";
    #     ui.diff-editor = "vimdiff";

    #     signing = {
    #       behavior = "own";
    #       backend = "ssh";

    #       key = arch.signing-key;
    #       sign-all = true;

    #       backends.ssh = {
    #         program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    #       };
    #     };
    #   };
    # };

    fish = import ./fish.nix {
	    flake-rebuild-switch = arch.flake-rebuild-switch;
    };

    nushell = {
	    enable = true;
	    extraConfig = ''
		    let carapace_completer = {|spans|
			    carapace $spans.0 nushell $spans | from json
		    }
	    $env.config = {
show_banner: false,
	     completions: {
case_sensitive: false # case-sensitive completions
			quick: true    # set to false to prevent auto-selecting completions
			partial: true    # set to false to prevent partial filling of the prompt
			algorithm: "fuzzy"    # prefix or fuzzy
			external: {
# set to false to prevent nushell looking into $env.PATH to find more suggestions
enable: true 
# set to lower can improve completion performance at the cost of omitting some options
		max_results: 100 
		completer: $carapace_completer # check 'carapace_completer' 
			}
	     }
        } 
        $env.PATH = ($env.PATH | 
          split row (char esep) |
          prepend /home/myuser/.apps |
          append /usr/bin/env
        )
      '';

      shellAliases = {
        gb = "git branch";
        gs = "git status";
        gco = "git checkout";
        gcom = "git checkout main";
        grm = "git checkout main";

        flake-rebuild-switch = "{${arch.flake-rebuild-switch}}";
        en = "emacs -nw" ;
      };
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    dircolors = {
      enable = true;
      enableFishIntegration = true;
    };

    starship = {
      enable = true;

      enableFishIntegration = true;
      enableZshIntegration  = true;

      settings = {
        character = {
          success_symbol = "[»](bold green) ";
          error_symbol   = "[✗](bold red) ";
        };

        hostname = {
          ssh_only = false;
          style = "bg:#9A348E ${stc}";
          format = "[on $hostname ]($style)";
        };

        gcloud.disabled = true;

        format = "[](#9A348E)$os$username$hostname$sudo[](bg:#DA627D fg:#9A348E)$directory[](fg:#DA627D bg:#FCA17D)$git_branch$git_status[](fg:#FCA17D bg:#FDFD96)$nix_shell[](fg:#FDFD96 bg:#86BBD8)$cr$elm$golang$gradle$haskell$java$julia$nodejs$nim$rust$scala[](fg:#86BBD8 bg:#06969A)$docker_context[](fg:#06969A bg:#33658A)$time[ ](fg:#33658A)";

        # Disable the blank line at the start of the prompt
        # add_newline = false

        # You can also replace your username with a neat symbol like   or disable this
        # and use the os module below
         username = {
           show_always = true;
           style_user = "bg:#9A348E ${stc}";
           style_root = "bg:#9A348E ${stc}";
           format = "[$user ]($style)";
           disabled = false;
         };

        sudo = {
          style = "bg:#9A348E ${stc}";
          symbol = "🦸‍♀️ ";
          format = "[as $symbol]($style)";
          disabled = false;
        };

       # An alternative to the username module which displays a symbol that
       # represents the current operating system
        os = {
          format = "[$symbol]($style)";
          style = "bg:#9A348E ${stc}";
          disabled = false; # Disabled by default

          symbols = {
            Alpaquita = "🔔 ";
            Alpine = "🏔️ ";
            Amazon = "🙂 ";
            Android = "🤖 ";
            Arch = "🎗️ ";
            Artix = "🎗️ ";
            CentOS = "💠 ";
            Debian = "🌀 ";
            DragonFly = "🐉 ";
            Emscripten = "🔗 ";
            EndeavourOS = "🚀 ";
            Fedora = "🎩 ";
            FreeBSD = "😈 ";
            Garuda = "🦅 ";
            Gentoo = "🗜️ ";
            HardenedBSD = "🛡️ ";
            Illumos = "🐦 ";
            Linux = "🐧 ";
            Mabox = "📦 ";
            Macos = "🍎 ";
            Manjaro = "🥭 ";
            Mariner = "🌊 ";
            MidnightBSD = "🌘 ";
            Mint = "🌿 ";
            NetBSD = "🚩 ";
            NixOS = "❄️ ";
            OpenBSD = "🐡 ";
            OpenCloudOS = "☁️ ";
            openEuler = "🦉 ";
            openSUSE = "🦎 ";
            OracleLinux = "🦴 ";
            Pop = "🍭 ";
            Raspbian = "🍓 ";
            Redhat = "🎩 ";
            RedHatEnterprise = "🎩 ";
            Redox = "🧪 ";
            Solus = "⛵ ";
            SUSE = "🦎 ";
            Ubuntu = "🎯 ";
            Unknown = "❓ ";
            Windows = "🪟 ";
          };
        };

        directory = {
          style = "bg:#DA627D ${stc}";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
        };

        # Here is how you can shorten some long paths by text replacement
        # similar to mapped_locations in Oh My Posh:
        directory.substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
          # Keep in mind that the order matters. For example:
          # "Important Documents" = " 󰈙 "
          # will not be replaced, because "Documents" was already substituted before.
          # So either put "Important Documents" before "Documents" or use the substituted version:
          # "Important 󰈙 " = " 󰈙 "
        };

        c = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        docker_context = {
          symbol = " ";
          style = "bg:#06969A ${stc}";
          format = "[ $symbol $context ]($style) $path";
        };

        elixir = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        elm = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        git_branch = {
          symbol = "";
          style = "bg:#FCA17D ${stc}";
          format = "[ $symbol $branch ]($style)";
        };

        git_status = {
          style = "bg:#FCA17D ${stc}";
          format = "[$all_status$ahead_behind ]($style)";
        };

        golang = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        gradle = {
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        haskell = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        java = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        julia = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        nodejs = {
          symbol = "";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        nim = {
          symbol = "󰆥 ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        rust = {
          symbol = "";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        scala = {
          symbol = " ";
          style = "bg:#86BBD8 ${stc}";
          format = "[ $symbol ($version) ]($style)";
        };

        nix_shell = {
          format = "[ $symbol$state( \($name\)) ]($style)";
          style = "bg:#fdfd96 ${stc}";
          symbol = "❄️ ";
          impure_msg = "impure";
          pure_msg = "pure";
          unknown_msg = "unknown if pure";
          disabled = false;
        };

        time = {
          disabled = false;
          time_format = "%R"; # Hour:Minute Format
          style = "bg:#33658A ${stc}";
          format = "[ 🕐 $time ]($style)";
        };
      };
    };
  } // arch.programs;

  services = arch.services;
}
