{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages =
    with pkgs;
    with gnomeExtensions;
    [
      dconf-editor
      gnome-tweaks
    ];

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude some default applications
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    evince
    gnome-photos
    gnome-tour
    cheese
    geary
    gnome-calendar
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-weather
    totem
    yelp
  ];
}
