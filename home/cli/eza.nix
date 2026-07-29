{ ... }:

{
  programs.eza = {
    # The bare package was never aliased, so listing files still meant typing
    # eza. The module writes ls, ll, la, lt and lla for fish.
    enable = true;
    icons = "auto";
    git = true;
  };
}
