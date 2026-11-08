{ config, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "light:Light Owl,dark:Night Owl";
      font-family = [
        config.stylix.fonts.monospace.name
        config.stylix.fonts.emoji.name
      ];
      # Keep the title bar tied to GNOME rather than the terminal color scheme.
      window-theme = "system";
    };
  };
}
