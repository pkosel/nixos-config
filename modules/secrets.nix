{ config, inputs, ... }:

let
  authelia = config.services.authelia.instances.main;
in

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../secrets/bridget.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
    secrets = {
      smtp-password = {
        owner = authelia.user;
        restartUnits = [
          "authelia-main.service"
          "forgejo.service"
        ];
      };
      authelia-password-hash = { };
      authelia-jwt-secret = {
        owner = authelia.user;
        restartUnits = [ "authelia-main.service" ];
      };
      authelia-storage-key = {
        owner = authelia.user;
        restartUnits = [ "authelia-main.service" ];
      };
      authelia-oidc-hmac-secret = {
        owner = authelia.user;
        restartUnits = [ "authelia-main.service" ];
      };
      authelia-oidc-private-key = {
        owner = authelia.user;
        restartUnits = [ "authelia-main.service" ];
      };
      forgejo-oidc-secret-hash = { };
      restic-password = { };
      restic-ssh-key = { };
    };
  };
}
