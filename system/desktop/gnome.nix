{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dconf-editor
    gnome-tweaks
  ];

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # An override supplies the schema *default*, so the Appearance switch in GNOME
  # Settings still works and its choice sticks — a value written through
  # home-manager's dconf.settings would be reimposed on the next activation.
  # The cost is that dark only applies where no value has been set by hand.
  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.desktop.interface]
    color-scheme='prefer-dark'
  '';

  # Stock applications that are installed but unused. epiphany is the one that
  # mattered: it claimed the http/https and text/html handlers, which is how
  # links opened from outside a browser ended up in GNOME Web.
  # Kept on purpose: yelp, which is what F1 opens in every GNOME app, and
  # gnome-tour, which only ever runs on first login.
  # This list only removes what the GNOME module itself installs — naming
  # anything else is a silent no-op, which is how the previous version came to
  # list evince, totem, cheese, geary and gnome-photos. GNOME 50 had already
  # replaced them with papers, showtime, snapshot and loupe.
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-calendar
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-weather
  ];
}
