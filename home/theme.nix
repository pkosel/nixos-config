# Terminal colours, in one place so a scheme change is one edit. Not here on
# purpose: GTK is Adwaita-dark, and nvim picks gruvbox-material from its own lua.
{
  # gruvbox dark, only the entries fzf actually uses.
  palette = {
    bg1 = "#3c3836";
    fg = "#ebdbb2";
    fg2 = "#bdae93";
    gray = "#928374";
    red = "#fb4934";
    green = "#b8bb26";
    yellow = "#fabd2f";
    blue = "#83a598";
    purple = "#d3869b";
    aqua = "#8ec07c";
  };

  # Each tool names its themes differently; delta reads bat's set.
  bat = "gruvbox-dark";
  kitty = "gruvbox-dark";
}
