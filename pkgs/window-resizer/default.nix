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
    rev = "aa3134adc32e31fb5006be51eb833042dcde0fb0";
    sha256 = "sha256-5JP73QJyDDD7B2gRE1mcT4zi+2uCJZrM6kp1E+CJm7I=";
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
