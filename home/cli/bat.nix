{ theme, ... }:

{
  programs.bat = {
    enable = true;
    config.theme = theme.bat;
  };
}
