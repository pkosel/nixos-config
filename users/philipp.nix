{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../home/cli/starship.nix
    ../home/desktop
    ../home/firefox
    ../home/editors
  ];

  # System packages
  home.packages = with pkgs; [
    # Development tools
    claude-code
    gcc

    # Privacy & security
    bitwarden-desktop
    mullvad-vpn

    # Terminal utilities
    eza
    fd
    fzf
    jq
    mdcat
    ripgrep
    sd
    tree

    # Research & productivity
    anki
    markdown-anki-decks
    zotero
    libreoffice

    # Communication
    signal-desktop

    # Media & entertainment
    calibre
    foliate
    # celluloid
    spot

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
    settings = {
      user = {
        name = "Philipp Kosel";
        email = "pkosel@fastmail.com";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Obsidian configuration
  programs.obsidian = {
    enable = true;
    vaults."Documents/Vault".enable = true;
  };

  # Home Manager configuration
  programs.home-manager.enable = true;

  home.username = "philipp";
  home.homeDirectory = "/home/philipp";

  home.stateVersion = "25.11";
}
