{ lib, stdenvNoCC, fetchFromGitHub, gtk3, xdg-utils, }:
stdenvNoCC.mkDerivation rec {
  pname = "morewaita-icon-theme";
  version = "43.3";

  src = fetchFromGitHub {
    owner = "somepaulo";
    repo = "MoreWaita";
    rev = "59bfc8ce20afa7c9030406d0c5e3f532c66bd766";
    sha256 = "sha256-9UAuJAK7UXDJkWZ1BGX2zC08Iy5Sk+YbvtR8vIuyhlc=";
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
