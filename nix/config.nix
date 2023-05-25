{ pkgs, ... }: {
  package      = pkgs.nixVersions.stable;
  gc.automatic = true;

  settings = {
    trusted-users = ["root" "@wheel"];

    trusted-substituters = [
      "https://cache.iog.io"
      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      "cache.iog.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
  };

  extraOptions = ''
    extra-platforms             = x86_64-darwin aarch64-darwin
    extra-experimental-features = nix-command flakes repl-flake
  '';
}
