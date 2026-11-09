{ pkgs, ... }:

let
  themeName = "Night Owl";
in
{
  programs.bat = {
    enable = true;
    config.theme = themeName;
    themes.${themeName} = {
      # TextMate port linked from https://github.com/sdras/night-owl-vscode-theme.
      src = pkgs.fetchFromGitHub {
        owner = "batpigandme";
        repo = "night-owlish";
        rev = "0ad95279de701e13d933c63c102ac1e90ca8e4d5";
        hash = "sha256-GcTMqig639fJxWk91lXSiGHjTfofkFOJEROZYzYWzfo=";
      };
      file = "tmTheme/night-owlish.tmTheme";
    };
  };
}
