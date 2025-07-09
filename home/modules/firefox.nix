{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  firefox-addons = inputs.firefox-addons.packages.${pkgs.system};

  extensions = with firefox-addons; [
    ublock-origin
    bitwarden
    zotero-connector
  ];

  # UI toolbar customization
  toolbarLayout = {
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
      "toolbar-menubar" = [ "menubar-items" ];
      "TabsToolbar" = [
        "tabbrowser-tabs"
        "new-tab-button"
        "alltabs-button"
      ];
      "PersonalToolbar" = [ "personal-bookmarks" ];
    };
    "seen" = [ "developer-button" ];
    "dirtyAreaCache" = [ "nav-bar" "PersonalToolbar" "TabsToolbar" ];
    "currentVersion" = 18;
    "newElementCount" = 3;
  };
in
{
  programs.firefox = {
    enable = true;
    profiles.philipp = {
      extensions.packages = extensions;

      # Bookmarks configuration
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Bookmarks Toolbar";
            toolbar = true;
            bookmarks = [
              {
                name = "NixOS Search";
                url = "https://search.nixos.org";
                keyword = "nix";
              }
              {
                name = "GitHub";
                url = "https://github.com";
              }
              {
                name = "NixOS";
                bookmarks = [
                  {
                    name = "Documentation";
                    bookmarks = [
                      {
                        name = "NixOS Manual";
                        url = "https://nixos.org/manual/nixos/stable/";
                      }
                      {
                        name = "Nix Manual";
                        url = "https://nixos.org/manual/nix/stable/";
                      }
                      {
                        name = "Home Manager Manual";
                        url = "https://nix-community.github.io/home-manager/";
                      }
                      {
                        name = "NixOS Wiki";
                        url = "https://wiki.nixos.org/wiki/NixOS_Wiki";
                      }
                      {
                        name = "Nix.dev";
                        url = "https://nix.dev/";
                      }
                    ];
                  }
                  {
                    name = "Learning Resources";
                    bookmarks = [
                      {
                        name = "NixOS Learn Hub";
                        url = "https://nixos.org/learn/";
                      }
                      {
                        name = "Zero to Nix";
                        url = "https://zero-to-nix.com/";
                      }
                      {
                        name = "NixOS & Flakes Book";
                        url = "https://nixos-and-flakes.thiscute.world/";
                      }
                      {
                        name = "Nix Pills";
                        url = "https://nixos.org/guides/nix-pills/";
                      }
                      {
                        name = "Nix from First Principles";
                        url = "https://tonyfinn.com/blog/nix-from-first-principles-flake-edition/";
                      }
                    ];
                  }
                  {
                    name = "Advanced & Practical";
                    bookmarks = [
                      {
                        name = "Practical Nix Flakes";
                        url = "https://serokell.io/blog/practical-nix-flakes";
                      }
                      {
                        name = "Flake Parts";
                        url = "https://flake.parts/";
                      }
                      {
                        name = "Awesome Nix";
                        url = "https://nix-community.github.io/awesome-nix/";
                      }
                    ];
                  }
                  {
                    name = "Community & Examples";
                    bookmarks = [
                      {
                        name = "NixOS Discourse";
                        url = "https://discourse.nixos.org/";
                      }
                      {
                        name = "felschr's Config";
                        url = "https://gitlab.com/felschr/nixos-config";
                      }
                      {
                        name = "NixOS/nixpkgs";
                        url = "https://github.com/NixOS/nixpkgs";
                      }
                    ];
                  }
                ];
              }
            ];
          }
        ];
      };

      # Search engine configuration
      search = {
        default = "ddg";
        engines = {
          "google".metaData.hidden = true;
          "Amazon.de".metaData.hidden = true;
          "bing".metaData.hidden = true;
        };
      };

      settings = {
        # Startup
        "browser.startup.homepage" = "https://start.duckduckgo.com/";
        "browser.startup.startuppage" = 3;

        # Security essentials
        "dom.security.https_only_mode" = true;
        "security.tls.version.min" = 3;

        # Privacy essentials
        "network.cookie.cookieBehavior" = 5;
        "privacy.trackingprotection.enabled" = true;
        "privacy.clearOnShutdown.cache" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.formdata" = true;

        # Disable telemetry
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.enabled" = false;

        # Disable unwanted features
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "extensions.pocket.enabled" = false;
        "browser.translations.automaticallyPopup" = false;

        # Appearance
        "layout.css.prefers-color-scheme.content-override" = 1;

        # Toolbar customization
        "browser.uiCustomization.state" = builtins.toJSON toolbarLayout;
      };
    };
  };
}
