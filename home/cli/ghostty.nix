{ theme, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Fira Code";
      # Ghostty follows the system's dark/light setting. window-theme "system"
      # makes the title bar follow it too; "auto" would keep it on the terminal
      # background.
      theme = "light:${theme.ghostty.light},dark:${theme.ghostty.dark}";
      window-theme = "system";
    };
  };
}
