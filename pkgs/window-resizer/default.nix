{ lib
, stdenv
, fetchFromGitHub
, gnome
, gettext
, glib
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-window-resizer";
  version = "1";

  src = fetchFromGitHub {
    owner = "pkosel";
    repo = "window-resizer";
    rev = "f0f94c828270a96999b12b8cf4a0d9b363df3606";
    sha256 = "sha256-iiK8L06DA0ACJOWaYM+VctDyRTVQF9SnVPuXuKJAXdk=";
  };

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict --targetdir=schemas schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/gnome-shell/extensions/window-resizer@pkosel.github.com"
    cp -r * "$out/share/gnome-shell/extensions/window-resizer@pkosel.github.com/"
    runHook postInstall
  '';

  passthru = {
    extensionUuid = "window-resizer@pkosel.github.com";
    extensionPortalSlug = "window-resizer";
  };

  meta = with lib; {
    description = "Programmatic window resizing for GNOME Shell";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pkosel ];
    homepage = "https://github.com/pkosel/window-resizer";
  };
}
