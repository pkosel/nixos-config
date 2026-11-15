# Packages missing from nixpkgs or needing patches. Wired in by
# modules/system/nixpkgs.nix.
final: _prev: {
  mdcat = final.callPackage ../pkgs/mdcat.nix { };

  # Backport https://github.com/NixOS/nixpkgs/pull/580358 (dd12312).
  # Remove this package and overlay entry once the pinned nixpkgs has Riff.
  riff-client = final.callPackage ../pkgs/riff-client.nix { };
}
