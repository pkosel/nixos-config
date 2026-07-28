{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./gnome.nix
    ./gtk.nix
    ./mimeapps.nix
  ];
}
