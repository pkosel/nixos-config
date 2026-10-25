{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.docker-compose ];

  virtualisation.docker = {
    enable = true;

    # docker.socket still starts the daemon on the first command.
    # The trade is that restart=always does not survive a reboot.
    enableOnBoot = false;

    # --all collects unreferenced images, where the space goes.
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };
}
