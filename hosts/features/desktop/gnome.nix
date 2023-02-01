{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs;
  with gnomeExtensions; [
    gnome.dconf-editor
    gnome.gnome-tweaks
  ];

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude some default applications
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    evince
    gnome-photos
    gnome-tour
    gnome.cheese
    gnome.geary
    gnome.gnome-calendar
    gnome.gnome-contacts
    gnome.gnome-maps
    gnome.gnome-music
    gnome.gnome-weather
    gnome.totem
    gnome.yelp
  ];
}
