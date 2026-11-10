{ ... }:

{
  virtualisation.docker = {
    enable = true;

    # Socket activation still works, but restart policies only take effect once
    # the daemon starts after reboot.
    enableOnBoot = false;

    # Pruning starts the daemon and removes stopped containers with their writable
    # layers. Volumes are retained.
    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
  };
}
