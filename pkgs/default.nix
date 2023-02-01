{pkgs ? import <nixpkgs> {}}: {
  # TODO: remove when https://github.com/NixOS/nixpkgs/pull/210180 is merged
  eduvpn-client = pkgs.python3Packages.toPythonApplication (pkgs.python3Packages.callPackage ./eduvpn-client {});
  morewaita-icon-theme = pkgs.callPackage ./morewaita-icon-theme {};
}
