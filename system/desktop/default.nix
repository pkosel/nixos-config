{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./gnome.nix
    ./x11.nix
    ./wayland.nix
  ];
}
