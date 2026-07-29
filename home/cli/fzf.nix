{ theme, ... }:

{
  programs.fzf = {
    # The module writes the fish key bindings (ctrl-r, ctrl-t, alt-c); the bare
    # package never did, so history search was plain readline.
    enable = true;

    # fzf's built-in colours assume a light-ish terminal and are unreadable on
    # gruvbox. Taking them from home/theme.nix keeps them from drifting away
    # from the kitty and bat themes.
    colors = with theme.palette; {
      "bg+" = bg1;
      "fg+" = fg;
      "hl+" = yellow;
      fg = fg2;
      hl = yellow;
      header = gray;
      info = blue;
      marker = green;
      pointer = red;
      prompt = aqua;
      spinner = purple;
    };
  };
}
