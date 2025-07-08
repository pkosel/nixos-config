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

  # programs & packages
  home.packages = with pkgs; [
    # Development tools
    claude-code # AI coding assistant
    gcc # GNU Compiler Collection

    # Privacy & security
    bitwarden # Password manager
    mullvad-vpn # VPN client

    # Terminal utilities
    fd # Fast file finder
    jq # JSON processor
    sd # String replacement tool
    tree # Directory tree viewer

    # Research & productivity
    zotero # Reference management
    libreoffice # Office suite

    # Communication
    signal-desktop # Secure messaging

    # Media & entertainment
    calibre # E-book management
    foliate # E-book reader
    celluloid # Video player (MPV frontend)

    # German ID card software
    ausweisapp # Official German ID card application
  ];

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

  home.username = "philipp";
  home.homeDirectory = "/home/philipp";

  home.stateVersion = "25.05";
}
