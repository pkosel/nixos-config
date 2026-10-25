# Brave Origin is not in nixpkgs. Reuse the Brave builder and override
# only what differs. Drop once nixpkgs ships brave-origin.
{
  stdenv,
  callPackage,
  nixpkgsPath,
  xdg-utils,
}:

let
  version = "1.97.59";

  # make-brave.nix: callPackage gives build deps, then archive args
  # select the release.
  brave = (callPackage "${nixpkgsPath}/pkgs/by-name/br/brave/make-brave.nix" { }) {
    pname = "brave-origin";
    inherit version;
    url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-origin_${version}_amd64.deb";
    hash = "sha256-og+VPXoSMwv2t/6v8FdEy4P8/R/b97Yh453sNod1soc=";
  };
in
brave.overrideAttrs (old: {
  installPhase = ''
    runHook preInstall

    mkdir -p $out $out/bin

    cp -R usr/share $out
    cp -R opt/ $out/opt

    export BINARYWRAPPER=$out/opt/brave.com/brave-origin/brave-origin

    substituteInPlace $BINARYWRAPPER \
      --replace-fail /bin/bash ${stdenv.shell} \
      --replace-fail 'CHROME_WRAPPER' 'WRAPPER'

    ln -sf $BINARYWRAPPER $out/bin/brave-origin

    for exe in $out/opt/brave.com/brave-origin/{brave,chrome_crashpad_handler}; do
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $exe
    done

    substituteInPlace $out/share/applications/{brave-origin,com.brave.Origin}.desktop \
      --replace-fail /usr/bin/brave-origin-stable $out/bin/brave-origin
    # Point GNOME's default-app entry at the wrapped binary.
    # Only $out/bin carries the library path from fixup.
    substituteInPlace $out/share/gnome-control-center/default-apps/brave-origin.xml \
      --replace-fail /opt/brave.com/brave-origin/brave-origin $out/bin/brave-origin
    substituteInPlace $out/opt/brave.com/brave-origin/default-app-block \
      --replace-fail /opt/brave.com/brave-origin/brave-origin $out/bin/brave-origin

    icon_sizes=("16" "24" "32" "48" "64" "128" "256")

    for icon in ''${icon_sizes[*]}; do
      mkdir -p $out/share/icons/hicolor/''${icon}x''${icon}/apps
      ln -s $out/opt/brave.com/brave-origin/product_logo_$icon.png \
        $out/share/icons/hicolor/''${icon}x''${icon}/apps/brave-origin.png
    done

    ln -sf ${xdg-utils}/bin/xdg-settings $out/opt/brave.com/brave-origin/xdg-settings
    ln -sf ${xdg-utils}/bin/xdg-mime $out/opt/brave.com/brave-origin/xdg-mime

    runHook postInstall
  '';

  # The wrapper is created in fixup, after install checks.
  # Checking the unwrapped binary here would need the full rpath.
  doInstallCheck = false;

  passthru = { };

  meta = old.meta // {
    description = "Minimal privacy-oriented browser from Brave";
    mainProgram = "brave-origin";
    platforms = [ "x86_64-linux" ];
  };
})
