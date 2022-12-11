{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    keepassxc
    firefox
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.git = {
    enable = true;
    userName = "Philipp Kosel";
    userEmail = "pkosel@fastmail.com";
  };

  gtk.enable = true;
  gtk.theme.name = "Adwaita-dark";
  gtk.gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = true;
  };

  home.stateVersion = "22.11";
}
