{ ... }:

{
  services.davfs2 = {
    enable = true;
    settings.globalSection.ask_auth = false;
  };

  fileSystems."/mnt/webdav" = {
    device = "https://files.pkosel.dev";
    fsType = "davfs";
    options = [
      # Keep mount -a from bypassing on-demand mounting.
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=300"
      "x-systemd.mount-timeout=30s"
      "_netdev"
      # Names keep ownership stable when the user's allocated UID changes.
      "uid=philipp"
      "gid=users"
    ];
  };
}
