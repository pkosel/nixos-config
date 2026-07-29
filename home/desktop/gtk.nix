{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
    theme.name = "Adwaita-dark";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    # 26.05 defaults this to null; pinned so gtk4 keeps following gtk3 rather
    # than changing because home.stateVersion says 25.11.
    gtk4.theme = config.gtk.theme;
  };
}
