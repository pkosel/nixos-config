{ pkgs, inputs, ... }:

let
  addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};

  extensions = with addons; [
    ublock-origin
    proton-pass
    zotero-connector
  ];

  bookmarks = builtins.fromJSON (builtins.readFile ./firefox-bookmarks.json);
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

      # Hand-written replacement for the Betterfox user.js. It covers tracking
      # protection, security hardening, and the prompts and promotions that
      # Firefox shows by default. Prefs that are not listed keep the Firefox
      # default.
      extraConfig = ''
        // Tracking and privacy
        user_pref("browser.contentblocking.category", "strict");
        user_pref("privacy.globalprivacycontrol.enabled", true);
        user_pref("privacy.antitracking.isolateContentScriptResources", true);
        user_pref("security.csp.reporting.enabled", false);
        user_pref("network.http.referer.XOriginTrimmingPolicy", 2);
        user_pref("permissions.default.desktop-notification", 2);
        user_pref("permissions.default.geo", 2);
        user_pref("permissions.manager.defaultsUrl", "");

        // Security
        // OCSP would leak every visited site to its CA; CRLite covers revocation
        // instead.
        user_pref("security.OCSP.enabled", 0);
        user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
        user_pref("security.tls.enable_0rtt_data", false);
        user_pref("dom.security.https_only_mode", true);
        user_pref("dom.security.https_only_mode_error_page_user_suggestions", true);
        // Show the punycode form of IDN host names, so lookalike domains are
        // visible instead of hidden behind non-ASCII characters.
        user_pref("network.IDN_show_punycode", true);
        user_pref("pdfjs.enableScripting", false);
        user_pref("browser.safebrowsing.downloads.remote.enabled", false);
        user_pref("network.auth.subresource-http-auth-allow", 1);
        user_pref("browser.xul.error_pages.expert_bad_cert", true);

        // Speculative loading off
        user_pref("network.dns.disablePrefetch", true);
        user_pref("network.prefetch-next", false);
        user_pref("browser.urlbar.speculativeConnect.enabled", false);
        user_pref("browser.places.speculativeConnect.enabled", false);
        user_pref("network.http.speculative-parallel-limit", 0);

        // Telemetry and studies off
        user_pref("datareporting.policy.dataSubmissionEnabled", false);
        user_pref("datareporting.healthreport.uploadEnabled", false);
        user_pref("datareporting.usage.uploadEnabled", false);
        user_pref("toolkit.telemetry.unified", false);
        user_pref("toolkit.telemetry.enabled", false);
        user_pref("toolkit.telemetry.server", "data:,");
        user_pref("toolkit.telemetry.archive.enabled", false);
        user_pref("toolkit.telemetry.newProfilePing.enabled", false);
        user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
        user_pref("toolkit.telemetry.updatePing.enabled", false);
        user_pref("toolkit.telemetry.bhrPing.enabled", false);
        user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
        user_pref("toolkit.telemetry.coverage.opt-out", true);
        user_pref("toolkit.coverage.opt-out", true);
        user_pref("toolkit.coverage.endpoint.base", "");
        user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
        user_pref("browser.newtabpage.activity-stream.telemetry", false);
        user_pref("app.shield.optoutstudies.enabled", false);
        user_pref("app.normandy.enabled", false);
        user_pref("app.normandy.api_url", "");
        user_pref("nimbus.rollouts.enabled", false);
        user_pref("breakpad.reportURL", "");
        user_pref("browser.tabs.crashReporting.sendReport", false);
        user_pref("browser.crashReports.unsubmittedCheck.enabled", false);

        // Prompts, promotions and ads off
        user_pref("browser.shell.checkDefaultBrowser", false);
        user_pref("browser.aboutwelcome.enabled", false);
        user_pref("browser.startup.homepage_override.mstone", "ignore");
        user_pref("browser.discovery.enabled", false);
        user_pref("extensions.getAddons.showPane", false);
        user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
        user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
        user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
        user_pref("browser.preferences.moreFromMozilla", false);
        user_pref("browser.aboutConfig.showWarning", false);
        user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
        user_pref("browser.newtabpage.activity-stream.showSponsored", false);
        user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);
        user_pref("browser.newtabpage.activity-stream.default.sites", "");
        user_pref("browser.urlbar.quicksuggest.enabled", false);
        user_pref("browser.urlbar.trending.featureGate", false);
        user_pref("browser.download.manager.addToRecentDocs", false);

        // No search suggestions while typing.
        user_pref("browser.search.suggest.enabled", false);

        // Keep the translate button, stop the automatic popup.
        user_pref("browser.translations.automaticallyPopup", false);

        // Proton Pass is the password manager, so Firefox's own manager, autofill
        // and form history stay off.
        user_pref("browser.formfill.enable", false);
        user_pref("extensions.formautofill.addresses.enabled", false);
        user_pref("extensions.formautofill.creditCards.enabled", false);
        user_pref("signon.rememberSignons", false);
        user_pref("signon.autofillForms", false);

        // AI features off.
        user_pref("browser.ai.control.default", "blocked");
        user_pref("browser.ml.enable", false);
        user_pref("browser.ml.chat.enabled", false);
        user_pref("browser.ml.chat.menu", false);
        user_pref("browser.ml.linkPreview.enabled", false);
        user_pref("browser.tabs.groups.smart.enabled", false);

        // Overrides
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
