{ pkgs, ... }:

{
  imports = [
    ../../modules/home/browsers
    ../../modules/home/cli
    ../../modules/home/desktop
    ../../modules/home/editors
    ../../modules/home/obsidian.nix
  ];

  home.packages = with pkgs; [
    # Command-line tools
    btop
    fd
    gh
    jq
    mdcat
    nvd
    sd
    unzip
    wl-clipboard
    zip

    # Applications
    anki
    bitwarden-desktop
    calibre
    dconf-editor
    foliate
    gnome-tweaks
    libreoffice
    markdown-anki-decks
    newsflash
    proton-pass
    riff-client
    signal-desktop
    todoist-electron
    zotero
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
