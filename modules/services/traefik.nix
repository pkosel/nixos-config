{ config, ... }:

{
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";
          http.tls.certResolver = "letsencrypt";
        };
      };
      certificatesResolvers.letsencrypt.acme = {
        email = "ph.kosel@proton.me";
        storage = "${config.services.traefik.dataDir}/acme.json";
        httpChallenge.entryPoint = "web";
      };
    };
  };
}
