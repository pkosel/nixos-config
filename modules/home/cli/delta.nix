{ ... }:

{
  programs.delta = {
    enable = true;
    # Explicit since 26.05; home-manager deprecated inferring it from git.enable.
    enableGitIntegration = true;

    options = {
      # ANSI colors follow the terminal palette in both light and dark modes.
      syntax-theme = "ansi";
      line-numbers = true;
      navigate = true;
    };
  };
}
