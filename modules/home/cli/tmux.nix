{ ... }:

{
  programs.tmux = {
    enable = true;
    # Pi needs extended-key reporting to distinguish modified Enter keys.
    extraConfig = ''
      set -g extended-keys on
      set -g extended-keys-format csi-u
    '';
  };
}
