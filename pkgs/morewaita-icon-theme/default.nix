{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  xdg-utils,
}:
stdenvNoCC.mkDerivation rec {
  pname = "morewaita-icon-theme";
  version = "43.2";

  src = fetchFromGitHub {
    owner = "somepaulo";
    repo = "MoreWaita";
    rev = "v${version}";
    sha256 = "sha256-efeZEysuWdE1+ws3njFlhWjAjavRlMuIuSL2VT25lUk=";
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
    license = with licenses; [gpl3];
    platforms = platforms.linux;
    maintainers = with maintainers; [pkosel];
  };
}
