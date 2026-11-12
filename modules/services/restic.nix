{ config, pkgs, ... }:

let
  backupDirectory = "/var/lib/backups/bridget";
  backupHost = "u716577-sub1.your-storagebox.de";
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
    # Copy stopped applications locally, then restart before the network upload.
    backupPrepareCommand = ''
      set -euo pipefail
      trap '${pkgs.systemd}/bin/systemctl start forgejo.service authelia-main.service' EXIT
      ${pkgs.systemd}/bin/systemctl stop forgejo.service authelia-main.service
      ${pkgs.coreutils}/bin/install -d -m 0700 ${backupDirectory}
      ${pkgs.rsync}/bin/rsync -a --delete ${config.services.forgejo.stateDir}/ ${backupDirectory}/forgejo/
      ${pkgs.rsync}/bin/rsync -a --delete /var/lib/authelia-main/ ${backupDirectory}/authelia-main/
    '';
    backupCleanupCommand = ''
      set -euo pipefail
      ${pkgs.coreutils}/bin/rm -rf -- ${backupDirectory}
    '';
  };
}
