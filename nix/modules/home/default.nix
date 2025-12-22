{ config, pkgs, lib, username, homeDirectory, hostname, system, unstable, ... }:

let
  isDarwin = lib.hasInfix "darwin" system;
  isLinux = lib.hasInfix "linux" system;
in
{
  imports = [
    ./packages.nix
    ./programs.nix
    ./shell.nix
    ./zellij.nix
  ] ++ lib.optionals isDarwin [
    ./darwin.nix
  ] ++ lib.optionals isLinux [
    ./linux.nix
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "23.11";
  };
}
