{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../../home/modules/cli/starship.nix
    ../../home/modules/desktop
    ../../home/modules/firefox.nix
    ../../home/modules/editors
  ];

  # System packages
  home.packages = with pkgs; [
    # Development tools
    claude-code
    gcc

    # Privacy & security
    bitwarden
    mullvad-vpn

    # Terminal utilities
    fd
    jq
    sd
    tree

    # Research & productivity
    zotero
    libreoffice

    # Communication
    signal-desktop

    # Media & entertainment
    calibre
    foliate
    celluloid

    # German ID card software
    ausweisapp
  ];

  # Terminal configuration
  programs.kitty = {
    enable = true;
    settings = {
      # Workaround for Wayland issues: https://github.com/kovidgoyal/kitty/issues/3284
      linux_display_server = "x11";
      remember_window_size = "no";
      tab_bar_style = "powerline";
    };
    font = {
      package = pkgs.fira-code;
      name = "Fira Code";
    };
    themeFile = "gruvbox-dark";
  };

  programs.fish = {
    enable = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "gruvbox-dark";
    };
  };

  # Development tools
  programs.git = {
    enable = true;
    userName = "Philipp Kosel";
    userEmail = "pkosel@fastmail.com";
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

  # Home Manager configuration
  programs.home-manager.enable = true;

  home.username = "philipp";
  home.homeDirectory = "/home/philipp";

  home.stateVersion = "25.05";
}
