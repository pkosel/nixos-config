{ pkgs, ... }:

{
  # Available to every module below as the `theme` argument.
  _module.args.theme = import ../../modules/home-manager/theme.nix;

  imports = [
    ../../modules/home-manager/browsers
    ../../modules/home-manager/cli
    ../../modules/home-manager/desktop
    ../../modules/home-manager/editors
    ../../modules/home-manager/obsidian.nix
  ];

  # User packages. Anything with its own configuration lives under modules/home-manager/.
  home.packages = with pkgs; [
    # Development
    claude-code
    pi

    # uv provides uvx, which pi uses to run the mcp-nixos server.
    uv

    # nvd diffs two generations so a rebuild shows what changed.
    nvd

    # sd, fd and jq have no defaults worth a module.
    fd
    jq
    sd

    # Security and privacy
    bitwarden-desktop
    proton-pass

    # Communication
    signal-desktop

    # Productivity
    anki
    libreoffice
    markdown-anki-decks
    todoist-electron

    # Research
    zotero

    # Entertainment
    calibre
    foliate
    newsflash
    spot
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
