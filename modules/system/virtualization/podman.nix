{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [ podman-compose ];

  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

  virtualisation.podman.autoPrune.enable = true;
  virtualisation.podman.autoPrune.dates = "weekly";
  virtualisation.podman.autoPrune.flags = [ "--all" ];
}
