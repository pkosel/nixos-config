{ ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "light:Light Owl,dark:Night Owl";
      font-family = [
        "Fira Code"
        "Noto Color Emoji"
      ];
      # Keep the title bar tied to GNOME rather than the terminal color scheme.
      window-theme = "system";
    };
  };
}
