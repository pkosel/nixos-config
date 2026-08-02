{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
    theme.name = "Adwaita-dark";
    # The theme name only reaches GTK3. libadwaita apps (nautilus, papers,
    # loupe, text editor) ignore it and read the colour-scheme dconf key, which
    # was set by hand and declared nowhere — so dark did not survive a reset.
    # This one option covers all three: the GTK3 setting, the GTK4 one, and the
    # dconf key.
    colorScheme = "dark";
    # 26.05 defaults this to null; pinned so gtk4 keeps following gtk3 rather
    # than changing because home.stateVersion says 25.11.
    gtk4.theme = config.gtk.theme;
  };
}
