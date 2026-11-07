{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/audio.nix
    ../../modules/system/ausweisapp.nix
    ../../modules/system/desktop
    ../../modules/system/fonts.nix
    ../../modules/system/nix-ld.nix
    ../../modules/system/nix.nix
    ../../modules/system/nixpkgs.nix
    ../../modules/system/printing.nix
    ../../modules/system/virtualization/docker.nix
    ../../modules/system/vpn.nix
    ../../modules/system/webdav.nix
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
  console.useXkbConfig = true;
  services.xserver.xkb.layout = "eu";

  users.users.philipp = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };

  services = {
    fwupd.enable = true;
    thermald.enable = true;
  };

  programs = {
    fish.enable = true;
    vim = {
      enable = true;
      defaultEditor = true;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    dnsutils
    wget
    unzip
    zip
    file
    htop
    lsof
    ncdu
    pciutils
    usbutils
  ];

  system.stateVersion = "25.11";
}
