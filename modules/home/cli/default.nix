{ ... }:

{
  imports = [
    ./delta.nix
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./fzf.nix
    ./ghostty.nix
    ./git.nix
    ./mdcat.nix
    ./pi
    ./ripgrep.nix
    ./ssh.nix
    ./starship.nix
    ./tealdeer.nix
    ./tmux.nix
    ./zoxide.nix
  ];

  programs.bat.enable = true;
}
