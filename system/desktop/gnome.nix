{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dconf-editor
    gnome-tweaks
  ];

  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;

      # The override sets the schema default, so the Appearance switch in GNOME
      # Settings still works and its choice sticks. A value written through
      # home-manager's dconf.settings would be reapplied on every activation. The
      # cost is that dark only applies where no value has been set by hand.
      extraGSettingsOverrides = ''
        [org.gnome.desktop.interface]
        color-scheme='prefer-dark'
      '';
    };
  };

  # epiphany claims the http/https and text/html handlers, so links opened from
  # outside a browser would end up in GNOME Web. yelp (opened by F1 in every
  # GNOME app) and gnome-tour (first login only) are kept on purpose. This list
  # only removes what the GNOME module installs; naming anything else is a
  # silent no-op.
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-calendar
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-weather
  ];
}
