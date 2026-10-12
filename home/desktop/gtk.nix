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
    # dconf key instead. It is deliberately not set here: gtk3.colorScheme writes
    # it, and Home Manager rewrites anything it writes on every activation, which
    # would revert a switch to light in GNOME Settings at the next rebuild.
    # system/desktop/gnome.nix sets it as a default instead, so the switch works.
    colorScheme = "dark";
    gtk3.colorScheme = null;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    # The default is null from home.stateVersion 26.05, and gtk3's theme before.
    # Setting it explicitly keeps gtk4 following gtk3 and silences the deprecation
    # warning. Drop it once stateVersion is 26.05 or later and gtk4 no longer needs
    # to follow gtk3.
    gtk4.theme = config.gtk.theme;
  };
}
