{ ... }:

{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      # ANSI colors follow the terminal palette.
      syntax-theme = "ansi";
      line-numbers = true;
      navigate = true;
    };
  };
}
