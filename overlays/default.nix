# Packages missing from nixpkgs or needing patches. Wired in by
# modules/nixos/nixpkgs.nix.
final: prev: {
  mdcat = final.callPackage ../pkgs/mdcat.nix { };

  brave-origin = final.callPackage ../pkgs/brave-origin.nix {
    nixpkgsPath = final.path;
  };

  # Anki's Qt6 GTK3 integration needs a gtk3 schema not in this GNOME
  # session's (gtk4-based) XDG_DATA_DIRS. Drop once nixpkgs wraps it.
  anki = prev.symlinkJoin {
    name = "anki-${prev.anki.version}";
    paths = [ prev.anki ];
    nativeBuildInputs = [ prev.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/anki \
        --prefix XDG_DATA_DIRS : ${prev.gtk3}/share/gsettings-schemas/${prev.gtk3.name}
    '';
  };
}
