{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../system/nix.nix
    ../../system/nixpkgs.nix
    ../../system/audio.nix
    ../../system/desktop
    ../../system/virtualization/docker.nix
    ../../system/vpn.nix
    ../../system/printing.nix
    ../../system/fonts.nix
  ];

  # Boot
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # /boot is a 512M ESP; unlimited entries fill it up.
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    # /tmp lives on the root filesystem, so nothing clears it otherwise.
    tmp.cleanOnBoot = true;
  };

  networking.hostName = "frieda";

  # Localization
  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
    };
  };
  # The system keyboard layout, despite the option path — nothing here needs an
  # X server. It reaches GNOME via /etc/X11/xorg.conf.d/00-keyboard.conf and
  # systemd-localed, and ckbcomp derives the tty keymap from it below.
  services.xserver.xkb.layout = "eu";
  console.useXkbConfig = true;

  # Users
  users.users.philipp = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "docker"
      "davfs2"
    ];
  };

  # Programs
  programs.fish.enable = true;
  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };
  programs.vim = {
    enable = true;
    # Point EDITOR at the editor that is actually installed system-wide.
    # Root contexts (visudo, systemctl edit) reset the environment, so they
    # never see the nvim that home-manager exports.
    defaultEditor = true;
  };
  # No programs.ssh.startAgent: GNOME ships gcr-ssh-agent, which already owns
  # SSH_AUTH_SOCK and holds the key. OpenSSH's agent would only add a second,
  # keyless one.

  # Services
  services.fwupd.enable = true;
  services.thermald.enable = true;
  services.davfs2.enable = true;

  # WebDAV share, mounted on first access.
  systemd.tmpfiles.rules = [
    "d /mnt/webdav 0755 root root -"
  ];
  fileSystems."/mnt/webdav" = {
    device = "https://files.pkosel.dev";
    fsType = "davfs";
    # Automount, so an unreachable share does not hold up boot on _netdev.
    # uid/gid by name survive a uid change; philipp's own uid cannot be
    # referenced here, isNormalUser allocates it at activation so it reads null.
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=300"
      "_netdev"
      "uid=philipp"
      "gid=users"
    ];
  };

  # System packages — user-facing tools belong in users/philipp.nix.
  # vim is installed by programs.vim above.
  environment.systemPackages = with pkgs; [
    # Version control
    git

    # Network tools
    curl
    dnsutils
    wget

    # Archives
    unzip
    zip

    # System utilities
    file
    htop
    lsof
    ncdu
    pciutils
    usbutils
  ];

  system.stateVersion = "25.11";
}
