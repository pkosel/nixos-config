{ lib, ... }:

let
  apps = {
    browser = [ "firefox.desktop" ];
    plaintext = [ "org.gnome.TextEditor.desktop" ];
    pdf = [ "org.gnome.Papers.desktop" ];
    ebook = [ "com.github.johnfactotum.Foliate.desktop" ];
    office = [ "writer.desktop" ];
  };

  # Only contested or unclaimed types are listed. Images, video, audio,
  # archives and directories have one candidate each and already resolve to it.
  types = {
    # GNOME ships epiphany and claims these, so links opened from outside a
    # browser (terminal, mail, desktop files) landed in GNOME Web.
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

  # calibre's three desktop files claim every document format it can convert,
  # which is how .docx ended up opening in the ebook *editor*. Removing them as
  # candidates keeps them out of "Open With" too, not just off the default.
  # Left alone: epub, mobi, comics and djvu, where calibre is a real answer.
  calibre =
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
  xdg.mimeApps = {
    enable = true;
    associations.removed = calibre;
    defaultApplications = defaults // {
      # Registered by the applications themselves; declared here because the
      # file below is force-managed and would otherwise drop them.
      "x-scheme-handler/sgnl" = [ "signal.desktop" ];
      "x-scheme-handler/signalcaptcha" = [ "signal.desktop" ];
      "x-scheme-handler/claude-cli" = [ "claude-code-url-handler.desktop" ];
      "x-scheme-handler/obsidian" = [ "obsidian.desktop" ];
      "x-scheme-handler/zotero" = [ "zotero.desktop" ];
    };
  };

  # GNOME and the applications above write mimeapps.list directly, so Home
  # Manager refuses to replace it unless told to. It maintains two copies: the
  # real one, and the deprecated pre-spec location that some applications still
  # read. Both need forcing, or activation aborts on whichever is unmanaged.
  xdg.configFile."mimeapps.list".force = true;
  xdg.dataFile."applications/mimeapps.list".force = true;
}
