{ pkgs, inputs, ... }:

let
  addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};

  extensions = with addons; [
    ublock-origin
    bitwarden
    proton-pass
    duckduckgo-privacy-essentials
    zotero-connector
  ];

  bookmarks = builtins.fromJSON (builtins.readFile ./firefox-bookmarks.json);
  betterfox = builtins.readFile "${inputs.betterfox}/user.js";
in
{
  programs.firefox = {
    enable = true;

    # The default is under XDG from home.stateVersion 26.05. This pins the legacy
    # path because the profile is large and only moves by hand. Replace the pin
    # after moving ~/.mozilla/firefox to $XDG_CONFIG_HOME/mozilla/firefox; native
    # messaging hosts are not moved by the option and need moving too.
    configPath = ".mozilla/firefox";
    profiles.philipp = {
      extensions.packages = extensions;

      bookmarks = {
        force = true;
        settings = bookmarks;
      };

      search = {
        # Firefox writes search.json.mozlz4 itself, so Home Manager refuses to
        # replace it unless told to. Without this the activation aborts.
        force = true;
        default = "ecosia";
        engines = {
          "google".metaData.hidden = true;
          "Amazon.de".metaData.hidden = true;
          "bing".metaData.hidden = true;
        };
      };

      extraConfig = ''
        ${betterfox}

        // User overrides
        user_pref("browser.startup.homepage", "https://ecosia.org/");
        user_pref("browser.startup.page", 3);
        user_pref("privacy.clearOnShutdown.history", false);

        // Content defaults to 3, "follow the browser theme", so the dark chrome
        // darkened every page. Setting 1 pins pages to light.
        user_pref("layout.css.prefers-color-scheme.content-override", 1);
      '';
    };
  };
}
