{ pkgs ? import <nixpkgs> { } }: {
  morewaita-icon-theme = pkgs.callPackage ./morewaita-icon-theme { };
  gdrive-client = pkgs.callPackage ./gdrive-client { };
}
