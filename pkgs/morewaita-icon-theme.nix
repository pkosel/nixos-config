{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  xdg-utils,
}:

stdenvNoCC.mkDerivation rec {
  pname = "morewaita-icon-theme";
  version = "48.3.1";

  src = fetchFromGitHub {
    owner = "somepaulo";
    repo = "MoreWaita";
    rev = "v${version}";
    sha256 = "sha256-Gi73Cn/FwI055Inodo8huHeaWGTy9IR3qPMbjAHBsPw=";
  };

  nativeBuildInputs = [
    gtk3
    xdg-utils
  ];

  installPhase = ''
    install -d $out/share/icons/MoreWaita
    rm -rf ./.git
    cp -r . $out/share/icons/MoreWaita
    gtk-update-icon-cache -f -t $out/share/icons/MoreWaita && xdg-desktop-menu forceupdate
  '';

  meta = with lib; {
    description = "An Adwaita style extra icons theme for Gnome Shell.";
    homepage = "https://github.com/somepaulo/MoreWaita";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ pkosel ];
  };
}
