{
  config,
  inputs,
  modulesPath,
  pkgs,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.disko.nixosModules.disko
    ./disk-config.nix

    ../../modules/services/traefik.nix
    ../../modules/services/authelia.nix
    ../../modules/services/forgejo.nix
    ../../modules/services/forgejo-runner.nix
    ../../modules/services/freshrss.nix
    ../../modules/services/papra.nix
    ../../modules/services/homepage.nix
    ../../modules/services/restic
    ../../modules/secrets.nix
    ../../modules/system/nix.nix
  ];

  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "sd_mod"
    ];
    loader.grub = {
      enable = true;
      efiSupport = true;
      # Use the EFI fallback path so boot does not depend on firmware variables.
      efiInstallAsRemovable = true;
      configurationLimit = 10;
    };
    tmp.cleanOnBoot = true;
  };

  networking = {
    hostName = "bridget";
    domain = "pkosel.dev";
    useNetworkd = true;
    firewall = {
      allowedTCPPorts = [
        80
        443
        config.services.forgejo.settings.server.SSH_PORT
      ];
      interfaces.${config.services.tailscale.interfaceName}.allowedTCPPorts =
        config.services.openssh.ports;
    };
  };

  systemd.network.networks."10-public" = {
    matchConfig.Driver = "virtio_net";
    networkConfig = {
      DHCP = "ipv4";
      Address = "2a01:4f8:1c19:c746::1/64";
      IPv6AcceptRA = false;
    };
    routes = [ { Gateway = "fe80::1"; } ];
  };

  services.tailscale = {
    enable = true;
    disableTaildrop = true;
  };

  services.openssh = {
    enable = true;
    # Administrative SSH and the SFTP jail share this tailnet-only listener.
    openFirewall = false;
    settings = {
      # The Forgejo account must not also accept keys through the system sshd.
      DenyUsers = [ config.services.forgejo.user ];
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHSSLqnBtA6WHXds7TADlPvaUW13HGXyqCINYUgWmZ0c ph.kosel@proton.me"
  ];

  time.timeZone = "Europe/Berlin";
  environment.systemPackages = with pkgs; [
    ghostty.terminfo
    git
    vim
  ];
  system.stateVersion = "26.05";
}
