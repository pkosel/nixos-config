{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Leave the theme and color scheme to GNOME's appearance switch. Its dark
  # default is set in modules/system/gnome.nix.
  gtk = {
    enable = true;
    # Home Manager writes the whole bookmarks file, replacing Files' defaults.
    gtk3.bookmarks = lib.mkBefore [
      "file://${config.xdg.userDirs.documents}"
      "file://${config.xdg.userDirs.music}"
      "file://${config.xdg.userDirs.pictures}"
      "file://${config.xdg.userDirs.videos}"
      "file://${config.xdg.userDirs.download}"
    ];
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
  };
}
