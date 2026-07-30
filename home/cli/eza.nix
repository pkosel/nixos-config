{ theme, ... }:

{
  programs.eza = {
    # The bare package was never aliased, so listing files still meant typing
    # eza. The module writes ls, ll, la, lt and lla for fish.
    enable = true;
    icons = "auto";
    git = true;

    # Written to ~/.config/eza/theme.yml, which eza reads on its own. Without it
    # eza is the one tool here still on its built-in palette.
    theme = theme.eza;
  };
}
