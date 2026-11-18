{ config, inputs, ... }:

let
  authelia = config.services.authelia.instances.main;
in

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";
    secrets = {
      smtp-password = {
        sopsFile = ../secrets/smtp.yaml;
        owner = authelia.user;
        restartUnits = [
          "authelia-main.service"
          "forgejo.service"
        ];
      };
      authelia-password-hash.sopsFile = ../secrets/authelia.yaml;
      authelia-jwt-secret = {
        sopsFile = ../secrets/authelia.yaml;
        owner = authelia.user;
        restartUnits = [ "authelia-main.service" ];
      };
      authelia-storage-key = {
        sopsFile = ../secrets/authelia.yaml;
        owner = authelia.user;
        restartUnits = [ "authelia-main.service" ];
      };
      authelia-oidc-hmac-secret = {
        sopsFile = ../secrets/authelia.yaml;
        owner = authelia.user;
        restartUnits = [ "authelia-main.service" ];
      };
      authelia-oidc-private-key = {
        sopsFile = ../secrets/authelia.yaml;
        owner = authelia.user;
        restartUnits = [ "authelia-main.service" ];
      };
      forgejo-oidc-secret-hash.sopsFile = ../secrets/forgejo.yaml;
      restic-password.sopsFile = ../secrets/restic.yaml;
      restic-ssh-key.sopsFile = ../secrets/restic.yaml;
      restic-healthcheck-curl.sopsFile = ../secrets/restic.yaml;
      papra-auth-secret.sopsFile = ../secrets/papra.yaml;
      papra-oidc-client-secret.sopsFile = ../secrets/papra.yaml;
      papra-oidc-secret-hash = {
        sopsFile = ../secrets/papra.yaml;
        restartUnits = [ "authelia-main.service" ];
      };
      papra-intake-webhook-secret.sopsFile = ../secrets/papra.yaml;
      papra-document-encryption-key.sopsFile = ../secrets/papra.yaml;
      papra-database-encryption-key.sopsFile = ../secrets/papra.yaml;
    };
  };
}
