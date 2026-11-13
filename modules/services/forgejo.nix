{ config, ... }:

let
  forgejo = config.services.forgejo;
in

{
  environment.systemPackages = [ forgejo.package ];

  services.forgejo = {
    enable = true;
    user = "git";
    group = "git";
    settings = {
      DEFAULT.APP_NAME = "Philipp's Forgejo";
      server = {
        DOMAIN = "git.${config.networking.domain}";
        ROOT_URL = "https://${forgejo.settings.server.DOMAIN}/";
        HTTP_ADDR = "127.0.0.1";
      };
      service = {
        DISABLE_REGISTRATION = true;
        DEFAULT_KEEP_EMAIL_PRIVATE = true;
        ENABLE_NOTIFY_MAIL = true;
        # Prevent password login from bypassing Authelia MFA; tokens still work.
        ENABLE_INTERNAL_SIGNIN = false;
        ENABLE_BASIC_AUTHENTICATION = false;
      };
      # Disable legacy OpenID, not the OAuth2/OpenID Connect authentication source.
      openid.ENABLE_OPENID_SIGNIN = false;
      repository.DEFAULT_PRIVATE = "private";
      session.COOKIE_SECURE = true;
      actions.ENABLED = false;
      mailer = {
        ENABLED = true;
        PROTOCOL = "smtp+starttls";
        SMTP_ADDR = "smtp.protonmail.ch";
        SMTP_PORT = 587;
        USER = "server@${config.networking.domain}";
        FROM = "server@${config.networking.domain}";
      };
    };
    secrets.mailer.PASSWD = config.sops.secrets.smtp-password.path;
  };

  users = {
    groups.git = { };
    users.git = {
      isSystemUser = true;
      inherit (forgejo) group;
      home = forgejo.stateDir;
      useDefaultShell = true;
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.forgejo = {
      rule = "Host(`${forgejo.settings.server.DOMAIN}`)";
      entryPoints = [ "websecure" ];
      service = "forgejo";
    };
    services.forgejo.loadBalancer.servers = [
      { url = "http://127.0.0.1:${toString forgejo.settings.server.HTTP_PORT}"; }
    ];
  };
}
