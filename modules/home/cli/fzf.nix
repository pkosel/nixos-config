{ config, lib, ... }:

{
  programs.fzf = {
    enable = true;

    # Do not follow flake build outputs into the Nix store.
    defaultOptions = [ "--walker-skip=.git,node_modules,result" ];
  };

  # Home Manager's session variables are inherited; refresh options after rebuilds
  # without requiring a new login.
  programs.fish.interactiveShellInit = ''
    set -gx FZF_DEFAULT_OPTS ${lib.escapeShellArg config.home.sessionVariables.FZF_DEFAULT_OPTS}
  '';
}
