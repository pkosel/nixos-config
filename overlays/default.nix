# Packages missing from nixpkgs or needing patches. Wired in by
# modules/system/nixpkgs.nix.
final: prev: {
  mdcat = final.callPackage ../pkgs/mdcat.nix { };

  # Backport https://github.com/NixOS/nixpkgs/pull/580358 (dd12312).
  # Remove this package and overlay entry once the pinned nixpkgs has Riff.
  riff-client = final.callPackage ../pkgs/riff-client.nix { };

  # The pinned builder targets the obsolete @vscode/ripgrep path. Remove
  # this override once it includes upstream's ripgrep-universal handling.
  # https://github.com/NixOS/nixpkgs/commit/08a2d5fff737305a13c39a47a49cf8590567220d
  vscode = prev.vscode.overrideAttrs (
    old:
    let
      ripgrepPath = "@vscode/ripgrep-universal/bin/linux-x64/rg";
    in
    {
      postPatch = final.lib.replaceStrings [ "@vscode/ripgrep/bin/rg" ] [ ripgrepPath ] old.postPatch + ''
        # Search also resolves the helper through the unpacked ASAR tree.
        rm resources/app/node_modules.asar.unpacked/${ripgrepPath}
        ln -s ${final.ripgrep}/bin/rg resources/app/node_modules.asar.unpacked/${ripgrepPath}
      '';
    }
  );
}
