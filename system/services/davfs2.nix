{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.davfs2.enable = true;

  # Add user to davfs2 group to allow mounting WebDAV shares
  users.users.philipp.extraGroups = [ "davfs2" ];

  # Create mount point directory
  systemd.tmpfiles.rules = [
    "d /mnt/webdav 0755 root root -"
  ];

  # WebDAV mount with automount (mounts on access, doesn't block boot)
  fileSystems."/mnt/webdav" = {
    device = "https://files.pkosel.dev";
    fsType = "davfs";
    options = [
      "noauto" # Don't mount at boot
      "x-systemd.automount" # Mount on access
      "x-systemd.idle-timeout=300" # Unmount after 5 min idle (optional)
      "_netdev" # Network device, wait for network
      "uid=1000" # Owner: philipp
      "gid=100" # Group: users
    ];
  };
}
