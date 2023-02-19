{ config, pkgs, ... }:
{
  home.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
    ];
  };

  home.file."./.config/nvim" = { source = ./.; recursive = true; };
}
