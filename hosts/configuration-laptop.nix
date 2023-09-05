{ config, pkgs, inputs, self, ... }: {
  imports = [
    ./hardware-configuration-laptop.nix
    ./features/desktop
    ./features/virtualization/libvirt.nix
    ./features/vpn.nix
  ];

  nixpkgs = {
    overlays = [ inputs.nur.overlay self.overlays.additions ];
    config = { allowUnfree = true; };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
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

  networking.hostName = "frida";

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services = {
    printing.enable = true;
    avahi.enable = true;
    avahi.nssmdns = true;
    avahi.openFirewall = true;
  };

  users.users.philipp = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [ vim wget ];

  system.stateVersion = "23.05";
}