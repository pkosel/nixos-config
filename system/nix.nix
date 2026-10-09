{ inputs, ... }:

{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      # Without this the collector only drops unreachable paths, and every
      # generation is a GC root — so nothing is ever actually freed.
      options = "--delete-older-than 30d";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # The claude-code input is not in nixpkgs, so without its own cache every
      # release is an npm build on this machine. Both lists merge with the
      # defaults the nix module appends, so cache.nixos.org stays.
      #
      # Set here rather than as the flake's nixConfig: that form is only honoured
      # for trusted-users, which is root alone, so it would be silently ignored.
      substituters = [ "https://claude-code.cachix.org" ];
      trusted-public-keys = [
        "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
      ];
    };

    # Resolve `nixpkgs` to the tree this system was built from, so ad-hoc
    # `nix shell nixpkgs#...` reuses the store instead of fetching its own.
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };
}
