# Darwin-specific nix configuration
{ ... }: {
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
