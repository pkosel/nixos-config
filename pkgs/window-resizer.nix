{
  lib,
  stdenv,
  fetchFromGitHub,
  gnome,
  gettext,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-window-resizer";
  version = "1";

  src = fetchFromGitHub {
    owner = "pkosel";
    repo = "window-resizer";
    rev = "5ba4a575dce6cbaf4f1335e0d79eb93f5afd669c";
    sha256 = "sha256-k8QhPZxQfHGikrTWHpnSkg2sFqALIfVxL7SDI15w0NY=";
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
