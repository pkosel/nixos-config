{ ... }:

{
  imports = [
    ./bat.nix
    ./delta.nix
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./fzf.nix
    ./ghostty.nix
    ./git.nix
    ./pi
    ./ripgrep.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./zoxide.nix
  ];

  programs.tealdeer.enable = true;
}
