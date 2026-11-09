{ pkgs, ... }:

{
  home.packages = [ pkgs.brave-origin ];

  # Home Manager's Brave extensions target Brave-Browser, not Brave-Origin.
  # Use its extension option for Proton Pass once Origin is supported.
  xdg.configFile."BraveSoftware/Brave-Origin/External Extensions/ghmbeldphafepmbegfdlkpapadhbakde.json".text =
    builtins.toJSON {
      external_update_url = "https://clients2.google.com/service/update2/crx";
    };
}
