{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    ./features/desktop
    ./features/firefox.nix
    ./features/cli/starship.nix
    ./features/nvim
  ];

  nixpkgs = {
    overlays = [ inputs.nur.overlay outputs.overlays.additions ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "philipp";
    homeDirectory = "/home/philipp";
  };

  programs.home-manager.enable = true;

  # programs & packages
  home.packages = with pkgs; [
    # misc
    eduvpn-client
    keepassxc

    # terminal
    bat
    fd
    fzf
    jq
    ripgrep
    tree

    # dev
    gcc

    # research
    zotero
    obsidian

    # office
    texlive.combined.scheme-full
    pandoc

    ledger
  ];

  programs.kitty = {
    enable = true;
    settings = {
      # https://github.com/kovidgoyal/kitty/issues/3284
      linux_display_server = "x11";
      remember_window_size = "no";
      initial_window_width = "960";
      initial_window_height = "540";
      tab_bar_style = "powerline";
    };
    font.package = pkgs.jetbrains-mono;
    font.name = "JetBrains Mono";
    theme = "Tokyo Night";
  };

  programs.fish = {
    enable = true;
    #shellAliases = {
    #  ssh = "kitty +kitten ssh";
    #};
  };

  programs.zellij = {
    enable = true;
    settings = { theme = "tokyo-night"; };
  };

  programs.git = {
    enable = true;
    userName = "Philipp Kosel";
    userEmail = "pkosel@fastmail.com";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.stateVersion = "22.11";
}
