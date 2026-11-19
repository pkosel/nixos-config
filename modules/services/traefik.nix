{ config, ... }:

let
  tailnetInterface = config.services.tailscale.interfaceName;
  tailnetIpv4 = "100.64.0.0/10";
  tailnetIpv6 = "fd7a:115c:a1e0::/48";
  webSourceDrop = range: "! -i ${tailnetInterface} -p tcp --dport 443 -s ${range} -j DROP";
  dropV4 = webSourceDrop tailnetIpv4;
  dropV6 = webSourceDrop tailnetIpv6;
in

{
  # Traefik trusts the socket peer, not forwarded headers. Require traffic
  # with a tailnet source to enter via the tunnel, before any INPUT accepts.
  networking.firewall = {
    extraCommands = ''
      iptables -w -t raw -C PREROUTING ${dropV4} || iptables -w -t raw -I PREROUTING ${dropV4}
      ip6tables -w -t raw -C PREROUTING ${dropV6} || ip6tables -w -t raw -I PREROUTING ${dropV6}
    '';
    extraStopCommands = ''
      if iptables -w -t raw -C PREROUTING ${dropV4}; then
        iptables -w -t raw -D PREROUTING ${dropV4}
      fi
      if ip6tables -w -t raw -C PREROUTING ${dropV6}; then
        ip6tables -w -t raw -D PREROUTING ${dropV6}
      fi
    '';
  };

  services.traefik = {
    enable = true;
    dynamicConfigOptions.http.middlewares.tailnet-only.ipAllowList.sourceRange = [
      tailnetIpv4
      tailnetIpv6
    ];
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
