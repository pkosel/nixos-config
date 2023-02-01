{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  vimLua = lua: ''
    lua << EOF
    ${lua}
    EOF
  '';
in {
  imports = [
    ./features/desktop
    ./features/firefox.nix
  ];

  #nixpkgs = {
  #  overlays = [inputs.nur.overlay outputs.overlays.additions];
  #  config = {
  #    allowUnfree = true;
  #  };
  #};

  home = {
    username = "philipp";
    homeDirectory = "/home/philipp";
  };

  programs.home-manager.enable = true;

  # programs & packages
  home.packages = with pkgs; [
    keepassxc
    zotero

    bat
    fd
    fzf
    jq
    ripgrep
    tree

    ledger
    pandoc

    eduvpn-client

    texlive.combined.scheme-full
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
    settings = {
      theme = "tokyo-night";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      vimtex
    ];
    extraConfig = with builtins;
      vimLua (pkgs.lib.foldl (r: f: r + "\n" + readFile f) "" [
        ./features/nvim/treesitter.lua
      ]);
  };

  programs.git = {
    enable = true;
    userName = "Philipp Kosel";
    userEmail = "pkosel@fastmail.com";
  };

  home.stateVersion = "22.11";
}
