{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./printing.nix
    ./webdav.nix

    ../../modules/system/ausweisapp.nix
    ../../modules/system/brave.nix
    ../../modules/system/docker.nix
    ../../modules/system/fonts.nix
    ../../modules/system/gnome.nix
    ../../modules/system/nix-ld.nix
    ../../modules/system/nix.nix
    ../../modules/system/nixpkgs.nix
    ../../modules/system/vpn.nix
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

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    # Keep curl available independently of NixOS's core package defaults.
    curl
    git
    vim
    wget
  ];

  system.stateVersion = "25.11";
}
