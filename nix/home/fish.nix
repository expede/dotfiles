{sys-flake-build, sys-flake-switch}:
  {
    enable = true;

    shellAbbrs = {
      "g"    = "git";
      "gs"   = "git status";
      "gpl"  = "git pull";
      "gph"  = "git push";
      "gco"  = "git checkout";
      "gcom" = "git checkout main";
      "gr"   = "git rebase";
      "grm"  = "git rebase main";
      "gasm" = "git add -A; git commit -m";

      "en" = "emacs -nw";
      "1p" = "op";

      "sys-flake-build"          = sys-flake-build;
      "sys-flake-switch"         = sys-flake-switch;
      "sys-flake-rebuild-switch" = "${sys-flake-build} && ${sys-flake-switch}";

      "sysinfo" = "nix-shell -p nix-info --run 'nix-info -m'";
      "doom"    = "~/.emacs.d/bin/doom";
    };

    interactiveShellInit = ''
      set -U fish_user_paths /Users/expede/.nix-profile/bin $fish_user_paths
      set -U fish_user_paths /run/current-system/sw/bin $fish_user_paths
      set -U fish_user_paths /nix/var/nix/profiles/default/bin $fish_user_paths
      set -U fish_user_paths /opt/homebrew/bin $fish_user_paths

      # OpenSSL Compiler Headers
      set -gx LDFLAGS "-L/usr/local/opt/openssl@1.1/lib"
      set -gx CPPFLAGS "-I/usr/local/opt/openssl@1.1/include"
      set -gx PKG_CONFIG_PATH "/usr/local/opt/openssl@1.1/lib/pkgconfig"

      set -gx PATH $PATH ~/.local/bin
      set -gx NIX_PATH darwin-config=/Users/expede/.nixpkgs/darwin-configuration.nix:/nix/var/nix/profiles/per-user/root/channels:/Users/expede/.nix-defexpr/channels:/Users/expede/.nix-defexpr/channels

      # For mosh
      set -gx LANG     en_US.UTF-8
      set -gx LC_CTYPE en_US.UTF-8

      eval (ssh-agent -c) ; set -gx GPG_TTY (tty)
    '';
  };
