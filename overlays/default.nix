# Packages that are not in nixpkgs, or that need patching. Wired in by
# system/nixpkgs.nix.
final: prev: {
  mdcat = final.callPackage ../pkgs/mdcat.nix { };

  # Fix crash on file dialogs (e.g. Import): anki's Qt6 GTK3 theme
  # integration needs a schema shipped by gtk3, which isn't part of
  # this GNOME session's (gtk4-based) XDG_DATA_DIRS. Drop it once nixpkgs'
  # anki wraps that schema itself.
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
