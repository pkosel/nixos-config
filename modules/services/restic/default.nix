{
  config,
  lib,
  pkgs,
  ...
}:

let
  backupParent = "/var/lib/backups";
  backupDirectory = "${backupParent}/bridget";
  backupHost = "u716577-sub1.your-storagebox.de";
  capture = pkgs.writeShellScript "bridget-backup-capture" (builtins.readFile ./capture.sh);
in

{
  # Verified against https://docs.hetzner.com/storage/storage-box/general/#ssh-host-keys.
  programs.ssh.knownHosts.storagebox = {
    hostNames = [ "[${backupHost}]:23" ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICf9svRenC/PLKIL9nk6K/pxQgoiFC41wTNvoIncOxs";
  };

  services.restic.backups.bridget = {
    repository = "sftp://u716577-sub1@${backupHost}:23/./restic";
    passwordFile = config.sops.secrets.restic-password.path;
    extraOptions = [
      "sftp.args='-i ${config.sops.secrets.restic-ssh-key.path} -o IdentitiesOnly=yes -o BatchMode=yes -o StrictHostKeyChecking=yes'"
    ];
    initialize = true;
    paths = [
      backupDirectory
      "/var/lib/sops-nix"
      "/etc/ssh"
    ];
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
    checkOpts = [ "--read-data-subset=10%" ];
    timerConfig = {
      OnCalendar = "03:00";
      RandomizedDelaySec = "15m";
      Persistent = true;
    };
    backupPrepareCommand = ''
      ${capture} prepare ${
        lib.escapeShellArgs [
          backupDirectory
          config.services.forgejo.stateDir
          "/var/lib/${config.systemd.services.authelia-main.serviceConfig.StateDirectory}"
          config.services.freshrss.dataDir
          "/var/lib/${config.systemd.services.papra.serviceConfig.StateDirectory}"
          "/srv/papra/inbox"
          "/var/lib/papra-sftp"
        ]
      }
    '';
    backupCleanupCommand = ''
      set -euo pipefail
      ${capture} cleanup ${lib.escapeShellArg backupDirectory}
      if [[ $SERVICE_RESULT == success && -f "$RUNTIME_DIRECTORY/backup-complete" ]]; then
        if ! reply=$(
          ${lib.getExe pkgs.curl} --disable \
            --config ${lib.escapeShellArg config.sops.secrets.restic-healthcheck-curl.path} \
            --proto '=https' --fail --silent --max-time 10 2>/dev/null
        ) || [[ $reply != OK ]]; then
          echo 'Bridget backup succeeded, but Healthchecks did not acknowledge the ping.' >&2
        fi
      fi
    '';
  };

  # Local staging is not encrypted by Restic, even when the repository is.
  systemd.tmpfiles.rules = [ "d ${backupParent} 0700 root root -" ];
  systemd.services.restic-backups-bridget = {
    path = [ pkgs.rsync ];
    # The oneshot reaches postStart only after backup, prune and check succeed.
    # The cleanup hook also runs on failure, so require this per-run marker.
    postStart = ''
      touch "$RUNTIME_DIRECTORY/backup-complete"
    '';
  };
}
