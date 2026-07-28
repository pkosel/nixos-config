{ pkgs, ... }:

{
  environment.systemPackages =
    with pkgs;
    with gnomeExtensions;
    [
      dconf-editor
      gnome-tweaks
    ];

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Exclude some default applications
  # environment.gnome.excludePackages = with pkgs; [
  #   epiphany
  #   evince
  #   gnome-photos
  #   gnome-tour
  #   cheese
  #   geary
  #   gnome-calendar
  #   gnome-contacts
  #   gnome-maps
  #   gnome-music
  #   gnome-weather
  #   totem
  #   yelp
  # ];
}
