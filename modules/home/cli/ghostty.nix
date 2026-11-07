{ ... }:

{
  programs.ghostty = {
    enable = true;
    # Keep the title bar tied to GNOME rather than the terminal color scheme.
    settings.window-theme = "system";
  };
}
