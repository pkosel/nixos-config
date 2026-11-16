{ config, pkgs, ... }:

let
  papra = config.services.papra;
  domain = "docs.${config.networking.domain}";
in

{
  services.papra = {
    enable = true;
    environmentFile = config.sops.templates."papra.env".path;
    environment = {
      NODE_ENV = "production";
      PAPRA_VERSION = papra.package.version;
      APP_BASE_URL = "https://${domain}";
      SERVER_HOSTNAME = "127.0.0.1";
      SERVER_CORS_ORIGINS = "https://${domain}";
      AUTH_PROVIDERS_EMAIL_IS_ENABLED = false;
      AUTH_IS_PASSWORD_RESET_ENABLED = false;
      # In 26.6.1 custom OIDC providers still provision accounts with signup off.
      AUTH_IS_REGISTRATION_ENABLED = false;
      AUTH_IS_EMAIL_VERIFICATION_REQUIRED = true;
      DOCUMENTS_OCR_LANGUAGES = "deu,eng";
      CONTENT_EXTRACTION_STRATEGY = "internal";
      AI_IS_ENABLED = false;
      INGESTION_FOLDER_IS_ENABLED = true;
      # Link <organization-id> to /srv/papra/inbox after creating family in the UI.
      INGESTION_FOLDER_ROOT_PATH = "/var/lib/papra/ingestion";
      INGESTION_FOLDER_POST_PROCESSING_STRATEGY = "delete";
      INGESTION_FOLDER_ERROR_FOLDER_PATH = "ingestion-error";
      # Allow scanner and network uploads to settle before importing.
      INGESTION_FOLDER_WATCHER_FILE_STABILITY_THRESHOLD_MS = 10000;
      INTAKE_EMAILS_IS_ENABLED = true;
      # This driver generates addresses; Cloudflare routes each explicitly because
      # Email Routing subdomains do not support a catch-all rule.
      INTAKE_EMAILS_DRIVER = "catch-all";
      INTAKE_EMAILS_CATCH_ALL_DOMAIN = "intake.${config.networking.domain}";
    };
  };

  sops.templates."papra.env" = {
    owner = config.services.papra.user;
    restartUnits = [ "papra.service" ];
    content = ''
      AUTH_SECRET=${config.sops.placeholder.papra-auth-secret}
      INTAKE_EMAILS_WEBHOOK_SECRET=${config.sops.placeholder.papra-intake-webhook-secret}
      AUTH_PROVIDERS_CUSTOMS='${
        builtins.toJSON [
          {
            providerId = "authelia";
            providerName = "Authelia";
            clientId = "bridget-papra";
            clientSecret = config.sops.placeholder.papra-oidc-client-secret;
            type = "oidc";
            discoveryUrl = "https://auth.${config.networking.domain}/.well-known/openid-configuration";
            scopes = [
              "openid"
              "profile"
              "email"
            ];
            pkce = true;
          }
        ]
      }'
    '';
  };

  systemd.services.papra = {
    path = [
      (pkgs.tesseract.override {
        enableLanguages = [
          "deu"
          "eng"
        ];
      })
    ];
    serviceConfig = {
      WorkingDirectory = "/var/lib/papra";
      UMask = "0007";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ReadWritePaths = [ "/srv/papra/inbox" ];
    };
  };

  users.users.papra-upload = {
    isSystemUser = true;
    inherit (papra) group;
    home = "/inbox";
    createHome = false;
    # sshd requires a valid shell even though ForceCommand forbids shell access.
    useDefaultShell = true;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/papra/ingestion 0700 ${papra.user} ${papra.group} -"
    "d /srv/papra 0755 root root -"
    "d /srv/papra/inbox 2770 papra-upload ${papra.group} -"
    # Provision Frieda's and the scanner's public keys here; not an admin key.
    "d /var/lib/papra-sftp/authorized_keys 0755 root root -"
  ];

  services.openssh.extraConfig = ''
    Match User papra-upload
      ChrootDirectory /srv/papra
      ForceCommand internal-sftp -d /inbox -u 0007
      AuthorizedKeysFile /var/lib/papra-sftp/authorized_keys/%u
      AuthenticationMethods publickey
      DisableForwarding yes
      PermitTTY no
    Match all
  '';

  services.traefik.dynamicConfigOptions.http = {
    routers.papra = {
      rule = "Host(`${domain}`)";
      entryPoints = [ "websecure" ];
      service = "papra";
    };
    services.papra.loadBalancer.servers = [
      { url = "http://127.0.0.1:${config.systemd.services.papra.environment.PORT}"; }
    ];
  };
}
