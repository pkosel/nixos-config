# Packages missing from nixpkgs or needing patches. Wired in by
# modules/nixos/nixpkgs.nix.
final: _: {
  mdcat = final.callPackage ../pkgs/mdcat.nix { };
}
