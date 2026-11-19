{ config, ... }:

let
  freshrss = config.services.freshrss;
in

{
  services.freshrss = {
    enable = true;
    virtualHost = "rss.${config.networking.domain}";
    baseUrl = "https://${freshrss.virtualHost}";
    defaultUser = "philipp";
    authType = "http_auth";
    api.enable = true;
  };

  services.nginx.virtualHosts.${freshrss.virtualHost} = {
    listen = [
      {
        addr = "127.0.0.1";
        port = 8080;
      }
    ];
    locations."~ ^.+?\\.php(/.*)?$".fastcgiParams = {
      HTTPS = "on";
      # Only Remote-User from Authelia may select the FreshRSS account.
      HTTP_X_WEBAUTH_USER = "";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      freshrss = {
        rule = "Host(`${freshrss.virtualHost}`)";
        entryPoints = [ "websecure" ];
        middlewares = [
          "tailnet-only"
          "freshrss-auth"
        ];
        service = "freshrss";
      };
      # The more specific rule bypasses browser SSO; the API requires its own password.
      freshrss-api = {
        rule = "Host(`${freshrss.virtualHost}`) && PathPrefix(`/api/`)";
        entryPoints = [ "websecure" ];
        middlewares = [
          "tailnet-only"
          "freshrss-api-headers"
        ];
        service = "freshrss";
      };
    };
    middlewares = {
      freshrss-auth.forwardAuth = {
        address = "http://127.0.0.1:9091/api/authz/forward-auth";
        trustForwardHeader = true;
        authResponseHeaders = [ "Remote-User" ];
      };
      freshrss-api-headers.headers.customRequestHeaders = {
        "Remote-User" = "";
        "X-WebAuth-User" = "";
      };
    };
    services.freshrss.loadBalancer.servers = [ { url = "http://127.0.0.1:8080"; } ];
  };
}
