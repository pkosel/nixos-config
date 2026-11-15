{ config, pkgs, ... }:

let
  runnerConfig = (pkgs.formats.yaml { }).generate "forgejo-runner.yaml" {
    runner = {
      capacity = 1;
      timeout = "2h";
      shutdown_timeout = "30s";
      labels = [ "native:host" ];
    };
    cache.enabled = false;
  };
in

{
  environment = {
    systemPackages = [ pkgs.forgejo-runner ];
    etc."forgejo-runner/config.yaml".source = runnerConfig;
  };

  users = {
    groups.forgejo-runner = { };
    users.forgejo-runner = {
      isSystemUser = true;
      group = "forgejo-runner";
      home = "/var/lib/forgejo-runner";
    };
  };

  nix.settings = {
    allowed-users = [
      "root"
      "forgejo-runner"
    ];
    # Pin the upstream sandbox default: native CI must not build unsandboxed.
    sandbox = true;
    sandbox-fallback = false;
    max-jobs = 1;
    cores = 2;
  };

  # Builds run in the daemon, not the runner's cgroup. This shared budget also
  # covers administrator-initiated daemon builds on bridget.
  systemd.slices.nix-builds.sliceConfig = {
    CPUQuota = "200%";
    MemoryMax = "4G";
    MemorySwapMax = 0;
  };
  systemd.services.nix-daemon.serviceConfig.Slice = "nix-builds.slice";

  # The pinned runner module passes registration tokens in argv. Register once
  # interactively instead; .runner contains the credentials outside the Nix store.
  systemd.services.forgejo-runner = {
    description = "Native Forgejo CI runner for pkosel/nixos-config";
    wantedBy = [ "multi-user.target" ];
    wants = [
      "network-online.target"
      "nix-daemon.socket"
    ];
    after = [
      "network-online.target"
      "forgejo.service"
      "nix-daemon.socket"
    ];
    unitConfig.ConditionPathExists = "/var/lib/forgejo-runner/.runner";
    environment = {
      HOME = "/var/lib/forgejo-runner";
      NIX_REMOTE = "daemon";
      SSL_CERT_FILE = config.security.pki.caBundle;
    };
    path = with pkgs; [
      bash
      coreutils
      curl
      findutils
      gawk
      gitMinimal
      gnused
      gnutar
      gzip
      config.nix.package
      nodejs_24
    ];
    serviceConfig = {
      User = "forgejo-runner";
      Group = "forgejo-runner";
      Slice = "nix-builds.slice";
      StateDirectory = "forgejo-runner";
      StateDirectoryMode = "0700";
      WorkingDirectory = "/var/lib/forgejo-runner";
      ExecStart = "${pkgs.forgejo-runner}/bin/forgejo-runner --config ${runnerConfig} daemon";
      Restart = "on-failure";
      RestartSec = "5s";
      TimeoutStopSec = "45s";
      UMask = "0077";
      NoNewPrivileges = true;
      CapabilityBoundingSet = "";
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectProc = "invisible";
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      RestrictSUIDSGID = true;
      RestrictRealtime = true;
      LockPersonality = true;
      # Hide both SOPS's public symlinks and their backing generation directories.
      # Optional paths allow the same restrictions before services create state.
      InaccessiblePaths = [
        "-/run/secrets"
        "-/run/secrets.d"
        "-/run/secrets-for-users"
        "-/run/secrets-for-users.d"
        "-/run/credentials"
        "-/run/docker.sock"
        "-/run/podman"
        "-/etc/ssh"
        "-/var/lib/sops-nix"
        "-/var/lib/private"
        "-/var/lib/forgejo"
        "-/var/lib/authelia-main"
        "-/var/lib/freshrss"
        "-/var/lib/backups"
      ];
    };
  };

  systemd.tmpfiles.rules = [ "d /var/lib/forgejo-runner 0700 forgejo-runner forgejo-runner -" ];
}
