{ lib, ... }:

let
  applicationGroups = {
    browser = {
      applications = [
        "firefox.desktop"
        "brave-origin.desktop"
      ];
      mimeTypes = [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ];
    };
    textEditor = {
      applications = [ "org.gnome.TextEditor.desktop" ];
      mimeTypes = [
        "text/plain"
        "text/markdown"
        "text/x-markdown"
        "application/json"
      ];
    };
    documentViewer = {
      applications = [ "org.gnome.Papers.desktop" ];
      mimeTypes = [
        "application/pdf"
        "image/vnd.djvu"
      ];
    };
    ebookReader = {
      applications = [ "com.github.johnfactotum.Foliate.desktop" ];
      mimeTypes = [
        "application/epub+zip"
        "application/x-mobipocket-ebook"
        "application/vnd.amazon.mobi8-ebook"
      ];
    };
    wordProcessor = {
      applications = [ "writer.desktop" ];
      mimeTypes = [
        "application/vnd.oasis.opendocument.text"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/msword"
        "application/rtf"
        "text/rtf"
      ];
    };
  };

  defaultApplications = lib.concatMapAttrs (
    _: group: lib.genAttrs group.mimeTypes (_: group.applications)
  ) applicationGroups;

  # Calibre's conversion inputs should not clutter "Open With" for ordinary
  # documents; keep its ebook associations.
  removedCalibreAssociations =
    lib.genAttrs
      [
        "application/pdf"
        "application/vnd.oasis.opendocument.text"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "text/html"
        "application/xhtml+xml"
        "text/plain"
        "text/rtf"
        "text/x-markdown"
      ]
      (_: [
        "calibre-ebook-edit.desktop"
        "calibre-ebook-viewer.desktop"
        "calibre-gui.desktop"
      ]);
in
{
  xdg = {
    mimeApps = {
      enable = true;
      associations.removed = removedCalibreAssociations;
      defaultApplications = defaultApplications // {
        "x-scheme-handler/sgnl" = [ "signal.desktop" ];
        "x-scheme-handler/signalcaptcha" = [ "signal.desktop" ];
        "x-scheme-handler/obsidian" = [ "obsidian.desktop" ];
        "x-scheme-handler/zotero" = [ "zotero.desktop" ];
      };
    };

    # Reclaim both Home Manager MIME files if applications replace them.
    # This discards MIME preferences changed outside this configuration.
    configFile."mimeapps.list".force = true;
    dataFile."applications/mimeapps.list".force = true;
  };
}
