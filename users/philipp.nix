{ pkgs, ... }:

{
  imports = [
    ../home/cli
    ../home/desktop
    ../home/editors
    ../home/firefox/firefox.nix
    ../home/obsidian.nix
  ];

  # User packages. Anything with configuration of its own lives in a module
  # under home/ instead.
  home.packages = with pkgs; [
    # Development tools
    claude-code
    gcc

    # Privacy & security
    bitwarden-desktop

    # Terminal utilities
    eza
    fd
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

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
