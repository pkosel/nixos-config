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
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
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

  # System packages — user-facing tools belong in users/philipp.nix.
  environment.systemPackages = with pkgs; [
    # Editors
    vim

    # Version control
    git

    # Network tools
    curl
    wget

    # System utilities
    htop
    unzip
  ];

  system.stateVersion = "25.11";
}
