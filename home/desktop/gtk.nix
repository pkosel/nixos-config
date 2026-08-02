{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
    theme.name = "Adwaita-dark";
    # The theme name only reaches GTK3; libadwaita apps read the colour-scheme
    # dconf key instead. That key is deliberately not set here: gtk3.colorScheme
    # is what writes it, and anything Home Manager writes it also rewrites on
    # every activation, so switching to light in GNOME Settings would revert at
    # the next rebuild. system/desktop/gnome.nix supplies it as a default
    # instead, which leaves the switch working.
    colorScheme = "dark";
    gtk3.colorScheme = null;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    # 26.05 defaults this to null; pinned so gtk4 keeps following gtk3 rather
    # than changing because home.stateVersion says 25.11.
    gtk4.theme = config.gtk.theme;
  };
}
