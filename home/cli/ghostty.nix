{ theme, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Fira Code";
      theme = theme.ghostty;
    };
  };
}
