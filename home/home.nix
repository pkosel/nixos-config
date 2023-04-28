{ inputs, outputs, lib, config, pkgs, ... }:

let
  pkgs-stable = import inputs.nixpkgs-stable { system = pkgs.system; };
in
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
    # privacy & security
    mullvad-vpn

    # terminal
    # bat
    fd
    fzf
    jq
    ripgrep
    sd
    tree

    # dev
    gcc

    # research
    zotero
    obsidian

    # office
    texlive.combined.scheme-small
    libreoffice
    pandoc

    ledger

    # entertainment
    celluloid
  ];

  programs.kitty = {
    enable = true;
    settings = {
      # https://github.com/kovidgoyal/kitty/issues/3284
      linux_display_server = "x11";
      remember_window_size = "no";
      # initial_window_width = "960";
      # initial_window_height = "540";
      tab_bar_style = "powerline";
    };
    font.package = pkgs.jetbrains-mono;
    font.name = "JetBrains Mono";
    theme = "Gruvbox Material Dark Medium";
  };

  programs.fish = {
    enable = true;
  };

  programs.zellij = {
    enable = true;
    package = pkgs-stable.zellij;
    settings = {
      theme = "gruvbox-dark";
      themes.gruvbox-dark = {
        fg = [ 213 196 161 ];
        bg = [ 40 40 40 ];
        black = [ 60 56 54 ];
        red = [ 204 36 29 ];
        green = [ 152 151 26 ];
        yellow = [ 215 153 33 ];
        blue = [ 69 133 136 ];
        magenta = [ 177 98 134 ];
        cyan = [ 104 157 106 ];
        white = [ 251 241 199 ];
        orange = [ 214 93 14 ];
      };
    };
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

  home.stateVersion = "22.11";
}
