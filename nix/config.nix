{ pkgs, ... }: {
  nix = {
    package = pkgs.nixVersions.stable;

    optimise.automatic = true;

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

      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}
