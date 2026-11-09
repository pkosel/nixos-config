{ config, ... }:

{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      # Delta reads the same theme cache as bat.
      syntax-theme = config.programs.bat.config.theme;
      line-numbers = true;
      navigate = true;
    };
  };
}
