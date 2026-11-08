{ inputs, pkgs, ... }:

{
  imports = [ inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = true;
    # Only the CLI targets below may change; desktop appearance stays independent.
    autoEnable = false;
    polarity = "dark";

    # The pinned scheme collection has no dark Night Owl variant.
    # Palette source: https://github.com/sdras/night-owl-vscode-theme
    base16Scheme = {
      name = "Night Owl";
      author = "Sarah Drasner";
      base00 = "011627";
      base01 = "0b2942";
      base02 = "1d3b53";
      base03 = "637777";
      base04 = "5f7e97";
      base05 = "d6deeb";
      base06 = "e4f0fb";
      base07 = "ffffff";
      base08 = "ef5350";
      base09 = "f78c6c";
      base0A = "ffcb8b";
      base0B = "addb67";
      base0C = "7fdbca";
      base0D = "82aaff";
      base0E = "c792ea";
      base0F = "ecc48d";
    };

    fonts.monospace = {
      name = "Fira Code";
      package = pkgs.fira-code;
    };

    targets = {
      bat.enable = true;
      fish.enable = true;
      fzf.enable = true;
      ghostty.enable = true;
      starship.enable = true;
      tmux.enable = true;
    };
  };
}
