{ pkgs, ... }:

{
  home.packages = [ pkgs.brave-origin ];

  # Chromium reads extension JSON from "<user-data-dir>/External Extensions".
  # Brave Origin's directory is Brave-Origin, not Brave-Browser, so
  # programs.brave cannot be used: it hardcodes Brave-Browser.
  xdg.configFile."BraveSoftware/Brave-Origin/External Extensions/ghmbeldphafepmbegfdlkpapadhbakde.json".text =
    builtins.toJSON {
      external_update_url = "https://clients2.google.com/service/update2/crx";
    };
}
