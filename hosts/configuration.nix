{ config, pkgs, ... }:

{
  imports = [
    ../modules/desktop/gnome.nix
  ];

  # Localization settings
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_TIME = "de_DE.UTF-8";
  i18n.extraLocaleSettings.LC_MONETARY = "de_DE.UTF-8";

  # Set timezone
  time.timeZone = "Europe/Berlin";

  # System wide packages
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable OpenSSH daemon
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  # Allow firewall TCP ports
  networking.firewall.allowedTCPPorts = [ 22 80 ];

  # Add user
  users.users.philipp = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ];
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "22.11";
}
