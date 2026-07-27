{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # docker
    docker-compose
  ];

  virtualisation.docker = {
    enable = true;

    # Important: avoid insecure docker-28 default.
    package = pkgs.docker_29;

    # autoPrune = {
    #   enable = true;
    #   dates = "weekly";
    #   flags = [ "--all" ];
    # };
  };

  users.users.philipp.extraGroups = [ "docker" ];
}

