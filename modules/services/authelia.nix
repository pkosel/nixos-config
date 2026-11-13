{ config, ... }:

let
  authelia = config.services.authelia.instances.main;
  authenticationDomain = "auth.${config.networking.domain}";
  authenticationUrl = "https://${authenticationDomain}";
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
      # Authelia forbids a deny default when no access-control rules are defined.
      access_control.default_policy = "two_factor";
      session.cookies = [
        {
          domain = config.networking.domain;
          authelia_url = authenticationUrl;
          default_redirection_url = config.services.forgejo.settings.server.ROOT_URL;
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
        users.philipp = {
          displayname = "Philipp";
          email = "ph.kosel@proton.me";
          password = config.sops.placeholder.authelia-password-hash;
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
            authorization_policy = "two_factor";
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
        ];
      };
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.authelia = {
      rule = "Host(`${authenticationDomain}`)";
      entryPoints = [ "websecure" ];
      service = "authelia";
    };
    services.authelia.loadBalancer.servers = [ { url = "http://127.0.0.1:9091"; } ];
  };
}
