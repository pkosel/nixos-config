{ config, lib, ... }:

{
  programs.fzf = {
    enable = true;

    defaultOptions = [
      # Avoid the fixed 256-color palette on light terminals.
      "--color=16"
      # Do not follow flake build outputs into the Nix store.
      "--walker-skip=.git,node_modules,result"
    ];
  };

  # Home Manager's session variables are inherited; refresh options after rebuilds
  # without requiring a new login.
  programs.fish.interactiveShellInit = ''
    set -gx FZF_DEFAULT_OPTS ${lib.escapeShellArg config.home.sessionVariables.FZF_DEFAULT_OPTS}
  '';
}
