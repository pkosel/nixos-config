{ ... }:

{
  programs.ssh = {
    enable = true;

    # Let OpenSSH supply its own defaults instead of Home Manager's legacy preset.
    enableDefaultConfig = false;

    # SSH uses the first obtained value, so local settings take precedence.
    includes = [ "config.local" ];

    settings = {
      bridget = {
        HostName = "46.225.15.126";
        User = "root";
        StrictHostKeyChecking = "yes";
      };

      "*" = {
        ControlMaster = "auto";
        ControlPath = "~/.ssh/master-%C";
        # A short-lived master limits stale connections after laptop suspend.
        ControlPersist = "1m";
      };
    };
  };
}
