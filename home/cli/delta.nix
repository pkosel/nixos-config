{ theme, ... }:

{
  programs.delta = {
    enable = true;
    # Explicit since 26.05; home-manager deprecated inferring it from git.enable.
    enableGitIntegration = true;

    options = {
      # Same theme as bat, which shares delta's syntax highlighter.
      syntax-theme = theme.bat;
      line-numbers = true;
      # n and N jump between files in a long diff.
      navigate = true;
    };
  };
}
