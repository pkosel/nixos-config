{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
    theme.name = "Adwaita-dark";
    # The theme name only reaches GTK3. libadwaita apps read the colour-scheme
    # dconf key instead, set as a default in modules/nixos/desktop/gnome.nix so the
    # GNOME Settings switch still works.
    colorScheme = "dark";
    gtk3.colorScheme = null;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    # Explicit since 26.05. Drop once stateVersion ≥ 26.05 and gtk4 no longer
    # needs to follow gtk3.
    gtk4.theme = config.gtk.theme;
  };
}
