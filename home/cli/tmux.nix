{ ... }:

{
  programs.tmux = {
    enable = true;
    # Without extended keys tmux sends Shift+Enter and Ctrl+Enter as plain
    # Enter, so pi can't insert newlines. csi-u needs tmux 3.5+.
    extraConfig = ''
      set -g extended-keys on
      set -g extended-keys-format csi-u
    '';
  };
}
