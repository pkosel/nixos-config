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

      # The override sets a schema default, so the GNOME Settings switch
      # still works. dconf.settings would reapply on every activation.
      extraGSettingsOverrides = ''
        [org.gnome.desktop.interface]
        color-scheme='prefer-dark'
      '';
    };
  };

  # epiphany claims http/https handlers, so links from outside a browser
  # would open in GNOME Web. yelp and gnome-tour are kept on purpose.
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-calendar
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-weather
  ];
}
