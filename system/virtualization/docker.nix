{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # docker
    docker-compose
  ];

  virtualisation.docker = {
    enable = true;

    # docker.socket still starts the daemon on the first command, so the 128M
    # dockerd and containerd hold is only paid when containers are actually
    # used. The trade is that restart=always does not survive a reboot.
    enableOnBoot = false;

    # --all also collects images no container references, which is where the
    # space actually goes.
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };

  users.users.philipp.extraGroups = [ "docker" ];
}
