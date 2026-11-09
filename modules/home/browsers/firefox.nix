{ pkgs, inputs, ... }:

let
  addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.firefox = {
    enable = true;

    # Keep the existing profile path until a manual XDG migration; native
    # messaging hosts must be migrated separately.
    configPath = ".mozilla/firefox";
    profiles.philipp = {
      extensions.packages = with addons; [
        ublock-origin
        proton-pass
        zotero-connector
        dictionary-german
      ];

      search = {
        # Firefox replaces the search symlink on launch; without forcing
        # replacement, subsequent Home Manager activations can fail.
        force = true;
        default = "ecosia";
        engines = {
          "google".metaData.hidden = true;
          "bing".metaData.hidden = true;
        };
      };

      settings = {
        # Retain approval for foreign add-ons installed outside this profile.
        "extensions.autoDisableScopes" = 14;
        "spellchecker.dictionary" = "en-US,de-DE";

        # Tracking and privacy
        "browser.contentblocking.category" = "strict";
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.antitracking.isolateContentScriptResources" = true;
        "network.http.referer.XOriginTrimmingPolicy" = 2;
        "permissions.default.desktop-notification" = 2;
        "permissions.default.geo" = 2;
        "permissions.manager.defaultsUrl" = "";

        # Security
        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        "security.tls.enable_0rtt_data" = false;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_error_page_user_suggestions" = true;
        # Expose Unicode lookalike domains as ASCII.
        "network.IDN_show_punycode" = true;
        "pdfjs.enableScripting" = false;
        "network.auth.subresource-http-auth-allow" = 1;

        # Reset persisted protection opt-outs and the certificate-error UI override.
        # Remove after the existing profile has loaded these values.
        "security.OCSP.enabled" = 1;
        "security.csp.reporting.enabled" = true;
        "browser.safebrowsing.downloads.remote.enabled" = true;
        "browser.xul.error_pages.expert_bad_cert" = false;

        # Speculative connections
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "browser.places.speculativeConnect.enabled" = false;
        "network.http.speculative-parallel-limit" = 0;

        # Telemetry and studies
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.usage.uploadEnabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "nimbus.rollouts.enabled" = false;
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;

        # Prompts and promotions
        "browser.shell.checkDefaultBrowser" = false;
        "browser.aboutwelcome.enabled" = false;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.discovery.enabled" = false;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.preferences.moreFromMozilla" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
        "browser.newtabpage.activity-stream.default.sites" = "";
        # Pin off independently of regional defaults and rollouts.
        "browser.urlbar.quicksuggest.enabled" = false;
        "browser.urlbar.trending.featureGate" = false;
        "browser.download.manager.addToRecentDocs" = false;
        "browser.search.suggest.enabled" = false;
        "browser.translations.automaticallyPopup" = false;

        # Proton Pass replaces Firefox's password manager and autofill.
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;

        # AI
        "browser.ai.control.default" = "blocked";
        "browser.ml.enable" = false;
        "browser.ml.chat.enabled" = false;
        "browser.ml.chat.menu" = false;
        "browser.ml.linkPreview.enabled" = false;
        "browser.tabs.groups.smart.enabled" = false;

        # Reset persisted bookmark-import requests to prevent re-importing the
        # local file alongside Sync-managed bookmarks.
        "browser.places.importBookmarksHTML" = false;

        # Pin Sync to bookmarks only; Proton Pass and Nix own credentials and
        # settings.
        "services.sync.engine.bookmarks" = true;
        "services.sync.engine.history" = false;
        "services.sync.engine.tabs" = false;
        "services.sync.engine.addons" = false;
        "services.sync.engine.passwords" = false;
        "services.sync.engine.creditcards" = false;
        "services.sync.engine.addresses" = false;
        "services.sync.engine.prefs" = false;

        # Startup
        "browser.startup.homepage" = "https://ecosia.org/";
        "browser.startup.page" = 3;

        # Legacy migration inputs prevent re-enabling history clearing and
        # preserve form data while Firefox migrates shutdown preferences.
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
        "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = false;

        # Value 1 keeps web content light independently of the dark browser theme.
        "layout.css.prefers-color-scheme.content-override" = 1;
      };
    };
  };
}
