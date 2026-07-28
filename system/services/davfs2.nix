{ ... }:

{
  services.davfs2.enable = true;

  users.users.philipp.extraGroups = [ "davfs2" ];

  systemd.tmpfiles.rules = [
    "d /mnt/webdav 0755 root root -"
  ];

  fileSystems."/mnt/webdav" = {
    device = "https://files.pkosel.dev";
    fsType = "davfs";
    # Automount, so an unreachable share does not hold up boot on _netdev.
    # uid/gid by name survive a uid change; philipp's own uid cannot be
    # referenced here, isNormalUser allocates it at activation so it reads null.
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=300"
      "_netdev"
      "uid=philipp"
      "gid=users"
    ];
  };
}
