{ config, pkgs, lib, unstable, ... }:

{
  home.packages = [
    pkgs.cachix
    pkgs.coreutils
    pkgs.fastfetch
    pkgs.fd
    pkgs.font-awesome
    pkgs.inkscape-with-extensions
    pkgs.ispell
    pkgs.mosh
    pkgs.speedtest-cli
    pkgs.tokei
    pkgs.wget

    # AI
    unstable.copilot-language-server
    unstable.claude-code

    # Process
    pkgs.btop
    pkgs.lsof

    # FS
    pkgs.ripgrep
    pkgs.tree

    # Editors
    (pkgs.emacs.override { withNativeCompilation = false; })
  ];
}
