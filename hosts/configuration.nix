{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./desktop/gnome.nix
  ];

  # Use systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set hostname
  networking.hostName = "bridget";

  # Set timezone
  time.timeZone = "Europe/Berlin";

  # Localization settings
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_TIME = "de_DE.UTF-8";
  i18n.extraLocaleSettings.LC_MONETARY = "de_DE.UTF-8";

  # System wide packages
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Add user
  users.users.philipp = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ];
  };

  # Enable garbage collection
  nix.gc = {
    automatic = true;
    dates = "04:00";
    options = "--delete-older-than 30d";
  };

  # Optimise the store
  nix.settings.auto-optimise-store = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.stateVersion = "22.11";
}
