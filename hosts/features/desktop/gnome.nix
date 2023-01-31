{
  config,
  pkgs,
  ...
}: {
  services.xserver.enable = true;

  services.xserver.layout = "eu";

  # environment.systemPackages = with pkgs;
  #   with gnomeExtensions; [
  #     gnome.dconf-editor
  #     gnome.gnome-tweaks
  #   ];

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
}
