{ config, lib, ... }:

let
  domain = config.networking.domain;
  tailnetInterface = config.services.tailscale.interfaceName;
  papraHost = lib.removePrefix "https://" config.services.papra.environment.APP_BASE_URL;
in

{
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      interface = tailnetInterface;
      except-interface = "lo";
      # The tunnel may acquire its addresses after this service starts.
      bind-dynamic = true;
      no-hosts = true;
      no-resolv = true;
      # Forward only this zone; its other names and records still use public DNS.
      server = [ "/${domain}/1.1.1.1" ];
      interface-name = [
        "${domain},${tailnetInterface}"
        "${config.services.freshrss.virtualHost},${tailnetInterface}"
        "${papraHost},${tailnetInterface}"
      ];
    };
  };

  networking.firewall.interfaces.${tailnetInterface} = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
