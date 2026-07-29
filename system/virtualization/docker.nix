{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # docker
    docker-compose
  ];

  virtualisation.docker = {
    enable = true;

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
