{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../system/desktop
    ../../system/services/syncthing.nix
    ../../system/services/davfs2.nix
    ../../system/virtualization/libvirt.nix
    # ../../system/virtualization/podman.nix
    ../../system/virtualization/docker.nix
    ../../system/vpn.nix
    ../../system/printing.nix
    ../../system/fonts.nix
  ];

  # Nix
  nixpkgs.config = {
    allowUnfree = true;

    # bitwarden-desktop still builds against an EOL electron.
    permittedInsecurePackages = [
      "electron-39.8.10"
    ];
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      # Without this the collector only drops unreachable paths, and every
      # generation is a GC root — so nothing is ever actually freed.
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Keep build inputs around so `nix develop` shells survive a GC run.
      keep-outputs = true;
      keep-derivations = true;
    };
  };

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

  # Networking
  networking = {
    hostName = "frieda";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  # Localization
  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
    };
  };
  # Match the console to the graphical layout (eu, set in system/desktop/x11.nix).
  console.useXkbConfig = true;

  # Audio
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Users
  users.users.philipp = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  # Programs
  programs.fish.enable = true;
  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };
  # programs.ssh.startAgent = true;

  # Services
  services.fwupd.enable = true;
  services.thermald.enable = true;

  # System packages — user-facing tools belong in users/philipp.nix.
  environment.systemPackages = with pkgs; [
    # Editors
    vim

    # Version control
    git

    # Network tools
    curl
    dnsutils
    wget

    # System utilities
    file
    htop
    pciutils
    unzip
    usbutils
  ];

  system.stateVersion = "25.11";
}
