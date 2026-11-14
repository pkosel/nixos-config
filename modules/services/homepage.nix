{ config, ... }:

let
  homepage = config.services.homepage-dashboard;
  backends = config.services.traefik.dynamicConfigOptions.http.services;
in

{
  services.homepage-dashboard = {
    enable = true;
    allowedHosts = config.networking.domain;
    customCSS = ''
      /* Homepage 1.12.3 renders uptime last, with a bar based on clock seconds.
         Hide that decorative bar but preserve alignment with the usage bars.
         Remove this rule when upstream supports disabling the uptime bar. */
      #information-widgets .information-widget-resource:last-child .resource-usage {
        visibility: hidden;
      }
    '';
    settings = {
      title = "Bridget";
      theme = "dark";
      color = "slate";
      headerStyle = "clean";
      target = "_self";
      hideVersion = true;
      statusStyle = "dot";
      # Updates are managed through the pinned NixOS package.
      disableUpdateCheck = true;
      layout.Services = {
        style = "row";
        columns = 3;
      };
    };
    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          disk = "/";
          uptime = true;
          refresh = 5000;
        };
      }
      {
        openmeteo = {
          label = "Munich";
          latitude = 48.137154;
          longitude = 11.576124;
          timezone = config.time.timeZone;
          units = "metric";
          cache = 5;
          format.maximumFractionDigits = 1;
        };
      }
    ];
    # Check backends directly so an SSO redirect cannot mask an unavailable app.
    services = [
      {
        Services = [
          {
            Forgejo = {
              icon = "mdi-git";
              href = config.services.forgejo.settings.server.ROOT_URL;
              siteMonitor = "${(builtins.head backends.forgejo.loadBalancer.servers).url}/api/healthz";
              description = "Git repositories and code collaboration";
            };
          }
          {
            FreshRSS = {
              icon = "mdi-rss";
              href = config.services.freshrss.baseUrl;
              # FreshRSS's upstream health check requests this PHP-rendered API page.
              siteMonitor = "${(builtins.head backends.freshrss.loadBalancer.servers).url}/api/";
              description = "RSS subscriptions and reading";
            };
          }
          {
            Authelia = {
              icon = "mdi-shield-account";
              href = "https://auth.${config.networking.domain}";
              siteMonitor = "${(builtins.head backends.authelia.loadBalancer.servers).url}/api/health";
              description = "Authentication portal";
            };
          }
        ];
      }
    ];
  };

  systemd.services.homepage-dashboard.environment.HOSTNAME = "127.0.0.1";

  services.traefik.dynamicConfigOptions.http = {
    routers.homepage = {
      rule = "Host(`${config.networking.domain}`)";
      entryPoints = [ "websecure" ];
      middlewares = [ "homepage-auth" ];
      service = "homepage";
    };
    middlewares.homepage-auth.forwardAuth = {
      address = "http://127.0.0.1:9091/api/authz/forward-auth";
      trustForwardHeader = true;
    };
    services.homepage.loadBalancer.servers = [
      { url = "http://127.0.0.1:${toString homepage.listenPort}"; }
    ];
  };
}
