{ pkgs, ... }:

{
  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.blur-my-shell; }
      { package = pkgs.gnomeExtensions.dash-to-dock; }
      { package = pkgs.gnomeExtensions.tiling-shell; }
    ];
  };

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "brave-origin.desktop"
        "code.desktop"
        "com.mitchellh.ghostty.desktop"
        "todoist.desktop"
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
      apps = [
        "org.gnome.Characters.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.baobab.desktop"
        "org.gnome.DiskUtility.desktop"
        "org.gnome.Extensions.desktop"
        "org.gnome.font-viewer.desktop"
        "btop.desktop"
        "org.gnome.Logs.desktop"
        "cups.desktop"
        "org.gnome.seahorse.Application.desktop"
        "org.gnome.SystemMonitor.desktop"
        "org.gnome.tweaks.desktop"
        "vim.desktop"
        "ca.desrt.dconf-editor.desktop"
      ];
    };
    "org/gnome/desktop/app-folders/folders/LibreOffice" = {
      name = "LibreOffice";
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
      apps = [
        "calibre-gui.desktop"
        "calibre-ebook-edit.desktop"
        "calibre-ebook-viewer.desktop"
        "calibre-lrfviewer.desktop"
      ];
    };
  };
}
