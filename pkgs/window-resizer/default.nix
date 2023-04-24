{ lib
, stdenv
# , fetchFromGitHub
# , gnome
# , gettext
# , glib
, unzip
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-window-resizer";
  version = "1";

  src = ./.;
  #fetchFromGitHub {
  #owner = "pkosel";
  #repo = "window-resizer";
  #rev = "";
  #sha256 = "";
  #};

  passthru = {
    extensionUuid = "window-resizer@pkosel.github.com";
    extensionPortalSlug = "window-resizer";
  };

  nativeBuildInputs = [ unzip ];

  # buildPhase = ''
  #   runHook preBuild
  #   glib-compile-schemas --strict --targetdir=schemas schemas
  #   runHook postBuild
  # '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/gnome-shell/extensions/window-resizer@pkosel.github.com"
    unzip -o "archive.zip" -d "$out/share/gnome-shell/extensions/window-resizer@pkosel.github.com"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Programmatic window resizing for GNOME Shell";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pkosel ];
    homepage = "https://github.com/pkosel/window-resizer";
  };
}
