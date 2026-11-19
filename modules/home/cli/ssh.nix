{ ... }:

{
  programs.ssh = {
    enable = true;

    # Let OpenSSH supply its own defaults instead of Home Manager's legacy preset.
    enableDefaultConfig = false;

    # SSH uses the first obtained value, so local settings take precedence.
    includes = [ "config.local" ];

    settings = {
      "bridget papra-inbox" = {
        HostName = "100.79.152.81";
        # Keep verifying the existing OpenSSH host key after switching addresses.
        HostKeyAlias = "46.225.15.126";
        StrictHostKeyChecking = "yes";
      };
      bridget.User = "root";

      "*" = {
        ControlMaster = "auto";
        ControlPath = "~/.ssh/master-%C";
        # A short-lived master limits stale connections after laptop suspend.
        ControlPersist = "1m";
      };
    };
  };
}
