{ pkgs, ... }: {
  package      = pkgs.nixVersions.stable;
  gc = {
    automatic = true;
    options   = "--delete-older-than 30d";
    interval  = {
      Weekday = 0;
      Hour    = 0;
      Minute  = 0;
    };
  };

  settings = {
    auto-optimise-store = true;
    
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
