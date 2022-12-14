{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
    keepassxc
    zotero
    obsidian
    tree
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

  home.stateVersion = "22.11";
}
