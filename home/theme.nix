# Theme names for the tools that load a theme by name, in one place so a scheme
# change is one edit. Light and dark are picked from the system setting: Ghostty
# follows it and bat asks the terminal. fzf, eza and mdcat use ANSI colour names
# instead, which Ghostty maps to its active theme, so they follow it too.
# pi's copies of the scheme are home/cli/pi/nightowl*.json.
{
  # bat's themes are built from home/cli/bat/*.tmTheme; Ghostty's ship with the
  # ghostty package. delta reads bat's dark theme.
  bat = {
    dark = "nightowl";
    light = "nightowl-light";
  };
  ghostty = {
    dark = "Night Owl";
    light = "Light Owl";
  };
}
