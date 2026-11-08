{ ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";

    # Pi needs extended-key reporting to distinguish modified Enter keys.
    extraConfig = ''
      set -g extended-keys on
      set -g extended-keys-format csi-u
    '';
  };
}
