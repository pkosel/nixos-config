{ lib, stdenvNoCC, fetchFromGitHub, gtk3, xdg-utils, }:
stdenvNoCC.mkDerivation rec {
  pname = "morewaita-icon-theme";
  version = "44.1";

  src = fetchFromGitHub {
    owner = "somepaulo";
    repo = "MoreWaita";
    rev = "6acecb2761e3e97b9c9592e05f96ef824c8d0789";
    sha256 = "3HYMnu+halkbrFagaKFmDFctcF0yjsPalD8IBkYeVLA=";
  };

  nativeBuildInputs = [ gtk3 xdg-utils ];

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
