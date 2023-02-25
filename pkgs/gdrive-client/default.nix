{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "gdrive";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "glotlabs";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-JcaFpmJLSmOaoZWwxRMEGKXpWYd0+1ES8cwCVh4wJyA=";
  };

  cargoSha256 = "sha256-NqgPwpFSGiEUpQQkR6ujWMjOjePCTVY1X5kSuYrrTEM=";

  meta = with lib; {
    description = "Google Drive CLI Client";
    homepage = "https://github.com/glotlabs/gdrive";
    license = licenses.mit;
    maintainers = with maintainers; [ pkosel ];
  };
}
