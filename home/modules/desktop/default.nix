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
  ];
}
