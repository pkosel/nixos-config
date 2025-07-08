{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware.nix
    ../../modules/system/desktop
    ../../modules/system/services/syncthing.nix
    ../../modules/system/virtualization/libvirt.nix
    ../../modules/system/virtualization/podman.nix
    ../../modules/system/vpn.nix
    ../../modules/system/printing.nix
    ../../modules/system/fonts.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
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
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
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

  # Audio configuration using PipeWire (modern audio system)
  security.rtkit.enable = true; # RealtimeKit for better audio performance
  services.pulseaudio.enable = false; # Disable PulseAudio in favor of PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true; # ALSA compatibility
    alsa.support32Bit = true; # 32-bit application support
    pulse.enable = true; # PulseAudio compatibility layer
    jack.enable = true; # JACK compatibility for pro audio
  };

  users.users.philipp = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  system.stateVersion = "25.05";
}
