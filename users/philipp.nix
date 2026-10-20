{ pkgs, ... }:

{
  # Available to every module below as the `theme` argument.
  _module.args.theme = import ../home/theme.nix;

  imports = [
    ../home/browsers
    ../home/cli
    ../home/desktop
    ../home/editors
    ../home/obsidian.nix
  ];

  # User packages. Anything with configuration of its own lives in a module
  # under home/ instead.
  home.packages = with pkgs; [
    # Development
    claude-code
    gcc
    pi

    # uv provides uvx, which pi uses to run the mcp-nixos server in .pi/mcp.json.
    uv

    # Nix tooling. nvd diffs two generations, so a rebuild says what actually
    # changed.
    nvd

    # Terminal utilities, none of them worth a module: sd has none, fd's
    # defaults already do the right thing, jq's only sets output colours.
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
