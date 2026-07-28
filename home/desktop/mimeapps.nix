{ ... }:

let
  firefox = [ "firefox.desktop" ];
in
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # GNOME ships epiphany and claims these by default, so links opened from
      # outside a browser (terminal, mail, desktop files) landed in GNOME Web.
      "text/html" = firefox;
      "x-scheme-handler/http" = firefox;
      "x-scheme-handler/https" = firefox;
      "x-scheme-handler/about" = firefox;
      "x-scheme-handler/unknown" = firefox;

      # Registered by the applications themselves; declared here because the
      # file below is force-managed and would otherwise drop them.
      "x-scheme-handler/sgnl" = [ "signal.desktop" ];
      "x-scheme-handler/signalcaptcha" = [ "signal.desktop" ];
      "x-scheme-handler/claude-cli" = [ "claude-code-url-handler.desktop" ];
    };
  };

  # GNOME and the applications above write mimeapps.list directly, so Home
  # Manager refuses to replace it unless told to. It maintains two copies: the
  # real one, and the deprecated pre-spec location that some applications still
  # read. Both need forcing, or activation aborts on whichever is unmanaged.
  xdg.configFile."mimeapps.list".force = true;
  xdg.dataFile."applications/mimeapps.list".force = true;
}
