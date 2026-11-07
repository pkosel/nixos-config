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
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=300"
      "_netdev"
      # Names keep ownership stable when the user's allocated UID changes.
      "uid=philipp"
      "gid=users"
    ];
  };
}
