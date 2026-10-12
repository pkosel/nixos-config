# Packages that are missing from nixpkgs or need patching. system/nixpkgs.nix
# wires them in.
final: prev: {
  mdcat = final.callPackage ../pkgs/mdcat.nix { };

  # Without this, anki's file dialogs crash. Its Qt6 GTK3 theme integration needs
  # a schema shipped by gtk3, which is not in this GNOME session's (gtk4-based)
  # XDG_DATA_DIRS. Drop this once nixpkgs' anki wraps that schema itself.
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
