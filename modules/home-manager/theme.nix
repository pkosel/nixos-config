# Ghostty and bat follow the system light/dark setting. Ghostty maps the ANSI
# colours used by fzf, eza and mdcat to its active theme.
{
  # bat themes come from cli/bat/*.tmTheme; Ghostty themes ship with the package.
  # delta uses bat's dark theme; pi has separate copies in cli/pi/nightowl*.json.
  bat = {
    dark = "nightowl";
    light = "nightowl-light";
  };
  ghostty = {
    dark = "Night Owl";
    light = "Light Owl";
  };
}
