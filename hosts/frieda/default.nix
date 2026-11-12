{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  partitions = config.disko.devices.disk.main.content.partitions;
in

{
  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
    ./disk-config.nix

    ../../modules/services/printing.nix
    ../../modules/system/webdav.nix
    ../../modules/system/ausweisapp.nix
    ../../modules/system/brave.nix
    ../../modules/system/docker.nix
    ../../modules/system/fonts.nix
    ../../modules/system/gnome.nix
    ../../modules/system/mullvad-vpn.nix
    ../../modules/system/nix-ld.nix
    ../../modules/system/nix.nix
    ../../modules/system/nixpkgs.nix
  ];

  # Replace generated hardware definitions with disko's settings; merging the
  # swap lists would add duplicate entries for the same partition.
  # Remove these overrides and the partitions binding once hardware configuration
  # is regenerated with nixos-generate-config --no-filesystems.
  fileSystems."/" = lib.mkForce (lib.head partitions.nixos.content._config).fileSystems."/";
  fileSystems."/boot" = lib.mkForce (lib.head partitions.boot.content._config).fileSystems."/boot";
  swapDevices = lib.mkForce (lib.head partitions.swap.content._config).swapDevices;

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # The small ESP cannot hold unlimited boot entries.
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
