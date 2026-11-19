{ config, ... }:

let
  authelia = config.services.authelia.instances.main;
  domain = config.networking.domain;
  authenticationDomain = "auth.${domain}";
  authenticationUrl = "https://${authenticationDomain}";
  tailscaleEmail = "tailscale@${domain}";
  webfingerPath = "/.well-known/webfinger";
  webfingerResource = "acct:${tailscaleEmail}";
  issuerRelation = "http://openid.net/specs/connect/1.0/issuer";
  webfingerPort = 9092;
in

{
  services.authelia.instances.main = {
    enable = true;
    secrets = {
      jwtSecretFile = config.sops.secrets.authelia-jwt-secret.path;
      storageEncryptionKeyFile = config.sops.secrets.authelia-storage-key.path;
      oidcHmacSecretFile = config.sops.secrets.authelia-oidc-hmac-secret.path;
      oidcIssuerPrivateKeyFile = config.sops.secrets.authelia-oidc-private-key.path;
    };
    environmentVariables.AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = config.sops.secrets.smtp-password.path;
    settings = {
      server.address = "tcp://127.0.0.1:9091/";
      log.level = "info";
      default_2fa_method = "totp";
      authentication_backend = {
        file.path = config.sops.templates."authelia-users.yaml".path;
        # The user database is rendered from SOPS and cannot be changed in place.
        password_reset.disable = true;
      };
      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = [
              domain
              config.services.freshrss.virtualHost
            ];
            policy = "two_factor";
            subject = [ "user:philipp" ];
          }
        ];
      };
      # The forward-auth rules above do not apply to OIDC clients.
      identity_providers.oidc.authorization_policies = {
        personal = {
          default_policy = "deny";
          rules = [
            {
              policy = "two_factor";
              subject = [ "user:philipp" ];
            }
          ];
        };
        tailnet = {
          default_policy = "deny";
          rules = [
            {
              policy = "two_factor";
              subject = [ "user:tailscale" ];
            }
          ];
        };
      };
      session.cookies = [
        {
          domain = config.networking.domain;
          authelia_url = authenticationUrl;
          default_redirection_url = "https://${config.networking.domain}/";
        }
      ];
      storage.local.path = "/var/lib/authelia-main/db.sqlite3";
      notifier.smtp = {
        address = "submission://smtp.protonmail.ch:587";
        username = "server@${config.networking.domain}";
        sender = "server@${config.networking.domain}";
        identifier = config.networking.fqdn;
      };
    };
    settingsFiles = [ config.sops.templates."authelia-oidc.yaml".path ];
  };

  sops.templates = {
    "authelia-users.yaml" = {
      owner = authelia.user;
      restartUnits = [ "authelia-main.service" ];
      content = builtins.toJSON {
        users = {
          philipp = {
            displayname = "Philipp";
            email = "ph.kosel@proton.me";
            password = config.sops.placeholder.authelia-password-hash;
          };
          tailscale = {
            displayname = "Tailscale";
            email = tailscaleEmail;
            password = config.sops.placeholder.tailscale-password-hash;
          };
        };
      };
    };
    "authelia-oidc.yaml" = {
      owner = authelia.user;
      restartUnits = [ "authelia-main.service" ];
      content = builtins.toJSON {
        identity_providers.oidc.clients = [
          {
            client_id = "bridget-forgejo";
            client_name = "Forgejo";
            client_secret = config.sops.placeholder.forgejo-oidc-secret-hash;
            public = false;
            authorization_policy = "personal";
            require_pkce = true;
            pkce_challenge_method = "S256";
            redirect_uris = [
              "${config.services.forgejo.settings.server.ROOT_URL}user/oauth2/authelia/callback"
            ];
            scopes = [
              "openid"
              "email"
              "profile"
            ];
            response_types = [ "code" ];
            grant_types = [ "authorization_code" ];
            token_endpoint_auth_method = "client_secret_basic";
          }
          {
            client_id = "bridget-papra";
            client_name = "Papra";
            client_secret = config.sops.placeholder.papra-oidc-secret-hash;
            public = false;
            authorization_policy = "personal";
            require_pkce = true;
            pkce_challenge_method = "S256";
            redirect_uris = [
              "${config.services.papra.environment.APP_BASE_URL}/api/auth/oauth2/callback/authelia"
            ];
            scopes = [
              "openid"
              "email"
              "profile"
            ];
            response_types = [ "code" ];
            grant_types = [ "authorization_code" ];
            # Papra's custom-provider schema does not expose token auth selection.
            token_endpoint_auth_method = "client_secret_post";
          }
          {
            client_id = "tailscale";
            client_name = "Tailscale";
            client_secret = config.sops.placeholder.tailscale-oidc-secret-hash;
            public = false;
            authorization_policy = "tailnet";
            # Tailscale's custom OIDC integration does not require PKCE.
            require_pkce = false;
            redirect_uris = [ "https://login.tailscale.com/a/oauth_response" ];
            scopes = [
              "openid"
              "email"
              "profile"
            ];
            response_types = [ "code" ];
            grant_types = [ "authorization_code" ];
            # Hosted Tailscale sends credentials in the token request body.
            token_endpoint_auth_method = "client_secret_post";
          }
        ];
      };
    };
  };

  # Authelia does not serve WebFinger; Tailscale needs it at the apex domain.
  services.nginx.virtualHosts.${domain} = {
    listen = [
      {
        addr = "127.0.0.1";
        port = webfingerPort;
      }
    ];
    locations."= ${webfingerPath}" = {
      extraConfig = "default_type application/jrd+json;";
      return = "200 '${
        builtins.toJSON {
          subject = webfingerResource;
          links = [
            {
              rel = issuerRelation;
              href = authenticationUrl;
            }
          ];
        }
      }'";
    };
    locations."/".return = "404";
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.authelia = {
      rule = "Host(`${authenticationDomain}`)";
      entryPoints = [ "websecure" ];
      service = "authelia";
    };
    routers.webfinger = {
      rule = "Host(`${domain}`) && Method(`GET`) && Path(`${webfingerPath}`) && Query(`resource`, `${webfingerResource}`) && (!QueryRegexp(`rel`, `.*`) || Query(`rel`, `${issuerRelation}`))";
      entryPoints = [ "websecure" ];
      service = "webfinger";
    };
    services.authelia.loadBalancer.servers = [ { url = "http://127.0.0.1:9091"; } ];
    services.webfinger.loadBalancer.servers = [
      { url = "http://127.0.0.1:${toString webfingerPort}"; }
    ];
  };
}
