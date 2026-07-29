{ pkgs, inputs, ... }:

let
  addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};

  extensions = with addons; [
    ublock-origin
    bitwarden
    duckduckgo-privacy-essentials
    zotero-connector
  ];

  bookmarks = builtins.fromJSON (builtins.readFile ./firefox-bookmarks.json);
  betterfox = builtins.readFile "${inputs.betterfox}/user.js";
in
{
  programs.firefox = {
    enable = true;

    # 26.05 moves this under XDG. Pinned to the legacy path because the profile
    # is 608M and only moves by hand; migrating is its own job.
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
      '';
    };
  };
}
