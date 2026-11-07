{ config, lib, ... }:

{
  programs.fzf = {
    # The module writes the fish key bindings (ctrl-r, ctrl-t, alt-c); the bare
    # package has none, so history search would stay plain readline.
    enable = true;

    # Preserve the walker's default exclusions and avoid scanning flake build outputs.
    defaultOptions = [ "--walker-skip=.git,node_modules,result" ];
  };

  # Home Manager loads session variables only once per login. Refresh these options
  # so newly opened Fish shells pick up rebuilt exclusions without a new login.
  programs.fish.interactiveShellInit = ''
    set -gx FZF_DEFAULT_OPTS ${lib.escapeShellArg config.home.sessionVariables.FZF_DEFAULT_OPTS}
  '';
}
