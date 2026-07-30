# Terminal colours, in one place so a scheme change is one edit. Not here on
# purpose: GTK is Adwaita-dark, and nvim picks gruvbox-material from its own lua.
let
  # gruvbox dark, only the entries fzf and eza actually use.
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

  fore = c: { foreground = c; };
in
{
  inherit palette;

  # Each tool names its themes differently; delta reads bat's set.
  bat = "gruvbox-dark";
  kitty = "gruvbox-dark";

  # eza has no named themes, so every element is spelled out. Grouped the way
  # a long listing reads: type, permissions, size, owner, date, git.
  eza = with palette; {
    filekinds = {
      normal = fore fg;
      directory = fore blue;
      executable = fore green;
      symlink = fore aqua;
      pipe = fore yellow;
      block_device = fore yellow;
      char_device = fore yellow;
      socket = fore purple;
      special = fore purple;
      mount_point = fore aqua;
    };

    # Read yellow, write red, execute green, so a stray write bit stands out.
    perms = {
      user_read = fore yellow;
      user_write = fore red;
      user_execute_file = fore green;
      user_execute_other = fore green;
      group_read = fore yellow;
      group_write = fore red;
      group_execute = fore green;
      other_read = fore yellow;
      other_write = fore red;
      other_execute = fore green;
      special_user_file = fore purple;
      special_other = fore gray;
      attribute = fore gray;
    };

    # Brighter as the file gets bigger.
    size = {
      major = fore fg2;
      minor = fore aqua;
      number_byte = fore fg;
      number_kilo = fore fg;
      number_mega = fore blue;
      number_giga = fore purple;
      number_huge = fore purple;
      unit_byte = fore fg2;
      unit_kilo = fore blue;
      unit_mega = fore blue;
      unit_giga = fore purple;
      unit_huge = fore purple;
    };

    users = {
      user_you = fore yellow;
      user_root = fore red;
      user_other = fore gray;
      group_yours = fore fg2;
      group_root = fore red;
      group_other = fore gray;
    };

    links = {
      normal = fore aqua;
      multi_link_file = fore yellow;
    };

    git = {
      new = fore green;
      modified = fore yellow;
      deleted = fore red;
      renamed = fore blue;
      typechange = fore purple;
      ignored = fore gray;
      conflicted = fore red;
    };

    punctuation = fore gray;
    date = fore blue;
    inode = fore fg2;
    blocks = fore fg2;
    header = fore fg2;
    symlink_path = fore aqua;
    broken_symlink = fore red;
    broken_path_overlay = fore red;
  };
}
