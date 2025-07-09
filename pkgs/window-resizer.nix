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
    rev = "91e08c7cc9261e369ad1c210c26211756e1ea8a7";
    sha256 = "sha256-7RuE5G2JLvG0K4rsAxgqP9ttAIqwLF+lQ8YGFDXNA0U=";
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
