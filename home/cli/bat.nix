{ theme, ... }:

{
  programs.bat = {
    enable = true;
    config.theme = theme.bat;

    # No Night Owl ships with bat. The module rebuilds bat's cache for this, and
    # delta reads the same cache, so both pick it up.
    themes.${theme.bat}.src = ./bat/nightowl.tmTheme;
  };
}
