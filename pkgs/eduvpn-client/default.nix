{ lib
, buildPythonPackage
, dbus-python
, fetchFromGitHub
, gdk-pixbuf
, gobject-introspection
, gtk3
, libnotify
, networkmanager
, pygobject3
, pytest-runner
, pynacl
, pytest
, pycodestyle
, requests_oauthlib
, setuptools
, wrapGAppsHook
,
}:
buildPythonPackage rec {
  pname = "eduvpn-client";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "eduvpn";
    repo = "python-${pname}";
    rev = version;
    hash = "sha256-dCVCXCPw0PCE0d6KPmuhv/V4WVQS+ucQbWoR0Lx5TDk=";
  };

  dontWrapGApps = true;

  nativeBuildInputs =
    [ gdk-pixbuf gobject-introspection pytest-runner wrapGAppsHook ];

  buildInputs = [ gtk3 libnotify networkmanager ];

  propagatedBuildInputs =
    [ dbus-python pygobject3 pynacl requests_oauthlib setuptools ];

  postPatch = ''
    substituteInPlace eduvpn/utils.py \
      --replace "/usr/local" "$out"
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}");
  '';

  checkInputs = [ pytest pycodestyle ];

  meta = with lib; {
    homepage = "https://eduvpn.org";
    description = "Linux client and Python client API for eduVPN";
    longDescription = ''
      This is the GNU/Linux desktop client for eduVPN. It also is a Python client API.
    '';
    changelog =
      "https://raw.githubusercontent.com/eduvpn/python-eduvpn-client/${version}/CHANGES.md";
    mainProgram = "eduvpn-gui";
    license = licenses.gpl3;
    maintainers = with maintainers; [ kilianar ];
    platforms = platforms.linux;
  };
}
