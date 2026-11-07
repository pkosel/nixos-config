{ ... }:

{
  programs.delta = {
    enable = true;
    # Explicit since 26.05; home-manager deprecated inferring it from git.enable.
    enableGitIntegration = true;

    options = {
      # ANSI colors follow the terminal palette.
      syntax-theme = "ansi";
      line-numbers = true;
      navigate = true;
    };
  };
}
