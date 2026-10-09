{ theme, ... }:

{
  programs.eza = {
    # The module writes the ls, ll, la, lt and lla aliases for fish; the bare
    # package has none.
    enable = true;
    icons = "auto";
    git = true;

    # Written to ~/.config/eza/theme.yml, which eza reads on its own. Without it
    # eza keeps its built-in palette.
    theme = theme.eza;
  };
}
