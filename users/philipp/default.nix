{ pkgs, ... }:

{
  # Available to every module below as the `theme` argument.
  _module.args.theme = import ../../modules/home/theme.nix;

  imports = [
    ../../modules/home/browsers
    ../../modules/home/cli
    ../../modules/home/desktop
    ../../modules/home/editors
    ../../modules/home/obsidian.nix
  ];

  # User packages. Anything with its own configuration lives under modules/home/.
  home.packages = with pkgs; [
    # Development
    pi

    # uv provides uvx, which pi uses to run the mcp-nixos server.
    uv

    # nvd diffs two generations so a rebuild shows what changed.
    nvd

    # Git operations over SSH can use gcr-ssh-agent.
    gh

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
