{ config, pkgs, ... }:
let addons = pkgs.nur.repos.rycee.firefox-addons;
in {
  programs.firefox = {
    enable = true;
    profiles.philipp = {
      extensions = with addons; [
        ublock-origin
        bitwarden
        (buildFirefoxXpiAddon {
          pname = "zotero-connector";
          version = "5.0.107";
          addonId = "zotero@chnm.gmu.edu";
          url =
            "https://download.zotero.org/connector/firefox/release/Zotero_Connector-5.0.107.xpi";
          sha256 = "sha256-RuAhWGvUhkog8SxzKhRwQQwzTQLzBKlHjSsFj9e25e4=";
          meta = { };
        })
        languagetool
        libredirect
      ];
      search = {
        default = "DuckDuckGo";
        engines = {
          "Google".metaData.hidden = true;
          "Amazon.de".metaData.hidden = true;
          "Bing".metaData.hidden = true;
        };
      };
      settings = {
        # Privacy & Security Improvements
        "dom.security.https_only_mode" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.cryptomining" = true;
        "privacy.trackingprotection.fingerprinting" = true;
        "privacy.trackingprotection.socialtracking" = true;

        # Disable Telemetry
        "datareporting.healthreport.uploadEnabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "toolkit.telemetry.enabled" = false;

        # Disable Personalisation & Sponsored Content
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.default.sites" = "";
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.pinned" = "";

        # Disable Experiments & Studies
        "app.shield.optoutstudies.enabled" = false;

        # Other
        "browser.uitour.enabled" = false;
        "browser.startup.homepage" = "https://start.duckduckgo.com/";
        "browser.startup.startuppage" = 3;
        "browser.tabs.firefox-view" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.pocket.enabled" = false;
        "identity.fxaccounts.enabled" = false;
        "layout.css.prefers-color-scheme.content-override" = 1;
        "services.passwordSavingEnabled" = false;
        "signon.autofillForms" = false;
        "signon.rememberSignons" = false;

        "browser.uiCustomization.state" = builtins.toJSON {
          "placements" = {
            "widget-overflow-fixed-list" = [ ];
            "unified-extensions-area" = [ ];
            "nav-bar" = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "home-button"
              "customizableui-special-spring1"
              "urlbar-container"
              "customizableui-special-spring2"
              "downloads-button"
              "fxa-toolbar-menu-button"
              "ublock0_raymondhill_net-browser-action"
              "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
              "zotero_chnm_gmu_edu-browser-action"
              "languagetool-webextension_languagetool_org-browser-action"
            ];
            "toolbar-menubar" = [
              "menubar-items"
            ];
            "TabsToolbar" = [
              "tabbrowser-tabs"
              "new-tab-button"
              "alltabs-button"
            ];
            "PersonalToolbar" = [
              "personal-bookmarks"
            ];
          };
          "seen" = [
            "developer-button"
          ];
          "dirtyAreaCache" = [
            "nav-bar"
            "PersonalToolbar"
            "TabsToolbar"
          ];
          "currentVersion" = 18;
          "newElementCount" = 3;
        };
      };
    };
  };
}
