{ ... }:

{
  # pi finds themes in ~/.pi/agent/themes. Selecting it is "theme" in
  # ~/.pi/agent/settings.json, which stays unmanaged because pi rewrites that
  # file itself (changelog version, model choice).
  home.file.".pi/agent/themes/nightowl.json".source = ./pi/nightowl.json;
}
