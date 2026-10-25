{ lib, ... }:

let
  apps = {
    # Firefox first so it stays the default; Brave Origin as alternative.
    browser = [
      "firefox.desktop"
      "brave-origin.desktop"
    ];
    plaintext = [ "org.gnome.TextEditor.desktop" ];
    pdf = [ "org.gnome.Papers.desktop" ];
    ebook = [ "com.github.johnfactotum.Foliate.desktop" ];
    office = [ "writer.desktop" ];
  };

  # Only contested or unclaimed types. The rest have one candidate already.
  types = {
    # epiphany claims these, so links from outside a browser open in GNOME Web.
    browser = [
      "text/html"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/about"
      "x-scheme-handler/unknown"
    ];
    plaintext = [
      "text/plain"
      "text/markdown"
      "text/x-markdown"
      "application/json"
    ];
    pdf = [
      "application/pdf"
      "image/vnd.djvu"
    ];
    ebook = [
      "application/epub+zip"
      "application/x-mobipocket-ebook"
      "application/vnd.amazon.mobi8-ebook"
    ];
    office = [
      "application/vnd.oasis.opendocument.text"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "application/msword"
      "application/rtf"
      "text/rtf"
    ];
  };

  defaults = lib.concatMapAttrs (category: mimes: lib.genAttrs mimes (_: apps.${category})) types;

  # calibre claims every document format it can convert, so .docx would open
  # in the ebook editor. Removing them as candidates keeps them out of
  # "Open With". Epub, mobi, comics and djvu are left alone.
  calibreClaims =
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
      associations.removed = calibreClaims;
      defaultApplications = defaults // {
        # Registered by the applications; declared here because the file
        # below is force-managed and would drop them otherwise.
        "x-scheme-handler/sgnl" = [ "signal.desktop" ];
        "x-scheme-handler/signalcaptcha" = [ "signal.desktop" ];
        "x-scheme-handler/claude-cli" = [ "claude-code-url-handler.desktop" ];
        "x-scheme-handler/obsidian" = [ "obsidian.desktop" ];
        "x-scheme-handler/zotero" = [ "zotero.desktop" ];
      };
    };

    # GNOME and applications write mimeapps.list directly, so Home Manager
    # refuses to replace it unless forced. Two copies: the real file, and
    # the deprecated pre-spec location some applications still read.
    configFile."mimeapps.list".force = true;
    dataFile."applications/mimeapps.list".force = true;
  };
}
