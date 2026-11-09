{ inputs, ... }:

{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      # Without this, the collector only drops unreachable paths, and every
      # generation is a GC root, so nothing is ever freed.
      options = "--delete-older-than 30d";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Resolve `nixpkgs` to the tree this system was built from, so ad-hoc
    # `nix shell nixpkgs#...` reuses the store instead of fetching its own.
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };
}
