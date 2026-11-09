{ ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";

    # Pi needs extended-key reporting to distinguish modified Enter keys.
    extraConfig = ''
      set -g extended-keys on
      set -g extended-keys-format csi-u

      set -g status-style "fg=default,bg=default"
      set -g window-status-current-style "fg=cyan,bold"
      set -g pane-border-style "fg=brightblack"
      set -g pane-active-border-style "fg=cyan"
    '';
  };
}
