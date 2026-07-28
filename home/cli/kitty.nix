{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      # Workaround for Wayland issues: https://github.com/kovidgoyal/kitty/issues/3284
      linux_display_server = "x11";
      remember_window_size = "no";
      tab_bar_style = "powerline";
    };
    font = {
      package = pkgs.fira-code;
      name = "Fira Code";
    };
    themeFile = "gruvbox-dark";
  };
}
