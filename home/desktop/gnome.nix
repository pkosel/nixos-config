{ pkgs, ... }:

{
  home.packages = with pkgs; [
    morewaita-icon-theme
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.tiling-shell
  ];

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "blur-my-shell@aunetx"
        "dash-to-dock@micxgx.gmail.com"
        "tilingshell@ferrarodomenico.com"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "code.desktop"
        "kitty.desktop"
        "obsidian.desktop"
        "zotero.desktop"
        "signal.desktop"
      ];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [
        "Utilities"
        "LibreOffice"
        "Calibre"
      ];
    };
    "org/gnome/desktop/app-folders/folders/Utilities" = {
      name = "Utilities";
      translate = true;
      apps = [
        "org.gnome.Characters.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.baobab.desktop"
        "org.gnome.DiskUtility.desktop"
        "org.gnome.Extensions.desktop"
        "org.gnome.font-viewer.desktop"
        "htop.desktop"
        "org.gnome.Logs.desktop"
        "cups.desktop"
        "org.gnome.seahorse.Application.desktop"
        "org.gnome.SystemMonitor.desktop"
        "org.gnome.tweaks.desktop"
        "vim.desktop"
        "xterm.desktop"
        "ca.desrt.dconf-editor.desktop"
      ];
    };
    "org/gnome/desktop/app-folders/folders/LibreOffice" = {
      name = "LibreOffice";
      translate = true;
      apps = [
        "startcenter.desktop"
        "writer.desktop"
        "calc.desktop"
        "impress.desktop"
        "draw.desktop"
        "base.desktop"
        "math.desktop"
      ];
    };
    "org/gnome/desktop/app-folders/folders/Calibre" = {
      name = "Calibre";
      translate = true;
      apps = [
        "calibre-gui.desktop"
        "calibre-ebook-edit.desktop"
        "calibre-ebook-viewer.desktop"
        "calibre-lrfviewer.desktop"
      ];
    };
  };
}
