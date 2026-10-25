# Theme names for the tools that load a theme by name, kept in one place so a
# scheme change is one edit. Ghostty and bat follow the system light/dark
# setting. fzf, eza and mdcat use ANSI colour names, which Ghostty maps to its
# active theme. pi's copies of the scheme are modules/home-manager/cli/pi/nightowl*.json.
{
  # bat's themes are built from modules/home-manager/cli/bat/*.tmTheme; Ghostty's ship with the
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
