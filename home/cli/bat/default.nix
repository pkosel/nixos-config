{ theme, ... }:

{
  programs.bat = {
    enable = true;
    # bat asks the terminal for its background and picks the matching theme.
    # Ghostty answers with the colours of the current system setting, so the
    # highlighting follows GNOME's dark/light switch.
    config = {
      theme = "auto";
      theme-dark = theme.bat.dark;
      theme-light = theme.bat.light;
    };

    # Neither theme ships with bat. The module rebuilds bat's cache for these,
    # and delta reads the same cache.
    themes = {
      ${theme.bat.dark}.src = ./nightowl.tmTheme;
      ${theme.bat.light}.src = ./nightowl-light.tmTheme;
    };
  };
}
