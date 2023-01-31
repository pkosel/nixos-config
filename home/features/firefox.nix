{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  addons = pkgs.nur.repos.rycee.firefox-addons;
in {
  programs.firefox = {
    enable = true;
    extensions = with addons; [
      ublock-origin
      keepassxc-browser
      (buildFirefoxXpiAddon {
        pname = "zotero-connector";
        version = "5.0.103";
        addonId = "zotero@chnm.gmu.edu";
        url = "https://download.zotero.org/connector/firefox/release/Zotero_Connector-5.0.103.xpi";
        sha256 = "sha256-dHdcbGb/NO4jiyhEcDdfzJRbdz+d4ZCtojEtkbOVdD0=";
        meta = {};
      })
      languagetool
      libredirect
    ];
    profiles.philipp = {
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
        "services.passwordSavingEnabled" = false;
        "signon.autofillForms" = false;
        "signon.rememberSignons" = false;
      };
    };
  };
}
