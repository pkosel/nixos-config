{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/nix.nix
    ../../modules/system/nixpkgs.nix
    ../../modules/system/audio.nix
    ../../modules/system/desktop
    ../../modules/system/virtualization/docker.nix
    ../../modules/system/vpn.nix
    ../../modules/system/printing.nix
    ../../modules/system/fonts.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # /boot is a 512M ESP; unlimited entries fill it up.
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    # Clear disk-backed /tmp at every boot so temporary files do not persist
    # across reboots while waiting for systemd's age-based cleanup.
    tmp.cleanOnBoot = true;
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_HL_L2350DW";
        description = "Brother HL-L2350DW";
        location = "Home";
        deviceUri = "ipp://192.168.2.30:631/ipp/print";
        # IPP Everywhere needs the printer reachable when ensure-printers runs,
        # for example during initial activation or boot, not during the build.
        model = "everywhere";
      }
    ];
    ensureDefaultPrinter = "Brother_HL_L2350DW";
  };

  networking.hostName = "frieda";

  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
    };
  };
  # tty keymap via ckbcomp, GNOME via /etc/X11/xorg.conf.d.
  console.useXkbConfig = true;
  services.xserver.xkb.layout = "eu";

  users.users.philipp = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "docker"
      "davfs2"
    ];
  };

  services = {
    fwupd.enable = true;
    thermald.enable = true;
    davfs2.enable = true;
  };

  # The OpenSSH agent is disabled by default; GNOME's gcr-ssh-agent provides SSH_AUTH_SOCK.
  programs = {
    fish.enable = true;
    ausweisapp = {
      enable = true;
      openFirewall = true;
    };
    vim = {
      enable = true;
      # Root shells reset the environment, so they never see the nvim that
      # home-manager exports.
      defaultEditor = true;
    };

    # uvx downloads dynamically linked CPython for FHS Linux.
    # nix-ld provides the linker and lookup path to run such binaries.
    nix-ld = {
      enable = true;
      # Add packages here when a tool fails with a missing .so.
      libraries = with pkgs; [
        glibc
        zlib
      ];
    };
  };

  # The WebDAV share is mounted on first access.
  systemd.tmpfiles.rules = [
    "d /mnt/webdav 0755 root root -"
  ];
  fileSystems."/mnt/webdav" = {
    device = "https://files.pkosel.dev";
    fsType = "davfs";
    # Automounting defers access to the share; _netdev gives it network-mount ordering.
    # Names keep ownership stable when the user's allocated UID changes.
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=300"
      "_netdev"
      "uid=philipp"
      "gid=users"
    ];
  };

  # System-wide tools, available before home-manager activates and in root shells.
  environment.systemPackages = with pkgs; [
    # Version control
    git

    # Networking
    curl
    dnsutils
    wget

    # Archives
    unzip
    zip

    # System and hardware
    file
    htop
    lsof
    ncdu
    pciutils
    usbutils
  ];

  system.stateVersion = "25.11";
}
