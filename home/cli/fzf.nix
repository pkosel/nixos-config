{ ... }:

{
  programs.fzf = {
    # The module writes the fish key bindings (ctrl-r, ctrl-t, alt-c); the bare
    # package never did, so history search was plain readline.
    enable = true;

    # fzf's built-in colours assume a light-ish terminal and are unreadable on
    # gruvbox. These match the kitty and bat themes.
    colors = {
      "bg+" = "#3c3836";
      "fg+" = "#ebdbb2";
      "hl+" = "#fabd2f";
      fg = "#bdae93";
      hl = "#fabd2f";
      header = "#928374";
      info = "#83a598";
      marker = "#b8bb26";
      pointer = "#fb4934";
      prompt = "#8ec07c";
      spinner = "#d3869b";
    };
  };
}
