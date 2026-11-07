{ pkgs, ... }:

{
  _module.args.theme = import ../../modules/home/theme.nix;

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
    nvd
    sd
    unzip
    zip

    # Applications
    anki
    bitwarden-desktop
    calibre
    foliate
    libreoffice
    markdown-anki-decks
    newsflash
    proton-pass
    signal-desktop
    spot
    todoist-electron
    zotero
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
