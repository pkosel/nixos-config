{ pkgs, theme, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      # Permanent, not a workaround: GNOME does no server-side decorations on
      # wayland, so kitty's own titlebar never matches. See system/desktop/x11.nix.
      linux_display_server = "x11";
      remember_window_size = "no";
      tab_bar_style = "powerline";

      # 2000 is about one nixos-rebuild log.
      scrollback_lines = 10000;
      enable_audio_bell = "no";
    };
    font = {
      package = pkgs.fira-code;
      name = "Fira Code";
    };
    themeFile = theme.kitty;
  };
}
