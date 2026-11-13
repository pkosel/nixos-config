{
  lib,
  stdenv,
  alsa-lib,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  fetchFromGitHub,
  fetchurl,
  gettext,
  glib,
  gtk4,
  jre_headless,
  libadwaita,
  libpulseaudio,
  meson,
  ninja,
  openssl,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
}:

let
  # Upstream pins this generator; newer versions emit dependencies that do not
  # match Cargo.lock (for example, reqwest 0.13).
  openapi-generator-jar = fetchurl {
    url = "mirror://maven/org/openapitools/openapi-generator-cli/7.12.0/openapi-generator-cli-7.12.0.jar";
    hash = "sha256-M+ffp6HwTVhAXuEq4Z4sb8KpFJfPLlb6aPGHWpXL8iA=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "riff-client";
  version = "26.10";

  src = fetchFromGitHub {
    owner = "Diegovsky";
    repo = "riff";
    # Release tags are sequential numbers; the version comes from meson.build.
    tag = "v14";
    hash = "sha256-KxFnQ6wnnnOQlu1IwAI7NGRvFJGqepFCE1D6BzpjjHQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-C+AFi8d0AlLB4kbUJz/7/fEDP1pVTRxBWsbHhRH/lP8=";
  };

  postPatch = ''
    patchShebangs scripts/api/generate-spotify-api.sh

    substituteInPlace src/meson.build --replace-fail \
      "cargo_output = 'src' / rust_target / meson.project_name()" \
      "cargo_output = 'src' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()"
  '';

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils
    gettext
    glib # for glib-compile-schemas
    gtk4 # for gtk-update-icon-cache
    jre_headless # for generating the Spotify API crate
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    alsa-lib
    glib
    gtk4
    libadwaita
    libpulseaudio
    openssl
  ];

  strictDeps = true;
  __structuredAttrs = true;

  mesonBuildType = "release";

  env = {
    # Meson invokes cargo directly, so match its output path to the patch above.
    CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;
    OPENAPI_GENERATOR_JAR = openapi-generator-jar;
  };

  meta = {
    description = "Native Spotify client for the GNOME desktop, forked from Spot";
    longDescription = ''
      Riff is a GTK4/libadwaita Spotify client and the maintained fork of
      Spot. It requires a Spotify Premium account.
    '';
    homepage = "https://github.com/Diegovsky/riff";
    changelog = "https://github.com/Diegovsky/riff/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "riff";
    platforms = lib.platforms.linux;
  };
})
