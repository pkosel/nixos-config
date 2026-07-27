{
  lib,
  curl,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  asciidoctor,
  openssl,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdcat";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "BIRSAx2";
    repo = "mdcat";
    rev = "mdcat-${version}";
    hash = "sha256-k/KrwLboBpTIwWUPsxlIGYiHef6K+gEJdFXdQDR/TpM=";
  };

  nativeBuildInputs = [
    pkg-config
    asciidoctor
    installShellFiles
  ];
  buildInputs = [
    curl
    openssl
  ];

  cargoHash = "sha256-73YfmEkZe7ykNXyxuTzTpQ7EESbiMYuuAbhv/6PaZUQ=";

  postInstall = ''
    asciidoctor -b manpage -a reproducible mdcat.1.adoc
    installManPage mdcat.1
    ln -sr $out/bin/{mdcat,mdless}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for bin in mdcat mdless; do
      installShellCompletion --cmd $bin \
        --bash <($out/bin/$bin --completions bash) \
        --fish <($out/bin/$bin --completions fish) \
        --zsh <($out/bin/$bin --completions zsh)
    done
  '';

  meta = {
    description = "cat for markdown: Show markdown documents in terminals (BIRSAx2 fork)";
    homepage = "https://github.com/BIRSAx2/mdcat";
    changelog = "https://github.com/BIRSAx2/mdcat/releases/tag/mdcat-${version}";
    license = with lib.licenses; [
      mpl20
      asl20
    ];
    mainProgram = "mdcat";
  };
}
