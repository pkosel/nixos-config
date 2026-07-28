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
    # Automount rather than a boot mount: a remote share that is unreachable at
    # boot would otherwise hold up the whole boot on _netdev.
    #
    # mount.davfs resolves uid/gid by name, so these survive a uid change —
    # unlike numeric ids, which are only correct by coincidence. The user's own
    # uid cannot be referenced from config here, as isNormalUser allocates it at
    # activation and it evaluates to null.
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
