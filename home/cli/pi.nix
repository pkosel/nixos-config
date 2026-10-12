{ ... }:

{
  # pi finds themes in ~/.pi/agent/themes. Selecting one is "theme" in
  # ~/.pi/agent/settings.json, which stays unmanaged because pi rewrites that
  # file itself (changelog version, model choice). Choose "nightowl-light/nightowl"
  # in /settings to follow the terminal's light or dark appearance.
  home.file.".pi/agent/themes/nightowl.json".source = ./pi/nightowl.json;
  home.file.".pi/agent/themes/nightowl-light.json".source = ./pi/nightowl-light.json;
}
