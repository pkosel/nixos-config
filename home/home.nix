{ config, pkgs, ... }:

{
  imports = [
    ./features/cli/starship.nix
    ./features/desktop
    ./features/firefox.nix
    ./features/editors
  ];

  users.users.philipp.initialPassword = "password";

  home = {
    username = "philipp";
    homeDirectory = "/home/philipp";
  };

  # programs & packages
  home.packages = with pkgs; [
    cachix

    # dev
    gcc

    # privacy & security
    bitwarden
    mullvad-vpn

    # terminal
    # bat
    fd
    # fzf
    jq
    # ripgrep
    sd
    tree

    # research
    zotero

    # office
    libreoffice

    # social
    signal-desktop

    # entertainment
    calibre
    foliate
    celluloid
  ];

  programs.kitty = {
    enable = true;
    settings = {
      # https://github.com/kovidgoyal/kitty/issues/3284
      linux_display_server = "x11";
      remember_window_size = "no";
      # initial_window_width = "960";
      # initial_window_height = "540";
      tab_bar_style = "powerline";
    };
    font.package = pkgs.fira-code;
    font.name = "Fira Code";
    theme = "Gruvbox Material Dark Medium";
  };

  programs.fish = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Philipp Kosel";
    userEmail = "170943+pkosel@users.noreply.github.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "gruvbox-dark";
    };
  };

  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
}
