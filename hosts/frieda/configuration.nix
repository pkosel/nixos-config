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

  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
    };
  };
  # The tty keymap is derived (via ckbcomp) from the keyboard layout below.
  console.useXkbConfig = true;

  users.users.philipp = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "docker"
      "davfs2"
    ];
  };

  programs = {
    fish.enable = true;
    ausweisapp = {
      enable = true;
      openFirewall = true;
    };
    vim = {
      enable = true;
      # Point EDITOR at the editor that is actually installed system-wide.
      # Root contexts (visudo, systemctl edit) reset the environment, so they
      # never see the nvim that home-manager exports.
      defaultEditor = true;
    };

    # uvx downloads its own CPython, which is dynamically linked for FHS Linux.
    # nix-ld provides ld-linux and a linker lookup path so such binaries run.
    nix-ld = {
      enable = true;
      # Start with the minimum shared libraries every FHS binary expects.
      # When a tool fails with a missing .so, add its package here.
      libraries = with pkgs; [
        glibc
        zlib
      ];
    };

    # programs.ssh.startAgent stays off: GNOME ships gcr-ssh-agent, which already
    # owns SSH_AUTH_SOCK and holds the key. OpenSSH's agent would only add a
    # second, keyless one.
  };

  services = {
    # Sets the system keyboard layout despite the option path; nothing here needs
    # an X server. GNOME reads it from /etc/X11/xorg.conf.d/00-keyboard.conf and
    # systemd-localed.
    xserver.xkb.layout = "eu";
    fwupd.enable = true;
    thermald.enable = true;
    davfs2.enable = true;
  };

  # The WebDAV share is mounted on first access.
  systemd.tmpfiles.rules = [
    "d /mnt/webdav 0755 root root -"
  ];
  fileSystems."/mnt/webdav" = {
    device = "https://files.pkosel.dev";
    fsType = "davfs";
    # The automount with _netdev keeps an unreachable share from holding up boot.
    # uid and gid are given by name so they survive a uid change. philipp's own
    # uid cannot be referenced here: isNormalUser allocates it at activation, so
    # it reads null.
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=300"
      "_netdev"
      "uid=philipp"
      "gid=users"
    ];
  };

  # User-facing tools belong in users/philipp.nix. vim comes from programs.vim above.
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
