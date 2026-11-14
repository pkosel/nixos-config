{ config, ... }:

let
  homepage = config.services.homepage-dashboard;
in

{
  services.homepage-dashboard = {
    enable = true;
    allowedHosts = config.networking.domain;
    settings = {
      title = "Bridget";
      theme = "dark";
      color = "slate";
      headerStyle = "clean";
      target = "_self";
      hideVersion = true;
      # Updates are managed through the pinned NixOS package.
      disableUpdateCheck = true;
      layout.Services = {
        style = "row";
        columns = 3;
      };
    };
    services = [
      {
        Services = [
          {
            Forgejo = {
              icon = "mdi-git";
              href = config.services.forgejo.settings.server.ROOT_URL;
              description = "Git repositories and code collaboration";
            };
          }
          {
            FreshRSS = {
              icon = "mdi-rss";
              href = config.services.freshrss.baseUrl;
              description = "RSS subscriptions and reading";
            };
          }
          {
            Authelia = {
              icon = "mdi-shield-account";
              href = "https://auth.${config.networking.domain}";
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
