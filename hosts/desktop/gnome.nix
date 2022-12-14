{ config, pkgs, ... }:

{
  # Enable X11 windowing system
  services.xserver.enable = true;

  # Keymap in X11
  services.xserver.layout = "eu";

  # Enable Gnome3
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
}
