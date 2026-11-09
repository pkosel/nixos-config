{ pkgs, ... }:

{
  # Leave the theme and color scheme to GNOME's appearance switch. Its dark
  # default is set in modules/system/desktop/gnome.nix.
  gtk = {
    enable = true;
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
  };
}
