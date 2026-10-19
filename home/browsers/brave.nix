{ pkgs, ... }:

{
  home.packages = [ pkgs.brave-origin ];

  # Chromium installs extensions listed as JSON files in
  # "<user-data-dir>/External Extensions/<id>.json". Brave Origin's
  # user-data-dir is Brave-Origin, not Brave-Browser, so programs.brave
  # cannot be used: it hardcodes the Brave-Browser directory.
  xdg.configFile."BraveSoftware/Brave-Origin/External Extensions/ghmbeldphafepmbegfdlkpapadhbakde.json".text =
    builtins.toJSON {
      external_update_url = "https://clients2.google.com/service/update2/crx";
    };
}
